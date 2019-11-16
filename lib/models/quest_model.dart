import 'package:flutter/foundation.dart';

class QuestModel {
  final String id;
  final String title;  
  final String difficultyTitle;
  final String difficultyColor;
  final int diamondCount;
  final int keyCount;

  const QuestModel({
    @required this.id,
    @required this.title,
    @required this.difficultyColor,
    @required this.difficultyTitle,
    @required this.diamondCount,
    @required this.keyCount,
  });

  factory QuestModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;    }
    final String title = data['title'];    
    final String difficultyTitle = data['difficultyTitle'];
    final String difficultyColor = data['difficultyColor'];
    final int diamondCount = data['diamondCount'];
    final int keyCount = data['keyCount'];
    return QuestModel(
      id: documentId,
      diamondCount: diamondCount,
      difficultyColor: difficultyColor,
      difficultyTitle: difficultyTitle,
      keyCount: keyCount,
      title: title,
    );
  }
}
