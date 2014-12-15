part of pixies.engine;

class BlendMode {
  final int srcFactor;
  final int dstFactor;

  const BlendMode(this.srcFactor, this.dstFactor);

  static const NORMAL   = const BlendMode(gl.ONE, gl.ONE_MINUS_SRC_ALPHA);
  static const ADD      = const BlendMode(gl.ONE, gl.ONE);
  static const MULTIPLY = const BlendMode(gl.DST_COLOR, gl.ONE_MINUS_SRC_ALPHA);
  static const SCREEN   = const BlendMode(gl.ONE, gl.ONE_MINUS_SRC_COLOR);
  static const ERASE    = const BlendMode(gl.ZERO, gl.ONE_MINUS_SRC_ALPHA);
  static const BELOW    = const BlendMode(gl.ONE_MINUS_DST_ALPHA, gl.ONE);
  static const ABOVE    = const BlendMode(gl.DST_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
  static const NONE     = const BlendMode(gl.ONE, gl.ZERO);
}
