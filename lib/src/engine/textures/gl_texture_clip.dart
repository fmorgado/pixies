part of pixies.engine;

class _GLTextureClip extends GLTexture {
  
  /// The root texture.
  final _GLTextureRoot _root;
  
  _GLTextureClip._(this._root);
  
  /// Activate this texture.
  void activate() {
    _root.activate();
  }
  
}
