part of pixies.controllers;

abstract class DataCommand<T> extends Command {
  
  T _data;
  /// The result data of the command.
  T get data => _data;
  
  /// Complete the command with the given [value] using [dispatchComplete].
  /// Should only be called from sub-classes.
  void dispatchDataComplete(T value) {
    _data = value;
    dispatchComplete(value);
  }
  
}
