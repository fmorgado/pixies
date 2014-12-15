part of pixies.stage;

class Sprite3D extends Sprite {
  final _matrix = new Matrix3D.identity();
  bool _matrixDirty = false;
  
  
  num _rotationX = 0.0;
  /// The rotation around the X axis and the pivot point.
  num get rotationX => _rotationX;
  void set rotationX(num value) {
    _rotationX = value;
    _matrixDirty = true;
  }
  
  num _rotationY = 0.0;
  /// The rotation around the Y axis and the pivot point.
  num get rotationY => _rotationY;
  void set rotationY(num value) {
    _rotationY = value;
    _matrixDirty = true;
  }
  
  num _rotationZ = 0.0;
  /// The rotation around the Z axis and the pivot point.
  num get rotationZ => _rotationZ;
  void set rotationZ(num value) {
    _rotationZ = value;
    _matrixDirty = true;
  }
  
  num _offsetX = 0.0;
  num get offsetX => _offsetX;
  void set offsetX(num value) {
    _offsetX = value;
    _matrixDirty = true;
  }
  
  num _offsetY = 0.0;
  num get offsetY => _offsetY;
  void set offsetY(num value) {
    _offsetY = value;
    _matrixDirty = true;
  }
  
  num _offsetZ = 0.0;
  num get offsetZ => _offsetZ;
  void set offsetZ(num value) {
    _offsetZ = value;
    _matrixDirty = true;
  }
  
  PerspectiveProjection _perspectiveProjection;
  /// The perspective projection.
  PerspectiveProjection get perspectiveProjection =>
      _perspectiveProjection == null
          ? PerspectiveProjection.defaultInstance
          : _perspectiveProjection;
  void set perspectiveProjection(PerspectiveProjection value) {
    _perspectiveProjection = value;
    _matrixDirty = true;
  }
  
  @override
  void _render(Stage stage, Renderable parent, double worldAlpha) {
    if (_matrixDirty) {
      _matrixDirty = false;
      
      _matrix.setIdentity();
      _matrix.translateXY(-_pivotX, -_pivotY);
      if (_rotationX != 0.0) _matrix.rotateX(_rotationX);
      if (_rotationY != 0.0) _matrix.rotateY(_rotationY);
      if (_rotationZ != 0.0) _matrix.rotateZ(_rotationZ);
      _matrix.translate(_offsetX + _pivotX, _offsetY + _pivotY, _offsetZ);
      _matrix.applyPerspective(perspectiveProjection);
    }
    
    final oldPerspective = stage.perspective;
    stage.perspective = _matrix;
    super._render(stage, parent, worldAlpha);
    stage.perspective = oldPerspective;
  }
  
}
