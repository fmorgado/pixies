part of pixies.controllers;

class LogEvent extends AbstractEvent {
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Static Stuff  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// The type of a log event.
  static const String LOG = 'log';
  
  static final _pool = <LogEvent>[];
  
  static LogEvent _acquire(LogLevel level, String code, Map argument) {
    if (_pool.isEmpty) {
      return new LogEvent.now(level, code, argument);
    } else {
      final result = _pool.removeLast();
      result._type = LOG;
      result._bubbles = true;
      result._level = level;
      result._code = code;
      result._argument = argument;
      result._date = new DateTime.now();
      return result;
    }
  }
  
  static void release(LogEvent event) {
    event._clear();
    _pool.add(event);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Constructors  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  LogEvent(LogLevel level, String code, Map argument, DateTime date)
      : super(LOG, bubbles: true, cancelable: false) {
    _level = level;
    _code = code;
    _argument = argument;
    _date = date;
  }
  
  LogEvent.now(LogLevel level, String code, Map argument)
      : super(LOG, bubbles: true, cancelable: false) {
    _level = level;
    _code = code;
    _argument = argument;
    _date = new DateTime.now();
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Properties  ///////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  LogLevel _level;
  /// The level of the log.
  LogLevel get level => _level;
  
  String _code;
  /// The code of the log.
  String get code => _code;
  
  Map _argument;
  /// The argument of the log.
  Map get argument => _argument;
  
  DateTime _date;
  /// The date of the log.
  DateTime get date => _date;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Misc Methods  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  @override
  void _clear() {
    super._clear();
    _level = null;
    _code = null;
    _argument = null;
    _date = null;
  }
  
  /// Create a clone of [this].
  LogEvent clone() => new LogEvent(_level, _code, _argument, _date);
  
  /// Get a string representation of [this].
  String toString() {
    final buffer = new StringBuffer();
    buffer.write('LogEvent(code:"$code"');
    if (argument != null) buffer.write(', argument:$argument');
    buffer.write(', level:$level, date:"$date", target:"${targetName}")');
    return buffer.toString();
  }
  
}
