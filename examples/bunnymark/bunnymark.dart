
import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;

import 'package:pixies/engine.dart';
import 'package:pixies/controllers.dart';
import 'package:pixies/stage.dart';

final Stage _stage = new Stage();
final num _gravity = 0.75;
final _random = new math.Random();

void main() {
  
  final engine = new GLEngine(
      canvas: html.querySelector('#stage'),
      statsElement: html.querySelector('#stats')
  );
  engine.backgroundColor = 0xFF784567;
  engine.objects.add(_stage);
  
  _loadTexture(engine, 'bunny.png').then((GLTexture texture) {
    _stage.children.add(new BunnyContainer(texture));
  });
}

Future<GLTextureBase> _loadTexture(GLEngine engine, String url) {
  final completer = new Completer();
  
  final image = new html.ImageElement();
  image.onLoad.listen((html.Event event) {
    completer.complete(engine.uploadTextureImage(image));
  }, onError: (error) {
    completer.completeError(error);
  });
  image.src = url;
  
  return completer.future;
}

class BunnyContainer extends RenderableContainer<Bunny> implements Animatable {
  
  static const numBunnies = 10000;
  
  final _random = new math.Random();
  final GLTexture _texture;
  
  BunnyContainer(this._texture);
  
  void _createBunnies() {
    final maxWidth = stage.stageWidth - _texture.width;
    final maxHeight = stage.stageHeight - _texture.height;
    
    for (int index = 0; index < numBunnies; index++) {
      final bunny = new Bunny(_texture, maxWidth, maxHeight);
      bunny.x = _random.nextInt(maxWidth);
      bunny.y = _random.nextInt(maxHeight);
      bunny.speedX = _random.nextDouble() * 10.0 - 5.0;
      bunny.speedY = _random.nextDouble() * 10.0 - 5.0;
      children.add(bunny);
    }
  }
  
  @override
  void onAddedToStage(Stage stage) {
    super.onAddedToStage(stage);
    stage.addAnimatable(this);
    
    _createBunnies();
  }
  
  @override
  void onRemovedFromStage(Stage stage) {
    super.onRemovedFromStage(stage);
    stage.removeAnimatable(this);
  }
  
  void advanceTime(num passedTime) {
    final list = children;
    final length = list.length;
    for (int index = 0; index < length; index++) {
      list[index].updateState();
    }
  }
  
}

class Bunny extends Bitmap {
  final int maxWidth;
  final int maxHeight;
  
  num speedX = 0.0;
  num speedY = 0.0;
  
  Bunny(GLTexture texture, this.maxWidth, this.maxHeight): super(texture);
  
  void updateState() {
    num x = this.x + speedX;
    num y = this.y + speedY;
    speedY += _gravity;
    
    if (x > maxWidth) {
      x = maxWidth;
      speedX = -speedX;
    } else if (x < 0) {
      x = 0;
      speedX = -speedX;
    }
        
    if (y > maxHeight) {
      y = maxHeight;
      speedY = -speedY * 0.9;
    } else if (y < 0) {
      y = 0;
      speedY = -speedY;
    }
    
    this.x = x;
    this.y = y;
  }
  
}
