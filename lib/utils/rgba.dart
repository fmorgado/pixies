library pixies.utils.rgba;

import 'dart:typed_data';

/// Represents a color as a list of 32-bits floats.
class RGBA {
  
  /// Get the red channel of the given [color], as double between 0 and 1.
  static double getRedChannel(int color) => ((color >> 16) & 0xFF) / 255;
  
  /// Get the green channel of the given [color], as double between 0 and 1.
  static double getGreenChannel(int color) => ((color >> 8) & 0xFF) / 255;
  
  /// Get the blue channel of the given [color], as double between 0 and 1.
  static double getBlueChannel(int color) => (color & 0xFF) / 255;
  
  /// Get the alpha channel of the given [color], as double between 0 and 1.
  static double getAlphaChannel(int color) => ((color >> 24) & 0xFF) / 255;
  
  static int joinChannels(double r, double g, double b, double a) =>
      ((a * 255.0).toInt() << 24) |
      ((r * 255.0).toInt() << 16) |
      ((b * 255.0).toInt() << 8) |
      (g * 255.0).toInt();
  
  final list = new Float32List(4);
  
  /// Default constructor, initialized to [Color.Black] ([0xFF000000]).
  RGBA() {
    alpha = 1.0;
  }
  
  /// Constructor, initialized to the given [color].
  RGBA.fromColor(int color) {
    this.color = color;
  }
  
  /// Constructor, initialized to the color of the given [RGBA].
  RGBA.copy(RGBA other) {
    copyFrom(other);
  }
  
  /// Create a copy of this instance.
  RGBA clone() => new RGBA.copy(this);
  
  /// The red channel.
  double get red => list[0];
  void set red(double value) { list[0] = value; }
  
  /// The green channel.
  double get green => list[1];
  void set green(double value) { list[1] = value; }
  
  /// The blue channel.
  double get blue => list[2];
  void set blue(double value) { list[2] = value; }
  
  /// The alpha channel.
  double get alpha => list[3];
  void set alpha(double value) { list[3] = value; }
  
  /// Copy the color values from the given [RGBA] to this instance.
  void copyFrom(RGBA other) {
    list[0] = other.list[0];
    list[1] = other.list[1];
    list[2] = other.list[2];
    list[3] = other.list[3];
  }
  
  /// The color of this instance, as an integer.
  int get color => joinChannels(red, green, blue, alpha);
  void set color(int value) {
    red = getRedChannel(value);
    green = getGreenChannel(value);
    blue = getBlueChannel(value);
    alpha = getAlphaChannel(value);
  }
  
}
