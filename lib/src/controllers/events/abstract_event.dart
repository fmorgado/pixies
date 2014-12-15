part of pixies.controllers;

/// [AbstractEvent] is the base class for all events.
/// 
/// The [AbstractEvent] provides methods to cancel the associated default
/// behavior, if any, and to stop further listeners from being called.
/// 
/// Events are dispatched by [EventDispatcher] instances and listened to
/// by registering [EventListener] methods.
/// 
/// Inside [EventListener] methods, the event instance should not be stored
/// anywhere, because it may be cached and later re-used by the dispatching
/// mechanism.
abstract class AbstractEvent {
  bool _dispatching = false;
  
  /// Default constructor.
  /// 
  /// [type] is the type of the event.
  /// 
  /// [bubbles] indicates whether the event will bubble up, using the
  /// [EventDispatcher.parent] property.
  /// 
  /// [cancelable] indicates whether the event may be canceled using
  /// [preventDefaults].
  AbstractEvent(String type, {bool bubbles: false, bool cancelable: false}) {
    _type = type;
    _bubbles = bubbles;
    _cancelable = cancelable;
  }
  
  /// Create a clone of [this].
  AbstractEvent clone();
  
  String _type;
  /// The type of the event.
  String get type => _type;
  
  EventDispatcher _target;
  /// The object where this event originated.
  EventDispatcher get target => _target;
  
  /// The name of [target], relative to [currentTarget].
  String get targetName {
    return '';
  }
  
  EventDispatcher _currentTarget;
  /// The object whose listeners are currently being processed.
  EventDispatcher get currentTarget => _currentTarget;
  
  bool _bubbles = false;
  /// Indicates if this event bubbles up the dispatch tree.
  bool get bubbles => _bubbles;
  
  bool _cancelable = false;
  /// Indicates if this event is cancelable.
  bool get cancelable => _cancelable;
  
  bool _isDefaultPrevented = false;
  /// Indicates whether [preventDefault] was called on this event.
  bool get isDefaultPrevented => _isDefaultPrevented;
  
  bool _propagationStopped = false;
  /// Indicates whether [stopPropagation] was called on this event.
  bool get propagationStopped => _propagationStopped;
  
  bool _immediatePropagationStopped = false;
  /// Indicates whether [stopImmediatePropagation] was called on this event.
  bool get immediatePropagationStopped => _immediatePropagationStopped;
  
  /// Cancel the event's default behavior, if it is cancelable.
  void preventDefault() {
    if (! _cancelable)
      throw new StateError('Event is not cancelable');
    _isDefaultPrevented = true;
  }
  
  /// Stop processing event listeners after current node.
  void stopPropagation() {
    _propagationStopped = true;
  }
  
  /// Stop processing event listeners after current listener.
  void stopImmediatePropagation() {
    _propagationStopped = true;
    _immediatePropagationStopped = true;
  }
  
  // Clear internal state so this instance may be cached.
  void _clear() {
    _type = null;
    _target = null;
    _currentTarget = null;
    _isDefaultPrevented = false;
    _propagationStopped = false;
    _immediatePropagationStopped = false;
  }
  
  void _dispatchOn(EventDispatcher target) {
    if (_dispatching)
      throw new StateError('Cannot re-dispatch an event.');
    _dispatching = true;
    
    _target = target;
    
    EventDispatcher current = target;
    do {
      if (current._eventTypes != null) {
        final listeners = current._eventTypes[_type];
        
        if (listeners != null) {
          _currentTarget = current;
          
          if (listeners is List) {
            // [listeners] is [List<EventListener>]
            final length = listeners.length;
            for (int index = 0; index < length; index++) {
              EventListener listener = listeners[index];
              if (listener != null) {
                listeners[index](this);
                if (_immediatePropagationStopped) break;
              }
            }
            
          } else {
            // [listeners] is [EventListener]
            listeners(this);
          }
        }
      }
      
      if (! _bubbles || _propagationStopped) break;
      current = target.parent;
    } while (current != null);
    
    _dispatching = false;
  }
  
}
