part of pixies.engine;

class GLTexture9 extends GLTextureBase {
  
  final _GLTextureRoot _root;
  final uvList = new Float32List(12);
  
  GLTexture9(GLTexture texture, int left, int top, int width, int height)
      : _root = texture._root,
        rotation = texture.rotation,
        width = texture.width,
        height = texture.height,
        this.left = left,
        this.top = top,
        this.right = texture.width - left - width,
        this.bottom = texture.height - top - height {
    
    final x2 = left + width;
    final y2 = top + height;
    
    if (left < 0 || top < 0 || width < 0 || height < 0)
      throw new ArgumentError('Scale9 arguments cannot be negative');
    if (x2 > texture.width)
      throw new ArgumentError('Scale9 width exceeds texture width');
    if (y2 > texture.height)
      throw new ArgumentError('Scale9 height exceeds texture height');
    
    final uvTexture = texture.uvList;
    uvList[0] = uvTexture[0]; // x1
    uvList[1] = uvTexture[1]; // y1
    uvList[2] = uvTexture[2]; // x2
    uvList[3] = uvTexture[3]; // y2
    uvList[4] = uvTexture[4]; // x3
    uvList[5] = uvTexture[5]; // y3
    uvList[6] = uvTexture[6]; // x4
    uvList[7] = uvTexture[7]; // y4
    
    final xRange = uvTexture[2] - uvTexture[0];
    final yRange = uvTexture[7] - uvTexture[1];
    
    uvList[8] = (left / this.width) * xRange + uvTexture[0];
    uvList[9] = (top / this.height) * yRange + uvTexture[1];
    uvList[10] = (x2 / this.width) * xRange + uvTexture[0];
    uvList[11] = (y2 / this.height) * yRange + uvTexture[1];
  }
  
  /// The width of the texture, in pixels.
  final int width;
  /// The height of the texture, in pixels.
  final int height;
  
  /// The width of the left column, in pixels.
  final int left;
  /// The width of the right column, in pixels.
  final int right;
  /// The height of the top row, in pixels.
  final int top;
  /// The height of the bottom row, in pixels.
  final int bottom;
  /// The rotation of the texture.
  final int rotation;
  
  /// Activate this texture.
  void activate() {
    _root.activate();
  }
  
}
