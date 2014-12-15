part of pixies.controllers;
/*
abstract class Child<P extends Child> {
  
  P _parent;
  P get parent => _parent;
  void set parent(P value) {
    if (value == null) {
      if (_parent == null)
        throw new StateError("$this doesn't have a parent");
      
      _parent = null;
      
    } else {
      if (_parent != null)
        throw new StateError('$this already has a parent');
      
      _parent = value;
    }
  }
  
  /// The name of this instance.
  String name = '';
  
  String get fullName {
    return '';
  }
  
  void onAddedToParent() {}
  
  void onRemovedFromParent() {}
  
}
*/