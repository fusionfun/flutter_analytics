part of "flutter_analytics.dart";

typedef EventHook = void Function(String name, Map<String, dynamic> parameters);

class EventTransmitter {
  final EventHook? hook;

  EventTransmitter({this.hook});

  void transmit(String name, Map<String, dynamic> parameters) {
    hook?.call(name, parameters);
  }
}
