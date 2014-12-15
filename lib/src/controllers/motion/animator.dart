part of pixies.controllers;

class Animator implements Animatable {
  final _animatables = <Animatable>[];
  
  bool _playing = true;
  /// Indicates whether this animator is currently playing.
  bool get playing => _playing;
  void set playing(bool value) {
    _playing = value;
  }
  
  /// Add an [animatable].
  void addAnimatable(Animatable animatable) {
    if (_animatables.indexOf(animatable) < 0) {
      final length = _animatables.length;
      for (int index = 0; index < length; index++) {
        if (_animatables[index] == null) {
          _animatables[index] = animatable;
          return;
        }
      }
      _animatables.add(animatable);
    }
  }
  
  /// Remove an [animatable].
  void removeAnimatable(Animatable animatable) {
    final index = _animatables.indexOf(animatable);
    if (index >= 0)
      _animatables[index] = null;
  }
  
  /// Indicates whether [this] contains the given [animatable].
  bool containsAnimatable(Animatable animatable) =>
      _animatables.indexOf(animatable) >= 0;
  
  void clearAnimatables() {
    final length = _animatables.length;
    for (int index = 0; index < length; index++)
      _animatables[index] = null;
  }
  
  /// Called by [Animator] objects.
  /// [passedMilliseconds] is the time that passed since last call, in milliseconds.
  void advanceTime(num passedMilliseconds) {
    if (_playing) {
      final length = _animatables.length;
      for (int index = 0; index < length; index++) {
        final animatable = _animatables[index];
        if (animatable != null)
          animatable.advanceTime(passedMilliseconds);
      }
    }
  }
  
}
