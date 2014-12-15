part of pixies.stage;

/// Represents a rectangle area on a cartesian plane.
class Rectangle<T extends num> extends Shape {
  /// The X coordinate.
  T x;
  /// The Y coordinate.
  T y;
  /// The width of the rectangle.
  T width;
  /// The height of the rectangle.
  T height;
  
  /// Constructor.
  Rectangle(this.x, this.y, this.width, this.height);
  
  /// Create a new rectangle copying the properties from [other].
  Rectangle.copy(Rectangle<T> other) {
    copyFrom(other);
  }
  
  /// Create a copy of this instance.
  Rectangle<T> clone() => new Rectangle<T>(x, y, width, height);
  
  /// Indicate if the rectangle contains the point ([x], [y]).
  bool contains(num x, num y) =>
      x >= this.x &&
      y >= this.y &&
      x <= this.x + width &&
      y <= this.y + height;
  
  /// Copy the properties of the rectangle [other] to this instance.
  void copyFrom(Rectangle<T> other) {
    x = other.x;
    y = other.y;
    width = other.width;
    height = other.height;
  }
  
}
