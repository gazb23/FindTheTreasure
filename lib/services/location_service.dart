
import 'package:app_settings/app_settings.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/permission_service.dart';
import 'package:find_the_treasure/view_models/location_view_model.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// This class will take the users current location and compare this to lat long of the quest location. If they match, then the user is at the correct location and the challenges will be presented, else, they'll be prompted to head to the location.
class LocationService {
  final QuestModel questModel;
  final LocationModel locationModel;
  final DatabaseService databaseService;
  Position currentPosition;
  LocationService({
    @required this.questModel,
    @required this.locationModel,
    @required this.databaseService,
  })  : assert(questModel != null),
        assert(databaseService != null),
        assert(locationModel != null);

 void getCurrentLocation(BuildContext context) async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    double lat = locationModel.location['latitude'];
    double long = locationModel.location['longitude'];

    await _checkGps(context);
    PermissionService(context: context).requestLocationPermission();
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      currentPosition = position;
      

      if ((lat * 100).truncateToDouble() / 100 ==
            (currentPosition.latitude * 100).truncateToDouble() / 100  &&
         (long * 100).truncateToDouble() / 100 ==
            (currentPosition.longitude * 100).truncateToDouble() / 100)  {
        LocationViewModel.submitLocationDiscovered(
            context: context,
            databaseService: databaseService,
            locationModel: locationModel,
            questModel: questModel);
      } else {
        
        LocationViewModel.submitLocationNotDiscovered(
            context: context,
            locationModel: locationModel,
            databaseService: databaseService,
            questModel: questModel);
      }
    }).catchError((e) {
      PlatformExceptionAlertDialog(title: 'Error', exception: e);
    });
  }

  Future _checkGps(BuildContext context) async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      
        final didRequest = await PlatformAlertDialog(
          title: 'Location Disabled',
          content: 'To continue your adventure please enable your location service.',
          image: Image.asset('images/event.png'),
          defaultActionText: 'ENABLE',
        ).show(context);
        if (didRequest) {
           AppSettings.openLocationSettings();
                    
        } else {
          return null;
        }
      }
    }
  }

