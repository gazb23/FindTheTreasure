import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/view_models/location_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  getCurrentLocation(BuildContext context) async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    
    double lat = locationModel.location['latitude'];
    double long = locationModel.location['longitude'];
    
     GeolocationStatus locationStatus = await Geolocator().checkGeolocationPermissionStatus();
     if (locationStatus == GeolocationStatus.disabled || locationStatus == GeolocationStatus.denied) {
       
       return GeolocationPermission.location;
     }
     bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
     if (isLocationEnabled) {
       geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      currentPosition = position;
      if (lat.toStringAsFixed(3) ==
              currentPosition.latitude.toStringAsFixed(3) &&
          long.toStringAsFixed(3) ==
              currentPosition.longitude.toStringAsFixed(3)) {
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
      print(e.toString());
    });
     } 
    
  }
}
