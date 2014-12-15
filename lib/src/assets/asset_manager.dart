part of pixies;

class AssetManager {
  // Textures, texture atlases, bitmap fonts, sounds, Json data, binary data
  final _assets = <String, Asset>{};
  
  final Stage stage;
  
  final Map<String, GLTextureBase> _textures = <String, GLTextureBase>{};
  
  AssetManager(this.stage);
  
  Asset getAsset(String name) => _assets[name];
  
  void addAsset(Asset asset) {
    final name = asset.name;
    final existing = getAsset(name);
    if (existing != null)
      throw new ArgumentError('Conflicting resource name: $name');
    _assets[name] = asset;
  }
  
  void addTexture(String name, String url, {bool pack: true}) {
    addAsset(new TextureAsset(name, url, pack: pack));
  }
  
  /*void addTextureAtlas(String name, String url, {bool pack: true}) {
    addResource(new TextureAtlasAsset(name, url, pack: pack));
  }*/
  
  /*void addSound(String name, String url) {
    addResource(new SoundAsset(name, url));
  }*/
  
  //void addGroup(String name, )
  
  GLTextureBase getTexture(String name) {
    return null;
  }
  
  
  
}
