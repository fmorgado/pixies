part of pixies.controllers;

/// [EventDispatcher] is a mixin that provides the ability to dispatch events.
/// 
/// Contrary to other dispatching mechanisms, there is no "capture" phase when
/// dispatching events. They are simply dispatched at the target and may
/// optionally bubble up.
/// 
/// Events are dispatched by calling [dispatchEvent] or [dispatchEventWith],
/// and listened to by registering [EventListener] methods with [addEventListener].
/// 
/// The use of this mixin requires the implementation of [Child<P>].
/// 
/// Inside [EventListener] methods, the event instance should not be stored
/// anywhere, because it may be cached and re-used later.
abstract class EventDispatcher<P extends EventDispatcher> {
  // [dynamic] means [EventListener] or [List<EventListener>].
  Map<String, dynamic> _eventTypes;
  
  /// The parent dispatcher.
  P get parent;
  
  /// Add an event [listener] to the given [type].
  /// 
  /// Be careful not to store the [Event] instance passed to the listener,
  /// because it may be cached and re-used.
  void addEventListener(String type, EventListener listener) {
    var types = _eventTypes;
    if (types == null) {
      _eventTypes = <String, dynamic>{type: listener};
      return;
    }
    
    final entry = types[type];
    if (entry == null) {
      // No previous entry
      types[type] = listener;
      
    } else if (entry is List) {
      // [entry] is [List<EventListener>]
      final length = entry.length;
      for (int index = 0; index < length; index++) {
        if (entry[index] == null) {
          entry[index] = listener;
          return;
        }
      }
      entry.add(listener);
      
    } else if (! identical(entry, listener)) {
      // entry is EventListener.
      types[type] = [entry, listener];
    }
  }
  
  /// Indicates if there are listeners for the given [type].
  bool willTrigger(String type, bool bubbles) {
    EventDispatcher current = this;
    
    do {
      final types = current._eventTypes;
      if (types != null) {
        final listeners = types[type];
        if (listeners != null) {
          if (listeners is List) {
            final length = listeners.length;
            if (length > 0) {
              for (int index = 0; index < length; index++) {
                if (listeners[index] != null)
                  return true;
              }
            }
            // Continue if list is empty or is all set to null.
          } else {
            // listeners is EventListener
            return true;
          }
        }
      }
      
      if (! bubbles) return false;
      current = current.parent;
    } while (current != null);
    
    return false;
  }
  
  /// Remove an event [listener] for the given [type].
  void removeEventListener(String type, EventListener listener) {
    final types = _eventTypes;
    if (types == null) return;
    
    final entry = types[type];
    if (identical(entry, listener)) {
      types.remove(type);
    } else if (entry is List) {
      final length = entry.length;
      for (int index = 0; index < length; index++) {
        if (identical(entry[index], listener)) {
          entry[index] = null;
          return;
        }
      }
    }
  }
  
  /// Remove all listeners.
  /// If a [type] is specified, remove all listeners for that [type].
  void clearEventListeners([String type]) {
    if (type == null) {
      _eventTypes = null;
    } else if (_eventTypes != null) {
      _eventTypes.remove(type);
    }
  }
  
  /// Dispatch [value] on the given [type].
  void dispatchEvent(AbstractEvent event) {
    event._dispatchOn(this);
  }
  
  /// Dispatch an [Event] of the given [type], indicating whether the event
  /// [bubbles]. A cached [Event] instance is used (as returned by
  /// [Event.acquire]). The event is not cancelable.
  void dispatchEventWith(String type, data, {bool bubbles: false}) {
    if (willTrigger(type, bubbles)) {
      final event = Event.acquire(type, data: data, bubbles: bubbles);
      dispatchEvent(event);
      Event.release(event);
    }
  }
  
}
