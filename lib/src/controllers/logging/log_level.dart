part of pixies.controllers;

/// [LogLevel] defines constants to be used with [LogEvent.level].
class LogLevel {
  static const OFF      = const LogLevel._( -1, 'off');
  static const CRITICAL = const LogLevel._(  0, 'critical');
  static const INTERNAL = const LogLevel._( 10, 'internal');
  static const ERROR    = const LogLevel._( 20, 'error');
  static const WARNING  = const LogLevel._( 30, 'warning');
  static const OK       = const LogLevel._( 40, 'ok');
  static const CONFIG   = const LogLevel._( 50, 'config');
  static const INFO     = const LogLevel._( 60, 'info');
  static const DEBUG    = const LogLevel._( 70, 'debug');
  static const ALL      = const LogLevel._(100, 'all');
  
  /// The level value.
  final int    value;
  /// The name of this level.
  final String name;
  
  // Constructor.
  const LogLevel._(this.value, this.name);
  
  /// Get a string representation of [this].
  String toString() => '{value: $value, name: $name}';
}
