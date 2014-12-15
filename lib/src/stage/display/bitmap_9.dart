part of pixies.stage;

class Bitmap9 extends Renderable {
  
  // Holds the transformed points of the Scale9 grid, in the form:
  //    ( 0,  1) ---- ( 2,  3) ---- ( 4,  5) ---- ( 6,  7)
  //    ( 8,  9) ---- (10, 11) ---- (12, 13) ---- (14, 15)
  //    (16, 17) ---- (18, 19) ---- (20, 21) ---- (22, 23)
  //    (24, 25) ---- (26, 27) ---- (28, 29) ---- (30, 31)
  final Float32List _vertices = new Float32List(32);
  
  /// Constructor with optional [texture].
  Bitmap9([this.texture]);

  /// The Scale9 texture of the bitmap.
  GLTexture9 texture;
  
  /// Get the natural (untransformed) width of the object, in pixels.
  num get naturalWidth => texture != null ? texture.width : 0;
  
  /// Get the natural (untransformed) height of the object, in pixels.
  num get naturalHeight => texture != null ? texture.height : 0;
  
  @override
  void _updateTransform(Renderable parent) {
    super._updateTransform(parent);
    
    final a = _transform[0];
    final b = _transform[1];
    final c = _transform[2];
    final d = _transform[3];
    final tx = _transform[4];
    final ty = _transform[5];
    
    final width = texture.width;
    final height = texture.height;
    
    double x1 = (texture.left / _scaleX).abs();
    double y1 = (texture.top / _scaleY).abs();
    double right = (texture.right / _scaleX).abs();
    double bottom = (texture.bottom / _scaleY).abs();
    
    if (x1 + right > width) {
      x1 = width * (x1 / (x1 + right));
      right = width - x1;
    }
    
    if (y1 + bottom > height) {
      y1 = height * (y1 / (y1 + bottom));
      bottom = height - y1;
    }
    
    final x2 = width - right;
    final y2 = height - bottom;
    
    _vertices[0] = tx;
    _vertices[1] = ty;
    _vertices[2] = x1 * a + tx;
    _vertices[3] = x1 * b + ty;
    _vertices[4] = x2 * a + tx;
    _vertices[5] = x2 * b + ty;
    _vertices[6] = width * a + tx;
    _vertices[7] = width * b + ty;
    _vertices[8] = y1 * c + tx;
    _vertices[9] = y1 * d + ty;
    _vertices[10] = x1 * a + y1 * c + tx;
    _vertices[11] = x1 * b + y1 * d + ty;
    _vertices[12] = x2 * a + y1 * c + tx;
    _vertices[13] = x2 * b + y1 * d + ty;
    _vertices[14] = width * a + y1 * c + tx;
    _vertices[15] = width * b + y1 * d + ty;
    _vertices[16] = y2 * c + tx;
    _vertices[17] = y2 * d + ty;
    _vertices[18] = x1 * a + y2 * c + tx;
    _vertices[19] = x1 * b + y2 * d + ty;
    _vertices[20] = x2 * a + y2 * c + tx;
    _vertices[21] = x2 * b + y2 * d + ty;
    _vertices[22] = width * a + y2 * c + tx;
    _vertices[23] = width * b + y2 * d + ty;
    _vertices[24] = height * c + tx;
    _vertices[25] = height * d + ty;
    _vertices[26] = x1 * a + height * c + tx;
    _vertices[27] = x1 * b + height * d + ty;
    _vertices[28] = x2 * a + height * c + tx;
    _vertices[29] = x2 * b + height * d + ty;
    _vertices[30] = width * a + height * c + tx;
    _vertices[31] = width * b + height * d + ty;
  }
  
  @override
  void _renderContent(Stage stage, worldAlpha) {
    stage._quadProgram.renderScale9Bitmap(this, worldAlpha);
  }
  
  @override
  void _render(Stage stage, Renderable parent, double worldAlpha) {
    if (texture == null) return;
    super._render(stage, parent, worldAlpha);
  }
  
  /*
  @override
  void _render(Stage stage, Renderable parent) {
    if (texture == null) return;
    super._render(stage, parent);
  }
  */
  /*
  @override
  void _renderContent2(Stage stage) {
    stage._quadProgram.renderScale9Bitmap(this, _transform[8]);
  }
  
  @override
  void _render2(Stage stage) {
    if (texture == null) return;
    super._render2(stage);
  }
  */
}

