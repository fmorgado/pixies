part of pixies;

class AssetPack {
  final _assets = <String, Asset>{};
  final _packs = <String, AssetPack>{};
  
  /// Constructor.
  AssetPack();
  
  AssetPack _parent;
  /// The parent asset pack.
  AssetPack get parent => _parent;
  
  dynamic operator [](String name) {
    final asset = getAsset(name);
    return asset != null ? asset.data : null;
  }
  
  Asset getAsset(String name) {
    final dotIndex = name.indexOf('.');
    if (dotIndex == -1)
      return _assets[name];
    
    final pack = _packs[name.substring(0, dotIndex)];
    if (pack == null)
      return null;
    
    return pack.getAsset(name.substring(dotIndex + 1));
  }
  
}
