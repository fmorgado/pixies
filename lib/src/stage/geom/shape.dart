part of pixies.stage;

abstract class Shape {
  
  /// Create a copy of this shape instance.
  Shape clone();
  
  /// Indicate if the shape contains the point ([x], [y]).
  bool contains(num x, num y);
  
}
