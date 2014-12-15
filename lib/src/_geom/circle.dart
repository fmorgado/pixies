part of pixies;

class Circle extends Shape {
  /// The X coordinate.
  int x;
  /// The Y coordinate.
  int y;
  /// The radius of the circle.
  num radius;
  
  /// Constructor.
  Circle(this.x, this.y, this.radius);
  
  /// Create a new circle copying the properties from [other].
  Circle.copy(Circle other) {
    copyFrom(other);
  }
  
  /// Create a copy of this shape instance.
  Circle clone() => new Circle(x, y, radius);
  
  /// Indicate if the circle contains the point ([x], [y]).
  bool contains(num x, num y) {
    var dx = this.x - x;
    var dy = this.y - y;
    return dx * dx + dy * dy < radius * radius;
  }

  /// Copy the properties of the circle [other] to this instance.
  void copyFrom(Circle other) {
    x = other.x;
    y = other.y;
    radius = other.radius;
  }
  
}
