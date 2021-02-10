import 'package:app_settings/app_settings.dart';

import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/permission_service.dart';
import 'package:find_the_treasure/view_models/quest_view_model.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// This class will take the users current location and compare this to lat long of the burried treasure. If they match, then the user is at the correct location and the treasure will be rewarded, else, they'll be prompted to head to the location.

class TreasureLocationService extends ChangeNotifier {
  bool isLoading = false;

  final QuestModel questModel;
  final DatabaseService databaseService;

  Position currentPosition;
  TreasureLocationService({
    @required this.questModel,
    @required this.databaseService,
  })  : assert(questModel != null),
        assert(databaseService != null);

  void getCurrentLocation(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    double lat = questModel.treasureCoordinates['latitude'];
    double long = questModel.treasureCoordinates['longitude'];

    await _checkGps(context);

    bool permissionGranted =
        await PermissionService(context: context).requestLocationPermission();
    if (permissionGranted) {
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        currentPosition = position;

        if ((lat * 100).truncateToDouble() / 100 ==
                (currentPosition.latitude * 100).truncateToDouble() / 100 &&
            (long * 100).truncateToDouble() / 100 ==
                (currentPosition.longitude * 100).truncateToDouble() / 100) {
          QuestViewModel.submitTreasureDiscovered(
              context: context,
              databaseService: databaseService,
              questModel: questModel);
          isLoading = false;
          notifyListeners();
        } else {
          isLoading = false;
          notifyListeners();

          QuestViewModel.submitTreasureNotDiscovered(
              context: context,
              databaseService: databaseService,
              questModel: questModel);
        }
      }).catchError((e) {
        PlatformExceptionAlertDialog(title: 'Error', exception: e);
        isLoading = false;
        notifyListeners();
      });
    } else {
      print('denied');
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future _checkGps(BuildContext context) async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      final didRequest = await PlatformAlertDialog(
        title: 'Location Disabled',
        content:
            'To continue your adventure please enable your location service.',
        image: Image.asset('images/event.png'),
        defaultActionText: 'ENABLE',
      ).show(context);
      if (didRequest) {
        isLoading = false;
        notifyListeners();
        AppSettings.openLocationSettings();
      } else {
        isLoading = false;
        notifyListeners();
        return null;
      }
    }
  }
}
