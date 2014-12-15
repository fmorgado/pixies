
import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;

import 'package:pixies/engine.dart';
import 'package:pixies/stage.dart';

GLEngine _engine;
Stage _stage;
MySprite _sprite;

void main() {
  _engine = new GLEngine(
      canvas: html.querySelector('#stage'),
      statsElement: html.querySelector('#stats')
  );
  _engine.backgroundColor = 0xFF784567;
  _stage = new Stage();
  _engine.objects.add(_stage);

  final f1 = _loadTexture(_engine, 'grid.jpg');
  final f2 = _loadTexture(_engine, 'icon.png');
  Future.wait([f1, f2]).then((List textures) {
    _sprite = new MySprite(textures[0], textures[1]);
    _stage.children.add(_sprite);
  });
  
  html.querySelector("#resetButton").onClick.listen((_) {
    _stage.children.remove(_sprite);
    _stage.children.add(_sprite);
  });
  html.querySelector("#testButton").onClick.listen((_) {
    //_sprite.testIt();
    //_stage.rotationZ += 0.05;
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

class MySprite extends Sprite3D {
  
  static const numBitmaps = 10;
  
  final _random = new math.Random();
  final _bitmaps = <Bitmap>[];
  
  final GLTexture backTexture;
  final GLTexture iconTexture;
  
  MySprite(this.backTexture, this.iconTexture) {
    registerOnEnterFrame = true;
  }
  
  @override
  void onAddedToStage(Stage stage) {
    super.onAddedToStage(stage);
    
    x = pivotX = stage.stageWidth / 2;
    y = pivotY = stage.stageHeight / 2;
    
    final background = new Bitmap(backTexture);
    background.width = stage.stageWidth;
    background.height = stage.stageHeight;
    children.add(background);
    
    for (int index = 0; index < numBitmaps; index++) {
      final half = iconTexture.width ~/ 2;
      final bitmap = new Bitmap(iconTexture);
      bitmap.setPosition(_random.nextInt(stage.stageWidth - iconTexture.width) + half, _random.nextInt(stage.stageHeight - iconTexture.height) + half);
      bitmap.setPivot(half, half);
      children.add(bitmap);
      if (index.isEven)
        _bitmaps.add(bitmap);
    }
  }
  
  @override
  void onRemovedFromStage(Stage stage) {
    super.onRemovedFromStage(stage);
    
    children.clear();
    _bitmaps.clear();
  }
  
  @override
  void onEnterFrame(num millisecondsPassed) {
    rotationX += 0.02;
    //rotation += 0.08;
    final length = _bitmaps.length;
    for (int index = 0; index < length; index++)
      _bitmaps[index].rotation += 0.1;
  }
  
}
