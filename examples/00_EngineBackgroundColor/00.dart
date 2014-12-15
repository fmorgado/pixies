
import 'dart:html' as html;
import 'dart:math' as math;

import 'package:pixies/engine.dart';

void main() {
  final _random = new math.Random();
  final engine = new GLEngine(canvas: html.querySelector('#stage'));
  engine.backgroundColor = 0xFF784567;
  
  html.querySelector("#changeBackgroundButton")
      ..onClick.listen((_) { engine.backgroundColor = _random.nextInt(0xFFFFFF) | 0xFF000000; });
}
