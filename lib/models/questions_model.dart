class QuestionsModel {
  final String id;


  QuestionsModel({
    this.id,

  });

  
  factory QuestionsModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return QuestionsModel(
      id: documentId,

    );
  }



}
