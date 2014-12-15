part of pixies.engine;

abstract class GLProgram {
  
  static gl.Shader _createShader(gl.RenderingContext context, int type, String source) {
    final shader = context.createShader(type);
    context.shaderSource(shader, source);
    context.compileShader(shader);
    
    final compileStatus = context.getShaderParameter(shader, gl.COMPILE_STATUS);
    final isContextLost = context.isContextLost();
    if (compileStatus == false && isContextLost == false)
      throw new StateError(context.getShaderInfoLog(shader));
    
    return shader;
  }
  
  /// Create and compile a WebGL program on the given [context]
  /// using the specified [vertexSource] and [fragmentSource].
  static gl.Program compile(gl.RenderingContext context, String vertexSource, String fragmentSource) {
    final vertex = _createShader(context, gl.VERTEX_SHADER, vertexSource);
    final fragment = _createShader(context, gl.FRAGMENT_SHADER, fragmentSource);
    
    final program = context.createProgram();
    context.attachShader(program, vertex);
    context.attachShader(program, fragment);
    context.linkProgram(program);
    
    final linkStatus = context.getProgramParameter(program, gl.LINK_STATUS);
    final isContextLost = context.isContextLost();
    if (linkStatus == false && isContextLost == false)
      throw new StateError(context.getProgramInfoLog(program));
    
    context.deleteShader(vertex);
    context.deleteShader(fragment);
    
    return program;
  }
  
  /// The GL engine this program belongs to.
  final GLEngine engine;
  /// The WebGL context.
  final gl.RenderingContext rawContext;
  final gl.Program _rawProgram;
  
  /// Constructor.
  GLProgram(GLEngine engine, this._rawProgram)
      : this.engine = engine,
        rawContext = engine.rawContext;
  
  bool _active = false;
  /// Indicates if [this] is the program currently in use in the engine.
  bool get active => _active;
  
  /// Configure the program after it has been configured.
  void configureProgram();
  
  /// Activate the program.
  void activate() {
    if (! _active) {
      engine._setActiveProgram(this);
      _active = true;
      rawContext.useProgram(_rawProgram);
      configureProgram();
    }
  }
  
  // Flush and deactivates the program.
  void _deactivate() {
    flush();
    _active = false;
  }
  
  /// Flush pending operations.
  void flush();
  
  /// Destroy all GPU objects.
  void destroy() {
    rawContext.deleteProgram(_rawProgram);
  }
  
}

