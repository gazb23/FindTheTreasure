import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends ChangeNotifier {
  
  final QuestModel questModel;
  final LocationModel locationModel;
  Position currentPosition;
  LocationService({
    @required this.questModel,
    @required this.locationModel,
  })  : assert(questModel != null),
        assert(locationModel != null);

  

  getCurrentLocation() {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  double lat = locationModel.location['latitude'];
  double long = locationModel.location['longitude'];

    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
    .then((Position position) {
      
        currentPosition = position;
        if (lat.toStringAsFixed(3) == currentPosition.latitude.toStringAsFixed(3) && long.toStringAsFixed(3) == currentPosition.longitude.toStringAsFixed(3)) {
          print('success');
        } else {
          print('fail');
        }
        notifyListeners();
      
     

    }).catchError((e) {
      print(e.toString());
    });
}
}
