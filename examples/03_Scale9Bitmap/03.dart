
import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;

import 'package:pixies/engine.dart';
import 'package:pixies/stage.dart';

void main() {
  final engine = new GLEngine(
      canvas: html.querySelector('#stage'),
      backgroundColor: 0xFF784567
  );
  final stage = new MyStage();
  engine.objects.add(stage);
  
  html.querySelector("#scaleButton")
      ..onClick.listen((_) { stage.rescale(); });
  html.querySelector("#rotationButton")
      ..onClick.listen((_) { stage.rerotate(); });
}

class MyStage extends Stage {
  
  final _random = new math.Random();
  Bitmap9 _bitmap;
  
  void rescale() {
    if (_bitmap != null) {
      final max = (stageWidth > stageHeight ? stageHeight : stageWidth) - 100;
      _bitmap.width = (_random.nextDouble() * max + 100);
      _bitmap.height = (_random.nextDouble() * max + 100);
    }
  }
  
  void rerotate() {
    if (_bitmap != null) {
      _bitmap.rotation = _random.nextDouble() * math.PI * 2;
    }
  }
  
  @override
  void createGraphics() {
    super.createGraphics();
    _loadTexture(engine, '../assets/button.jpg').then(_createScale9Bitmap);
  }
  
  void _createScale9Bitmap(GLTextureBase texture) {
    final texture9 = new GLTexture9(texture, 30, 30, 140, 140);
    _bitmap = new Bitmap9(texture9);
    _bitmap.setPivot(texture.width / 2, texture.height / 2);
    _bitmap.x = stageWidth / 2;
    _bitmap.y = stageHeight / 2;
    children.add(_bitmap);
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
