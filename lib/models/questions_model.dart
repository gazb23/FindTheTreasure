class QuestionsModel {
  final String id;
  final String locationTitle;
  final String challengeTitle;  
  final String challengeProgressIndicator;
  final String challengeProgressImage;
  final String questionIntroduction;
  final String question;
  final List<String> answers;
  final bool challengeCompleted;
  final bool questCompleted;
  final bool locationCompleted;
  final int numberOfChallenges;
  final int numberOfChallengesCompleted;

  QuestionsModel({
    this.locationTitle,
    this.challengeTitle,    
    this.challengeProgressIndicator,
    this.challengeProgressImage,
    this.questionIntroduction,
    this.question,
    this.answers,
    this.challengeCompleted,
    this.questCompleted,
    this.locationCompleted,
    this.numberOfChallenges,
    this.numberOfChallengesCompleted,
    this.id,
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
      locationCompleted: data['locationCompleted'],
      locationTitle: data['locationTitle'],
      numberOfChallengesCompleted: data['numberOfChallengesCompleted'],
      numberOfChallenges: data['numberOfChallenges'],
      questCompleted: data['questCompleted'],
      question: data['question'],
      questionIntroduction: data['questionIntroduction'],
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answers': answers,
      'challengeCompleted': challengeCompleted,
      'challengeProgressImage': challengeProgressImage,
      'challengeProgressIndicator': challengeProgressIndicator,
      'challengeTitle': challengeTitle,
      'locationCompleted': locationCompleted,
      'locationTitle': locationTitle,
      'numberOfChallengedCompleted': numberOfChallengesCompleted,
      'numberOfChallenges': numberOfChallenges,
      'questCompleted': questCompleted,
      'question': question,      
      'questionIntroduction': questionIntroduction,
      
      
    };
  }


}
