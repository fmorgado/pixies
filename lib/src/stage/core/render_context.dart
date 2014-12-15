part of pixies.stage;

class _RenderContext {
  final GLEngine engine;
  final gl.RenderingContext rawContext;
  final _QuadProgram quadProgram;
  final _TriangleProgram triangleProgram;
  
  _RenderContext(GLEngine engine)
      : this.engine = engine,
        rawContext = engine.rawContext,
        quadProgram = new _QuadProgram(engine),
        triangleProgram = new _TriangleProgram(engine) {
  }
  
}
