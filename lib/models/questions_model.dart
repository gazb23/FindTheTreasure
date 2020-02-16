class QuestionsModel {
  final String id;
  final String challengeTitle;
  final String challengeProgressIndicator;
  final String challengeProgressImage;
  final String questionIntroduction;
  final String question;
  final List<dynamic> answers;
  final List<dynamic> challengeStartedBy;
  final List<dynamic> challengeCompletedBy;
  final bool challengeCompleted;
  final bool questCompleted;

  QuestionsModel({
    this.challengeTitle,
    this.challengeProgressIndicator,
    this.challengeProgressImage,
    this.questionIntroduction,
    this.question,
    this.answers,
    this.challengeCompleted,
    this.questCompleted,
    this.id,
    this.challengeStartedBy,
    this.challengeCompletedBy,
  });

  factory QuestionsModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return QuestionsModel(
      id: documentId,
      answers: data['answers'],
      challengeCompleted: data['challengeCompleted'],
      challengeProgressImage: data['challengeProgressImage'],
      challengeProgressIndicator: data['challengeProgressIndicator'],
      challengeTitle: data['challengeTitle'],
      questCompleted: data['questCompleted'],
      question: data['question'],
      questionIntroduction: data['questionIntroduction'],
      challengeStartedBy: data['challengeStartedBy'],
      challengeCompletedBy: data['challengeCompletedBy']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answers': answers,
      'challengeCompleted': challengeCompleted,
      'challengeProgressImage': challengeProgressImage,
      'challengeProgressIndicator': challengeProgressIndicator,
      'challengeTitle': challengeTitle,
      'questCompleted': questCompleted,
      'question': question,
      'questionIntroduction': questionIntroduction,
      'challengeStartedBy' : challengeStartedBy,
      'challengeCompletedBy' : challengeCompletedBy
    };
  }
}
