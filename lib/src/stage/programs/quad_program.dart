part of pixies.stage;

class _QuadProgram extends GLProgram {
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Vertex Indices Buffer Handling  ///////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  static const MAX_QUAD_COUNT = 1024;
  
  static Int16List _getVertexIndexData() {
    final result = new Int16List(MAX_QUAD_COUNT * 6);
    
    final maximum = result.length - 6;
    for(int i = 0, j = 0; i <= maximum; i += 6, j +=4) {
      result[i + 0] = j + 0;
      result[i + 1] = j + 1;
      result[i + 2] = j + 2;
      result[i + 3] = j + 0;
      result[i + 4] = j + 2;
      result[i + 5] = j + 3;
    }
    
    return result;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Shader Sources  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  static const VERTEX_SOURCE = '''
uniform mat4 uStageMatrix;

attribute vec2 aCoord;
attribute vec2 aTexCoord;
attribute float aAlpha;

varying vec2 vTexCoord;
varying float vAlpha;

void main() {
  vTexCoord = aTexCoord;
  vAlpha = aAlpha;
  gl_Position = vec4(aCoord, 0.0, 1.0) * uStageMatrix;
}
''';
  
  static const FRAGMENT_SOURCE = '''
precision mediump float;

uniform sampler2D uSampler;

varying vec2 vTexCoord;
varying float vAlpha;

void main() {
  gl_FragColor = texture2D(uSampler, vTexCoord) * vAlpha;
}
''';
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Factory Constructor  //////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  factory _QuadProgram(GLEngine engine) =>
      new _QuadProgram._(engine,
          GLProgram.compile(engine.rawContext, VERTEX_SOURCE, FRAGMENT_SOURCE));
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Properties  ///////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  final gl.UniformLocation _uStageMatrixLocation;
  final gl.UniformLocation _uSamplerLocation;
  final int _aCoordPos;
  final int _aTexCoordPos;
  final int _aAlphaPos;
  final gl.Buffer _vertexBuffer;
  final gl.Buffer _vertexIndexBuffer;
  
  final _vertexData = new Float32List(MAX_QUAD_COUNT * 4 * 5);
  int _vertexDataIndex = 0;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Constructor  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  _QuadProgram._(GLEngine engine, gl.Program rawProgram)
      : _uStageMatrixLocation = engine.rawContext.getUniformLocation(rawProgram, 'uStageMatrix'),
        _uSamplerLocation = engine.rawContext.getUniformLocation(rawProgram, 'uSampler'),
        _aCoordPos = engine.rawContext.getAttribLocation(rawProgram, 'aCoord'),
        _aTexCoordPos = engine.rawContext.getAttribLocation(rawProgram, 'aTexCoord'),
        _aAlphaPos = engine.rawContext.getAttribLocation(rawProgram, 'aAlpha'),
        _vertexBuffer = engine.rawContext.createBuffer(),
        _vertexIndexBuffer = engine.rawContext.createBuffer(),
        super(engine, rawProgram) {
    rawContext.enableVertexAttribArray(_aCoordPos);
    rawContext.enableVertexAttribArray(_aTexCoordPos);
    rawContext.enableVertexAttribArray(_aAlphaPos);
    rawContext.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, _vertexIndexBuffer);
    rawContext.bufferDataTyped(gl.ELEMENT_ARRAY_BUFFER, _getVertexIndexData(), gl.STATIC_DRAW);
    rawContext.bindBuffer(gl.ARRAY_BUFFER, _vertexBuffer);
    rawContext.bufferData(gl.ARRAY_BUFFER, _vertexData.length * 4, gl.DYNAMIC_DRAW);
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
    rawContext.bindBuffer(gl.ARRAY_BUFFER, _vertexBuffer);
    rawContext.vertexAttribPointer(_aCoordPos, 2, gl.FLOAT, false, 20, 0);
    rawContext.vertexAttribPointer(_aTexCoordPos, 2, gl.FLOAT, false, 20, 8);
    rawContext.vertexAttribPointer(_aAlphaPos, 1, gl.FLOAT, false, 20, 16);
    rawContext.uniformMatrix4fv(_uStageMatrixLocation, false, _projection.data);
    rawContext.uniform1i(_uSamplerLocation, 0);
  }
  
  void renderBitmap(Bitmap bitmap, double alpha) {
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
  }
  
  void renderScale9Bitmap(Bitmap9 bitmap, double alpha) {
    this.activate();
    final texture = bitmap.texture;
    texture.activate();
    
    if (_vertexDataIndex > _vertexData.length - 4 * 5 * 9)
      flush();

    int index = _vertexDataIndex;
    if (index > _vertexData.length - 4 * 5 * 9) return; // may remove bound-checks below
    final vertices = bitmap._vertices;
    final uvs = texture.uvList;
    
    // Render top-left
    _vertexData[index + 00] = vertices[0];
    _vertexData[index + 01] = vertices[1];
    _vertexData[index + 02] = uvs[0];
    _vertexData[index + 03] = uvs[1];
    
    _vertexData[index + 05] = vertices[2];
    _vertexData[index + 06] = vertices[3];
    _vertexData[index + 07] = uvs[8];
    _vertexData[index + 08] = uvs[0];
    
    _vertexData[index + 10] = vertices[10];
    _vertexData[index + 11] = vertices[11];
    _vertexData[index + 12] = uvs[8];
    _vertexData[index + 13] = uvs[9];
    
    _vertexData[index + 15] = vertices[8];
    _vertexData[index + 16] = vertices[9];
    _vertexData[index + 17] = uvs[0];
    _vertexData[index + 18] = uvs[9];
    
    _vertexData[index + 04] =
        _vertexData[index + 09] =
        _vertexData[index + 14] =
        _vertexData[index + 19] = alpha;
    
    // Render top-middle
    _vertexData[index + 20] = vertices[2];
    _vertexData[index + 21] = vertices[3];
    _vertexData[index + 22] = uvs[8];
    _vertexData[index + 23] = uvs[0];
    
    _vertexData[index + 25] = vertices[4];
    _vertexData[index + 26] = vertices[5];
    _vertexData[index + 27] = uvs[10];
    _vertexData[index + 28] = uvs[0];
    
    _vertexData[index + 30] = vertices[12];
    _vertexData[index + 31] = vertices[13];
    _vertexData[index + 32] = uvs[10];
    _vertexData[index + 33] = uvs[9];
    
    _vertexData[index + 35] = vertices[10];
    _vertexData[index + 36] = vertices[11];
    _vertexData[index + 37] = uvs[8];
    _vertexData[index + 38] = uvs[9];
    
    _vertexData[index + 24] =
        _vertexData[index + 29] =
        _vertexData[index + 34] =
        _vertexData[index + 39] = alpha;
    
    // Render top-right
    _vertexData[index + 40] = vertices[4];
    _vertexData[index + 41] = vertices[5];
    _vertexData[index + 42] = uvs[10];
    _vertexData[index + 43] = uvs[0];
    
    _vertexData[index + 45] = vertices[6];
    _vertexData[index + 46] = vertices[7];
    _vertexData[index + 47] = uvs[2];
    _vertexData[index + 48] = uvs[0];
    
    _vertexData[index + 50] = vertices[14];
    _vertexData[index + 51] = vertices[15];
    _vertexData[index + 52] = uvs[2];
    _vertexData[index + 53] = uvs[9];
    
    _vertexData[index + 55] = vertices[12];
    _vertexData[index + 56] = vertices[13];
    _vertexData[index + 57] = uvs[10];
    _vertexData[index + 58] = uvs[9];
    
    _vertexData[index + 44] =
        _vertexData[index + 49] =
        _vertexData[index + 54] =
        _vertexData[index + 59] = alpha;
    
    // Render middle-left
    _vertexData[index + 60] = vertices[8];
    _vertexData[index + 61] = vertices[9];
    _vertexData[index + 62] = uvs[0];
    _vertexData[index + 63] = uvs[9];
    
    _vertexData[index + 65] = vertices[10];
    _vertexData[index + 66] = vertices[11];
    _vertexData[index + 67] = uvs[8];
    _vertexData[index + 68] = uvs[9];
    
    _vertexData[index + 70] = vertices[18];
    _vertexData[index + 71] = vertices[19];
    _vertexData[index + 72] = uvs[8];
    _vertexData[index + 73] = uvs[11];
    
    _vertexData[index + 75] = vertices[16];
    _vertexData[index + 76] = vertices[17];
    _vertexData[index + 77] = uvs[0];
    _vertexData[index + 78] = uvs[11];
    
    _vertexData[index + 64] =
        _vertexData[index + 69] =
        _vertexData[index + 74] =
        _vertexData[index + 79] = alpha;
    
    // Render middle-center
    _vertexData[index + 80] = vertices[10];
    _vertexData[index + 81] = vertices[11];
    _vertexData[index + 82] = uvs[8];
    _vertexData[index + 83] = uvs[9];
    
    _vertexData[index + 85] = vertices[12];
    _vertexData[index + 86] = vertices[13];
    _vertexData[index + 87] = uvs[10];
    _vertexData[index + 88] = uvs[9];
    
    _vertexData[index + 90] = vertices[20];
    _vertexData[index + 91] = vertices[21];
    _vertexData[index + 92] = uvs[10];
    _vertexData[index + 93] = uvs[11];
    
    _vertexData[index + 95] = vertices[18];
    _vertexData[index + 96] = vertices[19];
    _vertexData[index + 97] = uvs[8];
    _vertexData[index + 98] = uvs[11];
    
    _vertexData[index + 84] =
        _vertexData[index + 89] =
        _vertexData[index + 94] =
        _vertexData[index + 99] = alpha;
    
    // Render middle-right
    _vertexData[index + 100] = vertices[12];
    _vertexData[index + 101] = vertices[13];
    _vertexData[index + 102] = uvs[10];
    _vertexData[index + 103] = uvs[9];
    
    _vertexData[index + 105] = vertices[14];
    _vertexData[index + 106] = vertices[15];
    _vertexData[index + 107] = uvs[2];
    _vertexData[index + 108] = uvs[9];
    
    _vertexData[index + 110] = vertices[22];
    _vertexData[index + 111] = vertices[23];
    _vertexData[index + 112] = uvs[2];
    _vertexData[index + 113] = uvs[11];
    
    _vertexData[index + 115] = vertices[20];
    _vertexData[index + 116] = vertices[21];
    _vertexData[index + 117] = uvs[10];
    _vertexData[index + 118] = uvs[11];
    
    _vertexData[index + 104] =
        _vertexData[index + 109] =
        _vertexData[index + 114] =
        _vertexData[index + 119] = alpha;
    
    // Render bottom-left
    _vertexData[index + 120] = vertices[16];
    _vertexData[index + 121] = vertices[17];
    _vertexData[index + 122] = uvs[0];
    _vertexData[index + 123] = uvs[11];
    
    _vertexData[index + 125] = vertices[18];
    _vertexData[index + 126] = vertices[19];
    _vertexData[index + 127] = uvs[8];
    _vertexData[index + 128] = uvs[11];
    
    _vertexData[index + 130] = vertices[26];
    _vertexData[index + 131] = vertices[27];
    _vertexData[index + 132] = uvs[8];
    _vertexData[index + 133] = uvs[7];
    
    _vertexData[index + 135] = vertices[24];
    _vertexData[index + 136] = vertices[25];
    _vertexData[index + 137] = uvs[0];
    _vertexData[index + 138] = uvs[7];
    
    _vertexData[index + 124] =
        _vertexData[index + 129] =
        _vertexData[index + 134] =
        _vertexData[index + 139] = alpha;
    
    // Render bottom-center
    _vertexData[index + 140] = vertices[18];
    _vertexData[index + 141] = vertices[19];
    _vertexData[index + 142] = uvs[8];
    _vertexData[index + 143] = uvs[11];
    
    _vertexData[index + 145] = vertices[20];
    _vertexData[index + 146] = vertices[21];
    _vertexData[index + 147] = uvs[10];
    _vertexData[index + 148] = uvs[11];
    
    _vertexData[index + 150] = vertices[28];
    _vertexData[index + 151] = vertices[29];
    _vertexData[index + 152] = uvs[10];
    _vertexData[index + 153] = uvs[7];
    
    _vertexData[index + 155] = vertices[26];
    _vertexData[index + 156] = vertices[27];
    _vertexData[index + 157] = uvs[8];
    _vertexData[index + 158] = uvs[7];
    
    _vertexData[index + 144] =
        _vertexData[index + 149] =
        _vertexData[index + 154] =
        _vertexData[index + 159] = alpha;
    
    // Render bottom-right
    _vertexData[index + 160] = vertices[20];
    _vertexData[index + 161] = vertices[21];
    _vertexData[index + 162] = uvs[10];
    _vertexData[index + 163] = uvs[11];
    
    _vertexData[index + 165] = vertices[22];
    _vertexData[index + 166] = vertices[23];
    _vertexData[index + 167] = uvs[2];
    _vertexData[index + 168] = uvs[11];
    
    _vertexData[index + 170] = vertices[30];
    _vertexData[index + 171] = vertices[31];
    _vertexData[index + 172] = uvs[2];
    _vertexData[index + 173] = uvs[7];
    
    _vertexData[index + 175] = vertices[28];
    _vertexData[index + 176] = vertices[29];
    _vertexData[index + 177] = uvs[10];
    _vertexData[index + 178] = uvs[7];
    
    _vertexData[index + 164] =
        _vertexData[index + 169] =
        _vertexData[index + 174] =
        _vertexData[index + 179] = alpha;
    
    _vertexDataIndex += 4 * 5 * 9;
    
    if (_vertexDataIndex >= MAX_QUAD_COUNT * 4 * 5) {
      rawContext.bufferSubData(gl.ARRAY_BUFFER, 0, _vertexData);
      rawContext.drawElements(gl.TRIANGLES, MAX_QUAD_COUNT * 6, gl.UNSIGNED_SHORT, 0);
      _vertexDataIndex = 0;
    }
  }
  
  void flush() {
    if (_vertexDataIndex == 0) return;
    
    final buffer =
        _vertexDataIndex >= MAX_QUAD_COUNT * 4 * 5
            ? _vertexData
            : new Float32List.view(_vertexData.buffer, 0, _vertexDataIndex);
    
    rawContext.bufferSubData(gl.ARRAY_BUFFER, 0, buffer);
    rawContext.drawElements(gl.TRIANGLES, (_vertexDataIndex ~/ (4 * 5)) * 6, gl.UNSIGNED_SHORT, 0);
    _vertexDataIndex = 0;
  }
  
  void destroy() {
    super.destroy();
    rawContext.deleteBuffer(_vertexBuffer);
    rawContext.deleteBuffer(_vertexIndexBuffer);
  }
  
}
