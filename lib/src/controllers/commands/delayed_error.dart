part of pixies.controllers;

class DelayedError extends Command {
  Timer _timer;
  
  /// The duration of the command.
  Duration duration;
  /// The error the command must complete with.
  var error;
  
  /// Constructor.
  DelayedError(this.duration, this.error);
  
  void _clearTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
  
  void start() {
    setRunning(true);
    _clearTimer();
    _timer = new Timer(duration, _timerCallback);
  }
  
  void stop() {
    _clearTimer();
    setRunning(false);
  }
  
  void _timerCallback() {
    _clearTimer();
    dispatchError(error);
  }
  
}
