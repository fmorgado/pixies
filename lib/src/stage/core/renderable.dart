part of pixies.stage;

class InvalidationsType {
  static const ALL = 0xFFFFFFFF;
  static const TRANSFORM = 0x01;
}

abstract class Renderable extends Object with EventDispatcher {
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Misc Properties  //////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Indicates if the object is visible.
  bool visible = true;
  
  /// The transparency of the object, a value between 0.0 and 1.0. Default is 1.0.
  double alpha = 1.0;
  
  bool _registerOnEnterFrame = false;
  /// Indicates whether [onEnterFrame] must be called when added to the stage.
  /// Default is false.
  bool get registerOnEnterFrame => _registerOnEnterFrame;
  void set registerOnEnterFrame(bool value) {
    if (value != _registerOnEnterFrame) {
      _registerOnEnterFrame = value;
      final stage = this.stage;
      if (stage != null) {
        if (value) {
          stage._addEnterFrameListener(this);
        } else {
          stage._removeEnterFrameListener(this);
        }
      }
    }
  }
  
  bool _renderDirty = false;
  
  bool _cacheAsBitmap = false;
  bool get cacheAsBitmap => _cacheAsBitmap;
  void set cacheAsBitmap(bool value) {
    if (value == _cacheAsBitmap) return;
    
    _cacheAsBitmap = value;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  "Protected" Methods  //////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  void _handleAdded(Renderable object) {
    onAdded(object);
  }
  
  void _handleRemoved(Renderable object) {
    onRemoved(object);
  }
  
  void _handleAddedToStage(Stage stage) {
    if (_registerOnEnterFrame)
      stage._addEnterFrameListener(this);
    onAddedToStage(stage);
  }
  
  void _handleRemovedFromStage(Stage stage) {
    if (_registerOnEnterFrame)
      stage._removeEnterFrameListener(this);
    onRemovedFromStage(stage);
  }
  
  /// This method is called when an [object] is added.
  void onAdded(Renderable object) {}
  
  /// This method is called when an [object] is removed.
  void onRemoved(Renderable object) {}
  
  /// This method is called when [this] is added to the stage.
  void onAddedToStage(Stage stage) {}
  
  /// This method id called when [this] is removed from the stage.
  void onRemovedFromStage(Stage stage) {}
  
  /// This method is called on every frame while [this] is added to the stage
  /// and [registerOnEnterFrame] is true.
  void onEnterFrame(num millisecondsPassed) {}
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Display Tree Handling  ////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  RenderableContainer _parent;
  /// The parent container.
  RenderableContainer get parent => _parent;
  
  void _setParent(RenderableContainer value) {
    if (_parent == null) {
      // Checks if [this] is an ancestor of [value].
      Renderable current = value;
      do {
        if (current == this)
          throw new StateError('Cannot add an object to itself or to a descendant of itself');
        current = current._parent;
      } while (current != null);
      
      _parent = value;
      _transformDirty = true;
      
      current = this;
      do {
        current._handleAdded(this);
        current = current._parent;
      } while (current != null);
      
    } else {
      throw new StateError('${this} already has a parent ($_parent)');
    }
  }
  
  void _clearParent() {
    Renderable current = this;
    do {
      current._handleRemoved(this);
      current = current._parent;
    } while (current != null);
    
    _parent = null;
  }
  
  /// The stage this object is added to, or [null].
  Stage get stage {
    Renderable current = this;
    while (current != null) {
      if (current is Stage) break;
      current = current.parent;
    }
    return current;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Filters Handling  /////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  ListCollection<RenderFilter> _filters;
  
  /// The filters of the display object.
  ListCollection<RenderFilter> get filters {
    if (_filters == null)
      _filters = new ListCollection(onChanged: _onFiltersChanged);
    return _filters;
  }
  
  void _onFiltersChanged() {
    _renderDirty = true;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Transform Properties  /////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  num _x = 0;
  /// The X coordinate.
  num get x => _x;
  void set x(num value) {
    _x = value;
    _transformDirty = true;
  }
  
  num _y = 0;
  /// The Y coordinate.
  num get y => _y;
  void set y(num value) {
    _y = value;
    _transformDirty = true;
  }
  
  /// Set the [x] and [y] coordinates.
  void setPosition(num x, num y) {
    _x = x;
    _y = y;
    _transformDirty = true;
  }
  
  /// Get the natural (untransformed) width of the object, in pixels.
  num get naturalWidth;
  
  /// Get the natural (untransformed) height of the object, in pixels.
  num get naturalHeight;
  
  /// The width of the object.
  // TODO transform this.
  num get width => naturalWidth * _scaleX;
  void set width(num value) {
    final natural = this.naturalWidth;
    if (natural != 0) {
      final isNegative = _scaleX < 0;
      _scaleX = value / natural;
      if (isNegative) _scaleX = -_scaleX;
      _transformDirty = true;
    }
  }
  
  /// The height of the object.
  // TODO transform this.
  num get height => naturalHeight * _scaleY;
  void set height(num value) {
    final natural = this.naturalHeight;
    if (natural != 0) {
      final isNegative = _scaleY < 0;
      _scaleY = value / natural;
      if (isNegative) _scaleY = -_scaleY;
      _transformDirty = true;
    }
  }
  
  /// Set the [width] and [height] of the object.
  void setSize(num width, num height) {
    this.width = width;
    this.height = height;
  }
  
  double _scaleX = 1.0;
  /// The horizontal scale ratio.
  double get scaleX => _scaleX;
  void set scaleX(double value) {
    _scaleX = value;
    _transformDirty = true;
  }
  
  double _scaleY = 1.0;
  /// The vertical scale ratio.
  double get scaleY => _scaleY;
  void set scaleY(double value) {
    _scaleY = value;
    _transformDirty = true;
  }
  
  /// Set the horizontal and vertical scales to [scaleX] and [scaleY], respectively.
  void setScale(double scaleX, double scaleY) {
    _scaleX = scaleX;
    _scaleY = scaleY;
    _transformDirty = true;
  }
  
  /// Set both [scaleX] and [scaleY] to the same [value].
  void set scale(double value) {
    _scaleX = value;
    _scaleY = value;
    _transformDirty = true;
  }
  
  double _rotation = 0.0;
  /// The rotation, in radians.
  double get rotation => _rotation;
  void set rotation(double value) {
    _rotation = value;
    _transform[6] = math.cos(value);
    _transform[7] = math.sin(value);
    _transformDirty = true;
  }
  
  num _pivotX = 0;
  /// The horizontal pivot offset, in pixels.
  num get pivotX => _pivotX;
  void set pivotX(num value) {
    _pivotX = value;
    _transformDirty = true;
  }
  
  num _pivotY = 0;
  /// The vertical pivot offset, in pixels.
  num get pivotY => _pivotY;
  void set pivotY(num value) {
    _pivotY = value;
    _transformDirty = true;
  }
  
  /// Set the horizontal and vertical pivots to [pivotX] and [pivotY], respectively.
  void setPivot(num pivotX, num pivotY) {
    _pivotX = pivotX;
    _pivotY = pivotY;
    _transformDirty = true;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Transform Handling  ///////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Holds the transformation values.
  /// 00 -> The 'a' value of the global 2x2 transformation matrix.
  /// 01 -> The 'b' value of the global 2x2 transformation matrix.
  /// 02 -> The 'c' value of the global 2x2 transformation matrix.
  /// 03 -> The 'd' value of the global 2x2 transformation matrix.
  /// 04 -> The global translation on the X axis.
  /// 05 -> The global translation on the Y axis.
  /// 06 -> The [math.cos] result of the current rotation.
  /// 07 -> The [math.sin] result of the current rotation.
  final Float32List _transform = new Float32List(8);
  bool _transformDirty = false;
  bool _transformUpdated = false;
  
  void _updateTransform(Renderable parent) {
    final oData = parent._transform;
    double a2 =  oData[0];
    double b2 =  oData[1];
    double c2 =  oData[2];
    double d2 =  oData[3];
    
    if (_rotation == 0.0) {
      double tx = _x - _pivotX * _scaleX;
      double ty = _y - _pivotY * _scaleY;
      
      _transform[0] = _scaleX * a2;
      _transform[1] = _scaleX * b2;
      _transform[2] = _scaleY * c2;
      _transform[3] = _scaleY * d2;
      _transform[4] = tx * a2 + ty * c2 + oData[4];
      _transform[5] = tx * b2 + ty * d2 + oData[5];
      
    } else {
      final rotationCos = _transform[6];
      final rotationSin = _transform[7];
      
      double a = _scaleX * rotationCos;
      double b = _scaleX * rotationSin;
      double c = -_scaleY * rotationSin;
      double d = _scaleY * rotationCos;
      double tx =  x - (_pivotX * a + _pivotY * c);
      double ty =  y - (_pivotX * b + _pivotY * d);
      
      _transform[0] = a * a2 + b * c2;
      _transform[1] = a * b2 + b * d2;
      _transform[2] = c * a2 + d * c2;
      _transform[3] = c * b2 + d * d2;
      _transform[4] = tx * a2 + ty * c2 + oData[4];
      _transform[5] = tx * b2 + ty * d2 + oData[5];
    }
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Bounds Handling  //////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  void _updateLocalTransform() {
    if (_rotation == 0.0) {
      _transform[08] = _scaleX;
      _transform[09] = 0.0;
      _transform[10] = 0.0;
      _transform[11] = _scaleY;
      _transform[12] = _x - _pivotX * _scaleX;
      _transform[13] = _y - _pivotY * _scaleY;
      
    } else {
      final rotationCos = _transform[12];
      final rotationSin = _transform[13];
      
      final a = _scaleX * rotationCos;
      final b = _scaleX * rotationSin;
      final c = -_scaleY * rotationSin;
      final d = _scaleY * rotationCos;
      
      _transform[08] = a;
      _transform[09] = b;
      _transform[10] = c;
      _transform[11] = d;
      _transform[12] = x - (_pivotX * a + _pivotY * c);
      _transform[13] = y - (_pivotX * b + _pivotY * d);
    }
  }
  
  /// Get the bounds of the object relative to its parent.
  Rectangle<num> getLocalBounds([Rectangle<num> output = null]) {
    if (output == null)
      output = new Rectangle<num>(0, 0, 0, 0);
    
    final width = naturalWidth;
    final height = naturalHeight;
    
    if (_rotation == 0.0) {
      double a = _scaleX;
      double b = 0.0;
      double c = 0.0;
      double d = _scaleY;
      
    } else {
      final rotationCos = _transform[6];
      final rotationSin = _transform[7];
      
      double a = _scaleX * rotationCos;
      double b = _scaleX * rotationSin;
      double c = -_scaleY * rotationSin;
      double d = _scaleY * rotationCos;
    }
    
    return output;
  }
  
  /*
  /// Get the global bounds of the object.
  Rectangle<num> getGlobalBounds([Rectangle<num> output = null]) {
    if (output == null)
      output = new Rectangle<num>(0, 0, 0, 0);
    
    final width = naturalWidth;
    final height = naturalHeight;
    
    final newWidth = width * _transform[0] + height * _transform[2];
    final newHeight = width * _transform[1] + height * _transform[3];
    
    if (newWidth < 0) {
      output.x = _transform[4] + newWidth;
      output.width = -newWidth;
    } else {
      output.x = _transform[4];
      output.width = newWidth;
    }
    
    if (newHeight < 0) {
      output.y = _transform[5] + newHeight;
      output.height = -newHeight;
    } else {
      output.y = _transform[5];
      output.height = newHeight;
    }
    
    // TODO cicle parents to find out if there are global transformations (Sprite3D? Camera?)
    
    return output;
  }
  */
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Render Methods  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  void _renderContent(Stage stage, double worldAlpha);
  
  void _render(Stage stage, Renderable parent, double worldAlpha) {
    if (_transformDirty || parent._transformUpdated) {
      _updateTransform(parent);
      _transformDirty = false;
      _transformUpdated = true;
    } else {
      _transformUpdated = false;
    }
    _renderContent(stage, worldAlpha * alpha);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  PreRender Handling  ///////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  void _onPreRender(Stage stage) {
    
  }
  
}
