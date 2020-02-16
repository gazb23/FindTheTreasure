import 'package:flutter/foundation.dart';

class LocationModel {
  final String id;
  final String title;
  final String questionIntroduction;
  final String question;
  final int numberOfChallengesCompleted;
  final List<dynamic> answers;
  final List<dynamic> locationStartedBy;
  final List<dynamic> locationCompletedBy;

  LocationModel({
    @required this.id,
    @required this.title,
    @required this.questionIntroduction,
    @required this.question,
    @required this.numberOfChallengesCompleted, 
    @required this.answers,
    @required this.locationStartedBy,
    @required this.locationCompletedBy,
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
      numberOfChallengesCompleted: data['numberOfChallengesCompleted'],
      answers: data['answers'],
      locationCompletedBy: data['locationCompletedBy'],
      locationStartedBy: data['locationStartedBy'] ,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locationTitle': title,
      'questionIntroduction': questionIntroduction,
      'question': question,
      'numberOfChallengesCompleted' : numberOfChallengesCompleted,
      'answers': answers,
      'locationCompleted': locationCompletedBy,
      'locationProgressIndicator': locationStartedBy,
    };
  }
}
