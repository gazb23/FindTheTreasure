class QuestionsModel {
  final String id;
  final String challengeTitle;    
  final String questionIntroduction;
  final String question;
  final List<dynamic> answers;  
  final List<dynamic> challengeCompletedBy;  


  QuestionsModel({
    this.challengeTitle,
    this.questionIntroduction,
    this.question,
    this.answers,
    this.id,
    this.challengeCompletedBy,
  });

  factory QuestionsModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return QuestionsModel(
      id: documentId,
      answers: data['answers'],
      challengeTitle: data['challengeTitle'], 
      question: data['question'],
      questionIntroduction: data['questionIntroduction'],  
      challengeCompletedBy: data['challengeCompletedBy']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answers': answers,
      'challengeTitle': challengeTitle,   
      'question': question,
      'questionIntroduction': questionIntroduction,
      'challengeCompletedBy' : challengeCompletedBy
    };
  }
}
