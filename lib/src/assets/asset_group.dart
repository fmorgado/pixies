part of pixies;

abstract class Asset {
  final String name;
  
  Asset(this.name);

  dynamic _data;
  dynamic get data => _data;
  
  void clear() {
    _data = null;
  }
  
  bool get isLoaded => _data != null;
  
}

class TextureSource {
  final String url;
  final String type;
  
  TextureSource(this.url, this.type);
}

class TextureAsset extends Asset {
  final dynamic source;
  final bool    pack;
  
  TextureAsset(String name, this.source, {this.pack: true}): super(name) {
    
  }
}

/*
class TextureAtlasAsset extends TextureAsset {
  
  TextureAtlasAsset(String name, String url, {bool pack: true})
      : super(name, url, pack: pack);
}

class SoundAsset extends Asset {
  final String url;
  
  SoundAsset(String name, this.url): super(name);
}
*/
