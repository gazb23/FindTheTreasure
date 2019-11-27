import 'package:flutter/foundation.dart';

class QuestModel {
  final String id;
  final String title;  
  final String description;
  final String difficulty;  
  final String image;
  final int numberOfDiamonds;
  final int numberOfKeys;

  const QuestModel({
    this.id,
    @required this.image,
    @required this.description, 
    @required this.title,    
    @required this.difficulty,
    @required this.numberOfDiamonds,
    @required this.numberOfKeys,
  });

  factory QuestModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;    }
    final String title = data['title'];    
    final String difficulty = data['difficulty'];    
    final String description = data['description'];
    final String image = data['image'];
    final int numberOfDiamonds = data['numberOfDiamonds'];
    final int numberOfKeys = data['numberOfKeys'];
    
    
    return QuestModel(
      id: documentId,
      numberOfDiamonds: numberOfDiamonds,      
      difficulty: difficulty,
      numberOfKeys: numberOfKeys,
      title: title,
      description: description,
      image: image,
    );
  }
}
