part of pixies.stage;

class Matrix3D {
  final Float32List data = new Float32List(16);
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Constructors  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  /// Identity matrix.
  Matrix3D.identity() {
    setIdentity();
  }

  /// Copies values from [other].
  Matrix3D.copy(Matrix3D other) {
    copyFrom(other);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Misc Methods  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  /// Get a copy of [this].
  Matrix3D clone() => new Matrix3D.copy(this);

  /// Sets the matrix with specified values.
  void setValues(double arg0, double arg1, double arg2,
                 double arg3, double arg4, double arg5,
                 double arg6, double arg7, double arg8,
                 double arg9, double arg10, double arg11,
                 double arg12, double arg13, double arg14, double arg15) {
    data[0] = arg0;
    data[1] = arg1;
    data[2] = arg2;
    data[3] = arg3;
    data[4] = arg4;
    data[5] = arg5;
    data[6] = arg6;
    data[7] = arg7;
    data[8] = arg8;
    data[9] = arg9;
    data[10] = arg10;
    data[11] = arg11;
    data[12] = arg12;
    data[13] = arg13;
    data[14] = arg14;
    data[15] = arg15;
  }
  
  /// Set [this] into the identity matrix.
  void setIdentity() {
    data[0] =
      data[5] =
      data[10] =
      data[15] = 1.0;
    data[1] =
      data[2] =
      data[3] =
      data[4] =
      data[6] =
      data[7] =
      data[8] =
      data[9] =
      data[11] =
      data[12] =
      data[13] =
      data[14] = 0.0;
  }

  /// Copy values from [arg].
  void copyFrom(Matrix3D arg) {
    final oData = arg.data;
    data[0] = oData[0];
    data[1] = oData[1];
    data[2] = oData[2];
    data[3] = oData[3];
    data[4] = oData[4];
    data[5] = oData[5];
    data[6] = oData[6];
    data[7] = oData[7];
    data[8] = oData[8];
    data[9] = oData[9];
    data[10] = oData[10];
    data[11] = oData[11];
    data[12] = oData[12];
    data[13] = oData[13];
    data[14] = oData[14];
    data[15] = oData[15];
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Translation Handling  /////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Set the translations on the X and Y axes to [x] and [y], respectively.
  void setTranslationXY(num x, num y) {
    data[03] = x;
    data[07] = y;
  }
  
  /// Set the translations on the X, Y and Z axes to [x], [y] and [z], respectively.
  void setTranslation(num x, num y, num z) {
    data[03] = x;
    data[07] = y;
    data[11] = z;
  }
  
  /// Translate by [x] and [y] on the X and Y axes, respectively.
  void translateXY(num x, num y) {
    data[03] += x;
    data[07] += y;
  }
  
  /// Translate by [x], [y] and [z] on the X, Y and Z axes, respectively.
  void translate(num x, num y, num z) {
    data[03] += x;
    data[07] += y;
    data[11] += z;
  }
  
  /// Prepend a translation of [x] and [y] on the X and Y axes, respectively.
  void preTranslateXY(num x, num y) {
    data[03] += data[00] * x + data[04] * y;
    data[07] += data[01] * x + data[05] * y;
    data[11] += data[02] * x + data[06] * y;
    //data[15] += data[03] * x + data[07] * y;
  }
  
  /// Prepend a translation of [x], [y] and [z] on the X, Y and Z axes, respectively.
  void preTranslate(num x, num y, num z) {
    data[03] += data[00] * x + data[04] * y + data[08] * z;
    data[07] += data[01] * x + data[05] * y + data[09] * z;
    data[11] += data[02] * x + data[06] * y + data[10] * z;
    //data[15] += data[03] * x + data[07] * y + data[11] * z;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Scale Handling  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  /// Scale the X axis by [value].
  void scaleX(double value) {
    data[0] *= value;
    data[1] *= value;
    data[2] *= value;
    data[3] *= value;
  }
  
  /// Scale the Y axis by [value].
  void scaleY(double value) {
    data[4] *= value;
    data[5] *= value;
    data[6] *= value;
    data[7] *= value;
  }
  
  /// Scale the Z axis by [value].
  void scaleZ(double value) {
    data[8] *= value;
    data[9] *= value;
    data[10] *= value;
    data[11] *= value;
  }
  
  /// Scale the X and Y axes by [x] and [y], respectively.
  void scaleXY(double x, double y) {
    data[0] *= x;
    data[1] *= x;
    data[2] *= x;
    data[3] *= x;
    data[4] *= y;
    data[5] *= y;
    data[6] *= y;
    data[7] *= y;
  }
  
  /// Scale the X, Y and Z axes by [x], [y] and [z], respectively.
  void scale(double x, double y, double z) {
    data[0] *= x;
    data[1] *= x;
    data[2] *= x;
    data[3] *= x;
    data[4] *= y;
    data[5] *= y;
    data[6] *= y;
    data[7] *= y;
    data[8] *= z;
    data[9] *= z;
    data[10] *= z;
    data[11] *= z;
    /*double sw = 1.0;
    data[12] *= sw;
    data[13] *= sw;
    data[14] *= sw;
    data[15] *= sw;*/
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Rotation Handling  ////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Rotate this matrix [angle] radians around the X axis;
  void rotateX(num angle) {
    num cos = math.cos(angle);
    num sin = math.sin(angle);
    num m01 = data[04];
    num m11 = data[05];
    num m21 = data[06];
    num m31 = data[07];
    num m02 = data[08];
    num m12 = data[09];
    num m22 = data[10];
    num m32 = data[11];
    
    data[04] = m01 * cos + m02 * sin;
    data[05] = m11 * cos + m12 * sin;
    data[06] = m21 * cos + m22 * sin;
    data[07] = m31 * cos + m32 * sin;
    data[08] = m02 * cos - m01 * sin;
    data[09] = m12 * cos - m11 * sin;
    data[10] = m22 * cos - m21 * sin;
    data[11] = m32 * cos - m31 * sin;
  }
  
  /// Rotate this matrix [angle] radians around the Y axis;
  void rotateY(num angle) {
    num cos = math.cos(angle);
    num sin = math.sin(angle);
    num m00 = data[00];
    num m10 = data[01];
    num m20 = data[02];
    num m30 = data[03];
    num m02 = data[08];
    num m12 = data[09];
    num m22 = data[10];
    num m32 = data[11];
    
    data[00] = m00 * cos + m02 * sin;
    data[01] = m10 * cos + m12 * sin;
    data[02] = m20 * cos + m22 * sin;
    data[03] = m30 * cos + m32 * sin;
    data[08] = m02 * cos - m00 * sin;
    data[09] = m12 * cos - m10 * sin;
    data[10] = m22 * cos - m20 * sin;
    data[11] = m32 * cos - m30 * sin;
  }
  
  /// Rotate this matrix [angle] radians around the Z axis.
  void rotateZ(num angle) {
    num cos = math.cos(angle);
    num sin = math.sin(angle);
    num m00 = data[00];
    num m10 = data[01];
    num m20 = data[02];
    num m30 = data[03];
    num m01 = data[04];
    num m11 = data[05];
    num m21 = data[06];
    num m31 = data[07];

    data[00] = m00 * cos + m01 * sin;
    data[01] = m10 * cos + m11 * sin;
    data[02] = m20 * cos + m21 * sin;
    data[03] = m30 * cos + m31 * sin;
    data[04] = m01 * cos - m00 * sin;
    data[05] = m11 * cos - m10 * sin;
    data[06] = m21 * cos - m20 * sin;
    data[07] = m31 * cos - m30 * sin;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  General Arithmetic  ///////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Multiply [this] by another matrix.
  void multiply(Matrix3D other) {
    num v00 = data[00];
    num v01 = data[04];
    num v02 = data[08];
    num v03 = data[12];
    num v10 = data[01];
    num v11 = data[05];
    num v12 = data[09];
    num v13 = data[13];
    num v20 = data[02];
    num v21 = data[06];
    num v22 = data[10];
    num v23 = data[14];
    num v30 = data[03];
    num v31 = data[07];
    num v32 = data[11];
    num v33 = data[15];
    
    final oData = other.data;
    num o00 = oData[00];
    num o01 = oData[04];
    num o02 = oData[08];
    num o03 = oData[12];
    num o10 = oData[01];
    num o11 = oData[05];
    num o12 = oData[09];
    num o13 = oData[13];
    num o20 = oData[02];
    num o21 = oData[06];
    num o22 = oData[10];
    num o23 = oData[14];
    num o30 = oData[03];
    num o31 = oData[07];
    num o32 = oData[11];
    num o33 = oData[15];
    
    data[00] = v00 * o00 + v01 * o10 + v02 * o20 + v03 * o30;
    data[01] = v10 * o00 + v11 * o10 + v12 * o20 + v13 * o30;
    data[02] = v20 * o00 + v21 * o10 + v22 * o20 + v23 * o30;
    data[03] = v30 * o00 + v31 * o10 + v32 * o20 + v33 * o30;
    data[04] = v00 * o01 + v01 * o11 + v02 * o21 + v03 * o31;
    data[05] = v10 * o01 + v11 * o11 + v12 * o21 + v13 * o31;
    data[06] = v20 * o01 + v21 * o11 + v22 * o21 + v23 * o31;
    data[07] = v30 * o01 + v31 * o11 + v32 * o21 + v33 * o31;
    data[08] = v00 * o02 + v01 * o12 + v02 * o22 + v03 * o32;
    data[09] = v10 * o02 + v11 * o12 + v12 * o22 + v13 * o32;
    data[10] = v20 * o02 + v21 * o12 + v22 * o22 + v23 * o32;
    data[11] = v30 * o02 + v31 * o12 + v32 * o22 + v33 * o32;
    data[12] = v00 * o03 + v01 * o13 + v02 * o23 + v03 * o33;
    data[13] = v10 * o03 + v11 * o13 + v12 * o23 + v13 * o33;
    data[14] = v20 * o03 + v21 * o13 + v22 * o23 + v23 * o33;
    data[15] = v30 * o03 + v31 * o13 + v32 * o23 + v33 * o33;
  }
  
  /// Apply the perspective to this matrix.
  void applyPerspective(PerspectiveProjection perspective) {
    num o10 = 1.0 / perspective.depth;
    num o14 = perspective.scale / perspective.depth;
    
    data[12] += data[08] * o14;
    data[13] += data[09] * o14;
    data[14] += data[10] * o14;
    data[15] += data[11] * o14;
    data[08] *= o10;
    data[09] *= o10;
    data[10] *= o10;
    data[11] *= o10;
  }
}
