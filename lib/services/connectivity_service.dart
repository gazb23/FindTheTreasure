import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';


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
  static checkNetwork(BuildContext context) {
    final connectionStatus = context.watch<ConnectivityStatus>();
    
           if (connectionStatus == ConnectivityStatus.Offline) {
      Fluttertoast.showToast(
          msg: "Check your internet connection",
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,          
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

}


