part of pixies.stage;

class Stage extends RenderableContainer<Renderable> with Animator implements GLObject {
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Event Types  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// The type of the event dispatched when an object is added to the stage.
  static const String ADDED = 'added';
  /// The type of the event dispatched when an object is removed from the stage.
  static const String REMOVED = 'removed';
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Constructor  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /// Constructor.
  Stage() {
    _transform[0] = _transform[3] = 1.0;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Misc Overrides  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  @override
  void _setParent(RenderableContainer value) {
    throw new StateError('Cannot add a Stage to a container');
  }
  
  @override
  void _handleAdded(Renderable object) {
    super._handleAdded(object);
    object._handleAddedToStage(this);
    dispatchEventWith(ADDED, object);
  }
  
  @override
  void _handleRemoved(Renderable object) {
    super._handleRemoved(object);
    object._handleRemovedFromStage(this);
    dispatchEventWith(REMOVED, object);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Size Properties  //////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /// The width of the stage, in pixels.
  int get stageWidth => engine.width;
  /// The height of the stage, in pixels.
  int get stageHeight => engine.height;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Projection Handling  //////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  final Matrix3D _projection = new Matrix3D.identity();
  
  void _updateProjection() {
    if (_perspective != null) {
      _projection.copyFrom(_perspective);
    } else {
      _projection.setIdentity();
    }
    
    _projection.scaleXY(2 / stageWidth, -2 / stageHeight);
    _projection.translateXY(-1.0, 1.0);
    
    _quadProgram.projection = _projection;
  }
  
  Matrix3D _perspective;
  // The current 3D perspective of the stage.
  // Modified by [Sprite3D.render].
  Matrix3D get perspective => _perspective;
  void set perspective(Matrix3D value) {
    _perspective = value;
    _updateProjection();
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  GLObject Implementation  //////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  _QuadProgram _quadProgram;
  
  GLEngine _engine;
  /// The associated [GLEngine] instance.
  GLEngine get engine => _engine;
  void set engine(GLEngine value) {
    if (value == null) {
      if (_engine == null)
        throw new StateError('engine not set');
      destroyGraphics();
      _engine = null;
      
    } else {
      if (_engine != null)
        throw new StateError('engine already set');
      _engine = value;
      if (! value.isContextLost)
        createGraphics();
    }
  }
  
  void createGraphics() {
    final context = _engine.rawContext;
    _quadProgram = new _QuadProgram(_engine);
    _updateProjection();
  }
  
  @override
  void advanceTime(num millisecondsPassed) {
    _dispatchEnterFrame(millisecondsPassed);
    super.advanceTime(millisecondsPassed);
    
    //this._renderContent(this, 1.0);
    final length = _children.length;
    for (int index = 0; index < length; index++) {
      final child = _children[index];
      if (child.visible && child.alpha > 0.0) {
        child._render(this, this, 1.0);
      }
    }
  }
  
  void destroyGraphics() {
    final context = _engine.rawContext;
    if (context != null) {
      _quadProgram.destroy();
    }
    _quadProgram = null;
  }
  
  void setGraphicsSize(int width, int height) {
    _updateProjection();
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  EnterFrame Handling  //////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  final _enterFrameListeners = <Renderable>[];
  
  void _addEnterFrameListener(Renderable object) {
    final length = _enterFrameListeners.length;
    for (int index = 0; index < length; index++) {
      if (_enterFrameListeners[index] == null) {
        _enterFrameListeners[index] = object;
        return;
      }
    }
    _enterFrameListeners.add(object);
  }
  
  void _removeEnterFrameListener(Renderable object) {
    final index = _enterFrameListeners.indexOf(object);
    if (index >= 0)
      _enterFrameListeners[index] = null;
  }
  
  void _dispatchEnterFrame(num millisecondsPassed) {
    final length = _enterFrameListeners.length;
    for (int index = 0; index < length; index++) {
      final object = _enterFrameListeners[index];
      if (object != null)
        object.onEnterFrame(millisecondsPassed);
    }
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  PreRender Handling  ///////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  final _preRenderListeners = <Renderable>[];
  
  void _addPreRenderListener(Renderable object) {
    final length = _preRenderListeners.length;
    for (int index = 0; index < length; index++) {
      if (_preRenderListeners[index] == null) {
        _preRenderListeners[index] = object;
        return;
      }
    }
    _preRenderListeners.add(object);
  }
  
  void _removePreRenderListener(Renderable object) {
    final index = _preRenderListeners.indexOf(object);
    if (index >= 0)
      _preRenderListeners[index] = null;
  }
  
  void _dispatchPreRender() {
    final length = _preRenderListeners.length;
    for (int index = 0; index < length; index++) {
      final object = _preRenderListeners[index];
      if (object != null)
        object._onPreRender(this);
    }
  }
  
}
