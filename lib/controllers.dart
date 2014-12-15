library pixies.controllers;

import 'dart:async';

part 'src/controllers/child.dart';
part 'src/controllers/parent.dart';
part 'src/controllers/controller.dart';
part 'src/controllers/controller_container.dart';

part 'src/controllers/commands/command.dart';
part 'src/controllers/commands/data_command.dart';
part 'src/controllers/commands/delayed_data.dart';
part 'src/controllers/commands/delayed_error.dart';

part 'src/controllers/data/list_collection.dart';

part 'src/controllers/events/abstract_event.dart';
part 'src/controllers/events/event.dart';
part 'src/controllers/events/event_dispatcher.dart';

part 'src/controllers/logging/log_level.dart';
part 'src/controllers/logging/log_event.dart';
part 'src/controllers/logging/logger.dart';

part 'src/controllers/motion/animatable.dart';
part 'src/controllers/motion/animator.dart';

/// The generic type of event listeners.
typedef void EventListener<T extends AbstractEvent>(T event);

/// The type of log listener methods.
typedef void LogListener(LogEvent event);

/*
void main() {
  
  final controller = new Controller();
  controller.addLogListener(logListener);
  
  controller.level = LogLevel.ALL;
  
  controller.logConfig('haha', {'alpha': 1.0});
  controller.logError('hihi');
  
}

void logListener(LogEvent event) {
  print(event);
}
*/
