part of pixies;

class Ellipse extends Shape {
  /// The X coordinate.
  int x;
  /// The Y coordinate.
  int y;
  /// The width of the ellipse.
  int width;
  /// The height of the ellipse.
  int height;
  
  /// Constructor.
  Ellipse(this.x, this.y, this.width, this.height);
  
  /// Create a new ellipse copying the properties from [other].
  Ellipse.copy(Ellipse other) {
    copyFrom(other);
  }
  
  /// Create a copy of this shape instance.
  Ellipse clone() => new Ellipse(x, y, width, height);
  
  /// Indicate if the ellipse contains the point ([x], [y]).
  bool contains(num x, num y) {
    if (width <= 0 || height <= 0) return false;
    
    final double normx = (x - this.x) / width;
    final double normy = (y - this.y) / height;
    
    return (normx * normx + normy * normy) <= 1;
  }
  
  /// Copy the properties of the ellipse [other] to this instance.
  void copyFrom(Ellipse other) {
    x = other.x;
    y = other.y;
    width = other.width;
    height = other.height;
  }
  
}
