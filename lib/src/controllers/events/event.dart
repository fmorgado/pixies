part of pixies.controllers;

/// [Event] is a generic [AbstractEvent] implementation providing a typed
/// [data] property.
/// 
/// For most event types, an [Event] instance information is sufficient.
/// Other events may need additional information to be carried to the listener.
/// In that case, you can subclass [AbstractEvent] and add the extra properties.
/// 
/// [acquire] and [release] implement an instance pool of [Event] instances.
class Event<T> extends AbstractEvent {
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Cache Handling  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  static final _pool = <Event>[];
  
  /// Acquire an [Event] instance.
  /// If there are cached instances, the last one is returned.
  /// Otherwise a new instance is created.
  static Event acquire(String type, {data: null, bool bubbles: false,
        bool cancelable: false}) {
    if (_pool.isEmpty) {
      return new Event(type, data: data, bubbles: bubbles, cancelable: cancelable);
    } else {
      final result = _pool.removeLast();
      result._type = type;
      result._bubbles = bubbles;
      result._cancelable = cancelable;
      result._data = data;
      return result;
    }
  }
  
  /// Release an [Event] instance. The instance is cached to be used by [acquire].
  /// WARNING!!! Make sure no other references to [event] exist or undefined
  /// behavior may happen. 
  static void release(Event event) {
    event._clear();
    _pool.add(event);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Implementation  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Create an event of the given [type].
  /// 
  /// [bubbles] indicates whether the event will bubble up, using the
  /// [EventDispatcher.parent] property.
  /// 
  /// [cancelable] indicates whether the event may be canceled using
  /// [preventDefaults].
  /// 
  /// [data] is the data associated to the event.
  Event(String type, {bool bubbles: false, bool cancelable: false, T data})
      : super(type, bubbles: bubbles, cancelable: cancelable);
  
  /// Create a clone of [this].
  Event<T> clone() =>
      new Event<T>(_type, bubbles: _bubbles, cancelable: _cancelable, data: _data);
  
  T _data;
  /// The data associated to this event.
  T get data => _data;
  
  @override
  void _clear() {
    super._clear();
    _data = null;
  }
  
}
