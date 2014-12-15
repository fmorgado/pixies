part of pixies.controllers;

class DelayedData<T> extends DataCommand<T> {
  Timer _timer;
  
  /// The duration of the command.
  Duration duration;
  /// The result data the command must complete with.
  T result;
  
  /// Constructor.
  DelayedData(this.duration, this.result);
  
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
    dispatchDataComplete(result);
  }
  
}
