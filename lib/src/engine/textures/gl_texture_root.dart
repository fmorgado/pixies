part of pixies.engine;

class _GLTextureRoot extends GLTexture {
  /// The Pixies engine this texture belongs to.
  final GLEngine engine;
  
  gl.Texture _rawTexture;
  
  _GLTextureRoot(this.engine);
  
  _GLTextureRoot.fromImage(this.engine, html.ImageElement image, [int rotation = 0]) {
    final context = engine._rawContext;
    final rawTexture = context.createTexture();
    
    context.activeTexture(gl.TEXTURE0);
    context.bindTexture(gl.TEXTURE_2D, rawTexture);
    context.texImage2DImage(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);
    
    //context.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    //context.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST);
    
    context.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    context.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    context.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    context.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    
    context.bindTexture(gl.TEXTURE_2D, null);
    
    _update(0, 0, image.naturalWidth, image.naturalHeight, rotation, image.naturalWidth, image.naturalHeight);
    _rawTexture = rawTexture;
  }
  
  void _clear() {
    _rawTexture = null;
  }
  
  bool _activated = false;
  
  /// Activate this texture.
  void activate() {
    if (! _activated) {
      engine._setActiveTexture(this);
      _activated = true;
      final context = engine._rawContext;
      context.activeTexture(gl.TEXTURE0);
      context.bindTexture(gl.TEXTURE_2D, _rawTexture);
    }
  }
  
  _GLTextureRoot get _root => this;
  
  //GLTextureClip clip(int x, int y, int width, int height, int rotation) {}
  
}
