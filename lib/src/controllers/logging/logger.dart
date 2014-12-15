part of pixies.controllers;

abstract class Logger<P extends Logger> implements EventDispatcher<P> {
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Level Handling  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  LogLevel _level = null;
  /// The default level of the logger. Default is null.
  /// When null, the actual level is retrieved from parent loggers.
  /// If no parent logger defines a level, [Level.ERROR] is assumed.
  LogLevel get level {
    Logger current = this;
    do {
      if (current._level != null)
        return current._level;
      
      current = current.parent;
    } while(current != null);
    
    return LogLevel.ERROR;
  }
  void set level(LogLevel value) {
    _level = value;
  }
  
  /// Indicates whether a log of the given [level] will be dispatched.
  bool isLoggable(LogLevel level) => level.value <= this.level.value;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Listeners Handling  ///////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Add a log events [listener].
  /// 
  /// [LogEvent] instances are cached, so [LogListener] methods must not
  /// store them anywhere. Use [LogEvent.clone] if necessary.
  void addLogListener(LogListener listener) {
    addEventListener(LogEvent.LOG, listener);
  }
  
  /// Remove a log events [listener].
  void removeLogListener(LogListener listener) {
    removeEventListener(LogEvent.LOG, listener);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Log Methods  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Dispatch a log with the given [level], [code] and [argument].
  void log(LogLevel level, String code, [Map argument]) {
    if (isLoggable(level)) {
      final event = LogEvent._acquire(level, code, argument);
      dispatchEvent(event);
      LogEvent.release(event);
    }
  }
  
  /// Dispatch a [Level.DEBUG] log with the given [code] and [argument].
  void logDebug(String code, [argument]) =>
      log(LogLevel.DEBUG, code, argument);
  
  /// Dispatch a [Level.INFO] log with the given [code] and [argument].
  void logInfo(String code, [argument]) =>
      log(LogLevel.INFO, code, argument);
  
  /// Dispatch a [Level.CONFIG] log with the given [code] and [argument].
  void logConfig(String code, [argument]) =>
      log(LogLevel.CONFIG, code, argument);
  
  /// Dispatch a [Level.OK] log with the given [code] and [argument].
  void logOk(String code, [argument]) =>
      log(LogLevel.OK, code, argument);
  
  /// Dispatch a [Level.WARNING] log with the given [code] and [argument].
  void logWarning(String code, [argument]) =>
      log(LogLevel.WARNING, code, argument);
  
  /// Dispatch a [Level.ERROR] log with the given [code] and [argument].
  void logError(String code, [argument]) =>
      log(LogLevel.ERROR, code, argument);
  
  /// Dispatch a [Level.INTERNAL] log with the given [code] and [argument].
  void logInternal(String code, [argument]) =>
      log(LogLevel.INTERNAL, code, argument);
  
  /// Dispatch a [Level.CRITICAL] log with the given [code] and [argument].
  void logCritical(String code, [argument]) =>
      log(LogLevel.CRITICAL, code, argument);
  
}
