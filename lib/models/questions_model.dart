class QuestionsModel {
  final String id;
  final String challengeTitle;
  final String questionIntroduction;
  final String question;
  final String questionType;
  final String image;
  final String hint;
  final Map<String, dynamic> answerA;
  final Map<String, dynamic> answerB;
  final Map<String, dynamic> answerC;
  final Map<String, dynamic> answerD;
  final List<dynamic> answers;
  final List<dynamic> challengeCompletedBy;
  final List<dynamic> hintPurchasedBy;

  QuestionsModel({
    this.challengeTitle,
    this.questionIntroduction,
    this.question,
    this.answers,
    this.id,
    this.hint, 
    this.challengeCompletedBy,
    this.hintPurchasedBy, 
    this.questionType,
    this.answerA,
    this.answerB,
    this.answerC,
    this.answerD,
    this.image, 
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
      hint: data['hint'],
      questionIntroduction: data['questionIntroduction'],
      challengeCompletedBy: data['challengeCompletedBy'],
      hintPurchasedBy: data['hintPurchasedBy'],
      questionType: data['questionType'],
      answerA: data['answerA'],
      answerB: data['answerB'],
      answerC: data['answerC'],
      answerD: data['answerD'],
      image: data['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answers': answers,
      'challengeTitle': challengeTitle,
      'question': question,
      'questionIntroduction': questionIntroduction,
      'challengeCompletedBy': challengeCompletedBy
    };
  }
}
