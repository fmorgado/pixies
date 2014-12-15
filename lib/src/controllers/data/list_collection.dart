part of pixies.controllers;

typedef void ItemCallback<T>(T item);
typedef void ChangedCallback();

class ListCollection<T> extends Object with EventDispatcher {
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Event Types  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  static const String ITEM_ADDED = 'itemAdded';
  static const String ITEM_REMOVED = 'itemRemoved';
  static const String ITEM_UPDATED = 'itemUpdated';
  static const String CHANGED = 'changed';
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Misc Properties  //////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  final List<T> _source;
  
  final ItemCallback<T> _onAdded;
  final ItemCallback<T> _onRemoved;
  final ChangedCallback _onChanged;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Constructor  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  ListCollection({
    List<T> source,
    ItemCallback<T> onAdded,
    ItemCallback<T> onRemoved,
    ChangedCallback onChanged
  })  : _source = source != null ? source : <T>[],
        _onAdded = onAdded,
        _onRemoved = onRemoved,
        _onChanged = onChanged;
  
  EventDispatcher get parent => null;
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Utility Methods  //////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  void _dispatchItemAdded(T item) {
    if (_onAdded != null) _onAdded(item);
    dispatchEventWith(ITEM_ADDED, item);
  }
  
  void _dispatchItemRemoved(T item) {
    if (_onRemoved != null) _onRemoved(item);
    dispatchEventWith(ITEM_REMOVED, item);
  }
  
  void _dispatchChanged() {
    if (_onChanged != null) _onChanged();
    dispatchEventWith(CHANGED, null);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Getters / Setters  ////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// The length of the collection.
  int get length => _source.length;
  
  /// Indicates whether the collection is empty.
  bool get isEmpty => length == 0;
  
  /// Indicates whether the collection is not empty.
  bool get isNotEmpty => ! isEmpty;
  
  operator [](int index) {
    if (index >= 0 && index < length) {
      return _source[index];
    } else {
      throw new RangeError('Invalid index:  $index');
    }
  }
  
  operator []=(int index, T value) {
    if (index >= 0 && index < length) {
      final old = _source[index];
      _source[index] = value;
      _dispatchItemRemoved(old);
      _dispatchItemAdded(value);
      _dispatchChanged();
    } else {
      throw new RangeError('Invalid index:  $index');
    }
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Implementation Methods  ///////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Returns the first index of [element] in this list, or -1 if not found.
  int indexOf(T item, [int start = 0]) => _source.indexOf(item, start);
  
  /// Returns the last index of [element] in this list, or -1 if not found.
  int lastIndexOf(T item, [int start]) => _source.lastIndexOf(item, start);
  
  /// Set the [index] of [item].
  void setIndexOf(T item, int index) {
    final oldIndex = indexOf(item);
    if (index == oldIndex) return;
    if (oldIndex == -1)
      throw new ArgumentError('Item not found');
    
    if (index >= 0 && index < length) {
      _source.removeAt(oldIndex);
      _source.insert(index, item);
      _dispatchChanged();
    } else {
      throw new RangeError('Invalid index:  $index');
    }
  }
  
  void add(T item) {
    _source.add(item);
    _dispatchItemAdded(item);
    _dispatchChanged();
  }
  
  void addAt(T item, int index) {
    if (index >= 0 && index <= length) {
      _source.insert(index, item);
      _dispatchItemAdded(item);
      _dispatchChanged();
    } else {
      throw new RangeError('Invalid index:  $index');
    }
  }
  
  void remove(T item) {
    final index = indexOf(item);
    if (index < 0)
      throw new ArgumentError('Object is not part of this engine');
    
    _source.removeAt(index);
    _dispatchItemRemoved(item);
    _dispatchChanged();
  }
  
  void removeAt(int index) {
    if (index >= 0 && index < length) {
      final item = _source.removeAt(index);
      _dispatchItemRemoved(item);
      _dispatchChanged();
    } else {
      throw new RangeError('Invalid index:  $index');
    }
  }
  
  void swap(T item1, T item2) {
    final index1 = indexOf(item1);
    final index2 = indexOf(item2);
    if (index1 < 0 || index2 < 0)
      throw new ArgumentError('One of the item was not found');
    _source[index1] = item2;
    _source[index2] = item1;
    _dispatchChanged();
  }
  
  void swapAt(int index1, int index2) {
    final item1 = this[index1];
    final item2 = this[index2];
    _source[index1] = item2;
    _source[index2] = item1;
    _dispatchChanged();
  }
  
  void updateItemAt(int index) {
    dispatchEventWith(ITEM_UPDATED, index);
  }
  
  void updateItem(T item) {
    updateItemAt(indexOf(item));
  }
  
  void clear() {
    while (length > 0)
      removeAt(0);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Event Methods  ////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  void onItemAdded(EventListener<Event<T>> listener) {
    addEventListener(ITEM_ADDED, listener);
  }
  
  void onItemRemoved(EventListener<Event<T>> listener) {
    addEventListener(ITEM_REMOVED, listener);
  }
  
  void onItemUpdated(EventListener<Event<int>> listener) {
    addEventListener(ITEM_UPDATED, listener);
  }
  
  void onChanged(EventListener listener) {
    addEventListener(CHANGED, listener);
  }
  
}

