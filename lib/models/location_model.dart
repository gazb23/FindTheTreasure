class LocationModel {
  final String id;
  final String locationTitle;
  final String locationProgressIndicator; 
  final String locationquestionIntroduction;
  final String locationQuestion;
  final List<dynamic> locationAnswers; 
  final bool locationCompleted;  
  

  LocationModel({
    this.locationTitle,
    this.locationProgressIndicator, 
    this.locationquestionIntroduction,
    this.locationQuestion,
    this.locationAnswers,
    this.locationCompleted,    
    this.id,
  });

  factory LocationModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return LocationModel(
      id: documentId,
      locationAnswers: data['answers'],
      locationCompleted: data['locationCompleted'],
      locationProgressIndicator: data['locationProgressIndicator'],
      locationTitle: data['locationTitle'],
      locationQuestion: data['question'],
      locationquestionIntroduction: data['questionIntroduction'],
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answers': locationAnswers,
      'locationCompleted': locationCompleted,
      'locationTitle': locationTitle,
      'locationProgressIndicator': locationProgressIndicator,
      'question': locationQuestion,      
      'questionIntroduction': locationquestionIntroduction,
      
      
    };
  }


}
