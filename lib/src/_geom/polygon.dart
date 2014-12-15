part of pixies;

class Polygon extends Shape {
  /// The list of points defining this shape.
  List<Point<num>> points;
  
  /// Constructor.
  Polygon(this.points);
  
  /// Create a new polygon copying the properties from [other].
  Polygon.copy(Polygon other) {
    copyFrom(other);
  }
  
  /// Create a copy of this instance.
  Polygon clone() => new Polygon.copy(this);
  
  /// Copy the properties of the polygon [other] to this instance.
  void copyFrom(Polygon other) {
    final others = other.points;
    final length = others.length;
    final list = new List(length);
    
    for (int index = 0; index < length; index++)
      list[index] = others[index].clone();
    
    points = list;
  }
  
  /// Indicate if the shape contains the point ([x], [y]).
  bool contains(num x, num y) {
    bool inside = false;
    
    final length = points.length;
    // use some raycasting to test hits
    // https://github.com/substack/point-in-polygon/blob/master/index.js
    for (int i = 0, j = length - 1; i < length; j = i++) {
      final pi = points[i];
      final xi = pi.x;
      final yi = pi.y;
      
      final pj = points[j];
      final xj = pj.x;
      final yj = pj.y;

      final bool intersect = ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
      if (intersect) inside = !inside;
    }
    
    return inside;
  }
  
}
