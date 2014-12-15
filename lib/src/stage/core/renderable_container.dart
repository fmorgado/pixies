part of pixies.stage;

class RenderableContainer<T extends Renderable> extends Renderable {
  
  /// Constructor.
  RenderableContainer() {
    _childrenCollection = new ListCollection(source: _children, onAdded: _onChildAdded, onRemoved: _onChildRemoved);
  }
  
  /// Get the natural (untransformed) width of the object, in pixels.
  num get naturalWidth => 100;
  
  /// Get the natural (untransformed) height of the object, in pixels.
  num get naturalHeight => 100;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Children Handling  ////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  final List<T> _children = <T>[];
  ListCollection<T> _childrenCollection;
  /// The child display objects.
  ListCollection<T> get children => _childrenCollection;
  
  void _onChildAdded(T child) {
    child._setParent(this);
  }
  
  void _onChildRemoved(T child) {
    child._clearParent();
  }
  
  @override
  void _handleAddedToStage(Stage stage) {
    super._handleAddedToStage(stage);
    
    final length = _children.length;
    for (int index = 0; index < length; index++)
      _children[index]._handleAddedToStage(stage);
  }
  
  @override _handleRemovedFromStage(Stage stage) {
    super._handleRemovedFromStage(stage);

    final length = _children.length;
    for (int index = 0; index < length; index++)
      _children[index]._handleRemovedFromStage(stage);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Render Methods  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  @override
  void _renderContent(Stage stage, double worldAlpha) {
    final length = _children.length;
    for (int index = 0; index < length; index++) {
      final child = _children[index];
      if (child.visible && child.alpha > 0.0)
        child._render(stage, this, worldAlpha);
    }
  }
  
}
