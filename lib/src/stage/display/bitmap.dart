part of pixies.stage;

class Bitmap extends Renderable {

  // Holds the transformed points of the texture, in the form:
  //    (0, 1) ---- (2, 3)
  //    (6, 7) ---- (4, 5)
  final Float32List _vertices = new Float32List(8);
  
  Bitmap([this.texture]);

  /// The texture of the bitmap.
  GLTextureBase texture;
  
  /// Get the natural (untransformed) width of the object, in pixels.
  num get naturalWidth => texture != null ? texture.width : 0;
  
  /// Get the natural (untransformed) height of the object, in pixels.
  num get naturalHeight => texture != null ? texture.height : 0;
  
  @override
  void _updateTransform(Renderable parent) {
    super._updateTransform(parent);
    
    final width = texture.width;
    final height = texture.height;
    
    final tx = _transform[4];
    final ty = _transform[5];
    final widthA = _transform[0] * width;
    final widthB = _transform[1] * width;
    final heightC = _transform[2] * height;
    final heightD = _transform[3] * height;
    
    _vertices[0] = tx;
    _vertices[1] = ty;
    _vertices[2] = widthA + tx;
    _vertices[3] = widthB + ty;
    _vertices[4] = widthA + heightC + tx;
    _vertices[5] = widthB + heightD + ty;
    _vertices[6] = heightC + tx;
    _vertices[7] = heightD + ty;
  }
  
  @override
  void _renderContent(Stage stage, double worldAlpha) {
    stage._quadProgram.renderBitmap(this, worldAlpha);
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
    stage._quadProgram.renderBitmap(this, _transform[8]);
  }
  
  @override
  void _render2(Stage stage) {
    if (texture == null) return;
    super._render2(stage);
  }
  */
}
