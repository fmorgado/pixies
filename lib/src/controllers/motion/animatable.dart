part of pixies.controllers;

/// Common interface for objects that can be animated.
abstract class Animatable {
  /// Called by [Animator] objects.
  /// [passedMilliseconds] is the time that passed since last call, in milliseconds.
  void advanceTime(num passedMilliseconds);
}
