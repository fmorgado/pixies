part of pixies.stage;

class _TriangleProgram extends GLProgram {
  
  static const MAX_TRIANGLE_COUNT = 1014;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Shader Sources  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  static const VERTEX_SOURCE = '''
uniform mat4 uStageMatrix;

attribute vec2 aCoord;
attribute vec4 aColor;

varying vec4 vColor;

void main() {
  vColor = aColor;
  gl_Position = vec4(aCoord, 0.0, 1.0) * uStageMatrix;
}
''';
  
  static const FRAGMENT_SOURCE = '''
precision mediump float;

uniform sampler2D uSampler;

varying float vAlpha;

void main() {
  gl_FragColor = vColor;
}
''';
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Factory Constructor  //////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  factory _TriangleProgram(GLEngine engine) =>
      new _TriangleProgram._(engine,
          GLProgram.compile(engine.rawContext, VERTEX_SOURCE, FRAGMENT_SOURCE));
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Properties  ///////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  final gl.UniformLocation _uStageMatrixLocation;
  final int _aCoordPos;
  final int _aColorPos;
  final gl.Buffer _triangleBuffer;
  
  final _triangleData = new Float32List(MAX_TRIANGLE_COUNT * 6 * 3);
  int _triangleDataIndex = 0;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Constructor  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  _TriangleProgram._(GLEngine engine, gl.Program rawProgram)
      : _uStageMatrixLocation = engine.rawContext.getUniformLocation(rawProgram, 'uStageMatrix'),
        _aCoordPos = engine.rawContext.getAttribLocation(rawProgram, 'aCoord'),
        _aColorPos = engine.rawContext.getAttribLocation(rawProgram, 'aColor'),
        _triangleBuffer = engine.rawContext.createBuffer(),
        super(engine, rawProgram) {
    rawContext.enableVertexAttribArray(_aCoordPos);
    rawContext.enableVertexAttribArray(_aColorPos);
    rawContext.bindBuffer(gl.ARRAY_BUFFER, _triangleBuffer);
    rawContext.bufferData(gl.ARRAY_BUFFER, _triangleData.length * 4, gl.DYNAMIC_DRAW);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Projection Handling  //////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  Matrix3D _projection;
  Matrix3D get projection => _projection;
  void set projection(Matrix3D value) {
    _projection = value;
    
    if (active) {
      flush();
      rawContext.uniformMatrix4fv(_uStageMatrixLocation, false, _projection.data);
    }
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Implementation  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  void configureProgram() {
    rawContext.bindBuffer(gl.ARRAY_BUFFER, _triangleBuffer);
    rawContext.vertexAttribPointer(_aCoordPos, 2, gl.FLOAT, false, 20, 0);
    rawContext.vertexAttribPointer(_aColorPos, 2, gl.FLOAT, false, 20, 8);
    rawContext.uniformMatrix4fv(_uStageMatrixLocation, false, _projection.data);
  }
  
  /*void renderBitmap(Bitmap bitmap, double alpha) {
    this.activate();
    final texture = bitmap.texture;
    texture.activate();
    
    int index = _vertexDataIndex;
    final vertices = bitmap._vertices;
    final uvs = texture.uvList;
    
    if (index > _vertexData.length - 4 * 5) return; // may remove bound-checks below
    
    _vertexData[index + 00] = vertices[0];
    _vertexData[index + 01] = vertices[1];
    _vertexData[index + 02] = uvs[0];
    _vertexData[index + 03] = uvs[1];
    
    _vertexData[index + 05] = vertices[2];
    _vertexData[index + 06] = vertices[3];
    _vertexData[index + 07] = uvs[2];
    _vertexData[index + 08] = uvs[3];
    
    _vertexData[index + 10] = vertices[4];
    _vertexData[index + 11] = vertices[5];
    _vertexData[index + 12] = uvs[4];
    _vertexData[index + 13] = uvs[5];
    
    _vertexData[index + 15] = vertices[6];
    _vertexData[index + 16] = vertices[7];
    _vertexData[index + 17] = uvs[6];
    _vertexData[index + 18] = uvs[7];
    
    _vertexData[index + 04] =
        _vertexData[index + 09] =
        _vertexData[index + 14] =
        _vertexData[index + 19] = alpha;
    
    _vertexDataIndex += 4 * 5;
    
    if (_vertexDataIndex >= MAX_QUAD_COUNT * 4 * 5) {
      rawContext.bufferSubData(gl.ARRAY_BUFFER, 0, _vertexData);
      rawContext.drawElements(gl.TRIANGLES, MAX_QUAD_COUNT * 6, gl.UNSIGNED_SHORT, 0);
      _vertexDataIndex = 0;
    }
  }*/
  
  void flush() {
    if (_triangleDataIndex == 0) return;
    
    final buffer =
        _triangleDataIndex >= MAX_TRIANGLE_COUNT * 6 * 3
            ? _triangleData
            : new Float32List.view(_triangleData.buffer, 0, _triangleDataIndex);
    
    rawContext.bufferSubData(gl.ARRAY_BUFFER, 0, buffer);
    rawContext.drawElements(gl.TRIANGLES, _triangleDataIndex ~/ 6, gl.UNSIGNED_SHORT, 0);
    _triangleDataIndex = 0;
  }
  
  void destroy() {
    super.destroy();
    rawContext.deleteBuffer(_triangleBuffer);
  }
  
}
