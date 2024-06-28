// ignore_for_file: unused_field

import 'dart:isolate';

import 'package:flutter/foundation.dart';

class IsolatePixManager {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;
  ReceivePort? _responsePort;

  IsolatePixManager._privateConstructor();

  static final IsolatePixManager _instance =
      IsolatePixManager._privateConstructor();

  static IsolatePixManager get instance => _instance;

  void startVariables(Isolate isolate, ReceivePort receivePort,
      ReceivePort responsePort, SendPort sendPort) {
    _killCurrent();

    _isolate = isolate;
    _receivePort = receivePort;
    _responsePort = responsePort;
    _sendPort = sendPort;
  }

  void _killCurrent() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;

    _responsePort?.close();
    _responsePort = null;

    _receivePort?.close();
    _receivePort = null;

    _sendPort = null;
  }

  void kill() {
    _killCurrent();
    if (kDebugMode) print('IsolatePixPdvManager killed');
  }
}
