import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';

class LearninkConnectionStatus {
  LearninkConnectionStatus._();

  static final LearninkConnectionStatus _singleton = new LearninkConnectionStatus
      ._();

  static LearninkConnectionStatus get instance => _singleton;
  bool hasConnection = false;
  Stream<bool> get connectionStatus => _statusController.stream;
  StreamController<bool> _statusController = StreamController.broadcast();
  Timer _t;

  void initialize() {
    _statusController.add(hasConnection);
    checkConnection();
    _connectionChange();
  }
  void pause()
  {
    if(_t!=null) {
      _t.cancel();
    }
   }

  void restart()
  {
    _connectionChange();
  }


  void dispose() {
    if(_t!=null) {
      _t.cancel();
    }
    _statusController.close();
  }

  void _connectionChange() {


    _t=Timer.periodic(Duration(seconds: 1), (Timer t) async {
      await checkConnection();
    });
  }

  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('firebase.google.com')
          .timeout(Duration(seconds: 1),);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }
    on TimeoutException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
     _statusController.add(hasConnection);
      //print('Connection status has changed $hasConnection');

  }

}

