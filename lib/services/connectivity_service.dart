import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        return ConnectivityStatus.Offline;
    }
  }

  static bool checkNetwork(BuildContext context) {
    final isConnected = Provider.of<DataConnectionStatus>(context, listen: true);
    final connectionStatus = Provider.of<ConnectivityStatus>(context, listen: true);
   
    if (connectionStatus == ConnectivityStatus.Online) {
      if (isConnected == DataConnectionStatus.connected) {
        return true;
      
      }
     
    } else {
      
      Fluttertoast.showToast(
          msg: "Check your internet connection",
          timeInSecForIosWeb: 4,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.grey.withOpacity(0.7),
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return false;
  }
  
}
