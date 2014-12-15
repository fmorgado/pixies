
import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;

import 'package:pixies/engine.dart';
import 'package:pixies/stage.dart';

void main() {
  final _random = new math.Random();
  
  final engine = new GLEngine(
      canvas: html.querySelector('#stage'),
      statsElement: html.querySelector('#stats')
  );
  engine.backgroundColor = 0xFF784567;
  final stage = new MyStage();
  engine.objects.add(stage);
  
  html.querySelector("#togglePlayingButton")
      ..onClick.listen((_) { stage.moveIt = ! stage.moveIt; });
}

class MyStage extends Stage {
  
  static const numBitmaps = 50;
  
  final _random = new math.Random();
  final _bitmaps = <Bitmap>[];
  
  bool moveIt = false;
  
  MyStage();
  
  @override
  void createGraphics() {
    super.createGraphics();
    _loadTexture(engine, '../assets/head.png').then(_createBitmaps);
  }
  
  void _createBitmaps(GLTexture texture) {
    for (int index = 0; index < numBitmaps; index++) {
      final half = texture.width ~/ 2;
      final bitmap = new Bitmap(texture);
      bitmap.setPosition(_random.nextInt(stageWidth - texture.width) + half, _random.nextInt(stageHeight - texture.height) + half);
      bitmap.setPivot(half, half);
      children.add(bitmap);
      if (index.isEven)
        _bitmaps.add(bitmap);
    }
  }
  
  @override
  void advanceTime(num passedMilliseconds) {
    if (moveIt) {
      final length = _bitmaps.length;
      for (int index = 0; index < length; index++)
        _bitmaps[index].rotation += 0.1;
    }
    super.advanceTime(passedMilliseconds);
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
  
}
