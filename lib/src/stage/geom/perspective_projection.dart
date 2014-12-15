part of pixies.stage;

// https://github.com/openfl/openfl/blob/master/openfl/geom/PerspectiveProjection.hx
// http://blogoben.wordpress.com/2011/06/05/webgl-basics-5-full-transformation-matrix/

class PerspectiveProjection {
  
  static final defaultInstance = new PerspectiveProjection(10000, 10);
  
  /// The depth of the projection.
  final num depth;
  /// The scale of the projection.
  final num scale;
  
  const PerspectiveProjection(this.depth, this.scale);
}
