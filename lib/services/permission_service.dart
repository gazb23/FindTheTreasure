import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final BuildContext context;
  final PermissionHandler _permessionHandler = PermissionHandler();
  PermissionService({@required this.context});

  Future<bool> _requestPermission(PermissionGroup permissionGroup) async {
    var result = await _permessionHandler.requestPermissions([permissionGroup]);

    if (result[permissionGroup] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  /// Requests the users permission to read their location when the app is in use
  Future<bool> requestLocationPermission() async {
    
    var permissionStatus = await _permessionHandler
        .checkPermissionStatus(PermissionGroup.location);
        print(permissionStatus);
    if (permissionStatus == PermissionStatus.granted) {
      return null;
    } else {
      var granted = await _requestPermission(PermissionGroup.locationWhenInUse);
      if (!granted) {
        permissionDenied(context);
      }

      return granted;
    }
  }
}

void permissionDenied(BuildContext context) async {
  final permission = await PlatformAlertDialog(
          title: 'Location Permission Required',
          content:
              'We take your privacy seriously. We do not store your location data and only access it momentarliy to check your location to unlock challenges.',
          defaultActionText: 'ENABLE')
      .show(context);
  if (permission) {
    PermissionHandler().openAppSettings();
  }
}
