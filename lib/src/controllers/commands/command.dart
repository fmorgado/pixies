part of pixies.controllers;

abstract class Command extends EventDispatcher {
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Event Types  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// The type of the event dispatched when the command completes.
  static const String COMPLETE = 'complete';
  /// The type of the event dispatched when an error occurs.
  static const String ERROR = 'error';
  /// The type of the event dispatched when the command starts.
  static const String START = 'start';
  /// The type of the event dispatched when the command stops.
  static const String STOP = 'stop';
  /// The type of the event dispatched when the progress changes.
  static const String PROGRESS = 'progress';
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Implementation  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Start the command.
  void start();
  
  /// Stop the command.
  void stop();
  
  EventDispatcher get parent => null;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Running Handling  /////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  bool _running = false;
  /// Indicates if the command is currently running.
  bool get running => _running;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Utility Methods  //////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Utility method for setting the value of [running] and dispatching
  /// the respective event. Should only be called from sub-classes.
  void setRunning(bool value) {
    if (value == _running)
      throw new StateError(value ? 'Command is already running' : 'Command is not running');
    
    _running = value;
    dispatchEventWith(value ? START : STOP, null);
  }
  
  /// Complete the command (with optional [value], setting [running] to false
  /// (using [setRunning]) and dispatch the [COMPLETE] event. Should only be
  /// called from sub-classes.
  void dispatchComplete([value = null]) {
    setRunning(false);
    dispatchEventWith(COMPLETE, value);
  }
  
  /// Complete the command with an error, setting [running] to false
  /// (using [setRunning]) and dispatch the [ERROR] event.
  /// Should be called from sub-classes.
  void dispatchError(error) {
    setRunning(false);
    // TODO Wrap error into Log
    dispatchEventWith(ERROR, error);
  }
  
  /// Utility method for setting the current progress and dispatching
  /// the respective event. Should be called only from sub-classes.
  void dispatchProgress(num current, num total) {
    _currentProgress = current;
    _totalProgress = total;
    dispatchEventWith(PROGRESS, null);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Progress Handling  ////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  num _currentProgress = 0;
  /// The current progress.
  num get currentProgress => _currentProgress;
  
  num _totalProgress = 1;
  /// The value [currentProgress] must reach for 100% completion.
  num get totalProgress => _totalProgress;
  
  /// Get the progress of the command, as a value between 0 and 1, or NaN.
  double get progress {
    final current = currentProgress;
    final total = totalProgress;
    if (current.isNaN || total.isNaN)
      return double.NAN;
    else
      return current / total;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Events Handling  //////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Add an event [listener] for the [COMPLETE] event.
  void addCompleteListener(EventListener<Event> listener) =>
      addEventListener(COMPLETE, listener);
  
  /// Remove an event [listener] for the [COMPLETE] event.
  void removeCompleteListener(EventListener<Event> listener) =>
      removeEventListener(COMPLETE, listener);
  
  /// Add an event [listener] for the [START] event.
  void addStartListener(EventListener<Event> listener) =>
      addEventListener(START, listener);
  
  /// Remove an event [listener] for the [START] event.
  void removeStartListener(EventListener<Event> listener) =>
      removeEventListener(START, listener);
  
  /// Add an event [listener] for the [STOP] event.
  void addStopListener(EventListener<Event> listener) =>
      addEventListener(STOP, listener);
  
  /// Remove an event [listener] for the [STOP] event.
  void removeStopListener(EventListener<Event> listener) =>
      removeEventListener(STOP, listener);
  
  /// Add an event [listener] for the [PROGRESS] event.
  void addProgressListener(EventListener listener) =>
      addEventListener(PROGRESS, listener);
  
  /// Remove an event [listener] for the [PROGRESS] event.
  void removeProgressListener(EventListener listener) =>
      removeEventListener(PROGRESS, listener);
  
  /// Add an event [listener] for the [ERROR] event.
  void addErrorListener(EventListener<LogEvent> listener) =>
      addEventListener(ERROR, listener);
  
  /// Remove an event [listener] for the [ERROR] event.
  void removeErrorListener(EventListener<LogEvent> listener) =>
      removeEventListener(ERROR, listener);
  
}
