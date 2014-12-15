part of pixies;

/// Represents a point on a cartesian plane.
class Point<T extends num> {
  /// The X coordinate.
  T x;
  /// The Y coordinate.
  T y;
  
  /// Constructor.
  Point(this.x, this.y);
  
  /// Create a copy of this instance.
  Point<T> clone() => new Point<T>(x, y);
  
}
