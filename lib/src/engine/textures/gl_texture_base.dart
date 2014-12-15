part of pixies.engine;

abstract class GLTextureBase {
  
  /// The width of the texture, in pixels.
  int get width;
  
  /// The height of the texture, in pixels.
  int get height;
  
  /// The rotation of the texture, a value between 0 and 3, inclusive.
  int get rotation;
  
  /// Activate this texture.
  void activate();
  
}
