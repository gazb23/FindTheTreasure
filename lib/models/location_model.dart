import 'package:flutter/foundation.dart';

class LocationModel {
  final String id;
  final String title;
  final String questionIntroduction;
  final String question;
  final List<dynamic> answers;
  final List<dynamic> locationStartedBy;
  final List<dynamic> locationCompletedBy;
  final List<dynamic> locationDiscoveredBy;
  final Map<String, dynamic> location;

  LocationModel({
    @required this.id,
    @required this.title,
    @required this.questionIntroduction,
    @required this.question, 
    @required this.answers,
    @required this.locationStartedBy,
    @required this.locationCompletedBy,
    @required this.location, 
    @required this.locationDiscoveredBy
  });

  factory LocationModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return LocationModel(
      id: documentId,
      title: data['locationTitle'],
      questionIntroduction: data['questionIntroduction'],
      question: data['question'],    
      answers: data['answers'],
      locationCompletedBy: data['locationCompletedBy'],
      locationStartedBy: data['locationStartedBy'] ,
      locationDiscoveredBy: data['locationDiscoveredBy'],
      location: data['location'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locationTitle': title,
      'questionIntroduction': questionIntroduction,
      'question': question,    
      'answers': answers,
      'locationCompleted': locationCompletedBy,
       'locationStartedBy': locationStartedBy,
       'locationDiscoveredBy' : locationDiscoveredBy
     
    };
  }
}
