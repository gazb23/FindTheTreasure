import 'dart:async';

import 'package:connectivity/connectivity.dart';

enum ConnectivityStatus {
  Offline, 
  Online,
}

class ConnectivityService {

  StreamController<ConnectivityStatus> connectionStatusController = StreamController<ConnectivityStatus>();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      var connectionStatus = _getStatusFromResult(result);

      connectionStatusController.add(connectionStatus);
    });
  }
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.none: 
        return ConnectivityStatus.Offline;
      case ConnectivityResult.wifi: 
        return ConnectivityStatus.Online;  
      case ConnectivityResult.mobile: 
        return ConnectivityStatus.Online;   
      default:
      return ConnectivityStatus.Offline;
    }
  }

}

