part of pixies.engine;

abstract class GLTexture extends GLTextureBase {
  
  /// The list of vertices of the texture.
  final Float32List uvList = new Float32List(8);
  
  void _update(int x, int y, int width, int height, int rotation, int totalWidth, int totalHeight) {
    double dX = x / totalWidth;
    double dY = y / totalHeight;
    double dWidth = width / totalWidth;
    double dHeight = height / totalHeight;
    
    switch (rotation) {
      case 0:
        uvList[0] = uvList[6] = dX;          // x1 x4
        uvList[1] = uvList[3] = dY;          // y1 y2
        uvList[2] = uvList[4] = dX + dWidth;  // x2 x3
        uvList[5] = uvList[7] = dY + dHeight; // y3 y4
        _width = width;
        _height = height;
        break;
        
      case 1:
        uvList[4] = uvList[6] = dX;          // x1 x4
        uvList[1] = uvList[7] = dY;          // y1 y2
        uvList[0] = uvList[2] = dX + dWidth;  // x2 x3
        uvList[3] = uvList[5] = dY + dHeight; // y3 y4
        _width = height;
        _height = width;
        break;
        
      case 2:
        uvList[2] = uvList[4] = dX;          // x1 x4
        uvList[5] = uvList[7] = dY;          // y1 y2
        uvList[0] = uvList[6] = dX + dWidth;  // x2 x3
        uvList[1] = uvList[3] = dY + dHeight; // y3 y4
        _width = width;
        _height = height;
        break;
        
      case 3:
        uvList[0] = uvList[2] = dX;          // x1 x2
        uvList[3] = uvList[5] = dY;          // y1 y4
        uvList[4] = uvList[6] = dX + dHeight; // x3 x4
        uvList[1] = uvList[7] = dY + dWidth;  // y2 y3
        _width = height;
        _height = width;
        break;
        
      default:
        throw new ArgumentError('Invalid texture rotation: $rotation');
    }
  }
  
  int _width = 0;
  /// The width of the texture, in pixels.
  int get width => _width;
  
  int _height = 0;
  /// The height of the texture, in pixels.
  int get height => _height;
  
  int _rotation = 0;
  /// The rotation of the texture, a value between 0 and 3, inclusive.
  int get rotation => _rotation;
  
  /// Get the root texture.
  _GLTextureRoot get _root;
  
}
