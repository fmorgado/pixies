part of pixies.engine;

abstract class GLObject implements Animatable {
  
  /// Get the [GLEngine] instance.
  GLEngine get engine;
  
  /// Set the [GLEngine] instance.
  void set engine(GLEngine value);
  
  /// Indicate if the object is visible.
  /// If [false], [renderGraphics] is not called but all other methods are.
  bool get visible;
  
  /// Called when the object must initialize the needed infrastructure,
  /// (shaders, buffers, etc).
  void createGraphics();
  
  /// Called when the object must destroy its WebGL content.
  void destroyGraphics();
  
  /// Called when the [GLEngine] size changed.
  void setGraphicsSize(int width, int height);
  
}
