import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

enum ConnectivityStatus {
  Offline,
  Online,
}

class ConnectivityService {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

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
        return ConnectivityStatus.Online;
    }
  }

  static bool checkNetwork(BuildContext context, {@required bool listen}) {
    print('checking');
 
    final isConnected =
        Provider.of<DataConnectionStatus>(context, listen: listen);
    final connectionStatus =
        Provider.of<ConnectivityStatus>(context, listen: listen);
 
    
      if (connectionStatus == ConnectivityStatus.Online || isConnected == DataConnectionStatus.connected) {
         print('connected');
        return true;
      }
    
     else {
      if (isConnected == DataConnectionStatus.disconnected
          // connectionStatus == ConnectivityStatus.Offline
          ) {
          print('connection Lost');
        // Fluttertoast.showToast(
        //     msg: "Check your internet connection",
        //     timeInSecForIosWeb: 4,
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.TOP,
        //     backgroundColor: Colors.grey.withOpacity(0.7),
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }
    }
    return false;
  }
}
