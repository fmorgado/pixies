part of pixies.controllers;

class Controller<P extends Controller>
    extends Object
    with EventDispatcher, Logger {
  
  P _parent;
  /// The parent controller.
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
  
  void onAdded() {}
  
  void onRemoved() {}
  
}
