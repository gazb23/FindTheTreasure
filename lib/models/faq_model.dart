class FAQModel {
  final String id;
  final String question;
  final String answer;

  FAQModel({
    this.question,
    this.answer,
    this.id,
  });

  factory FAQModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return FAQModel(
      id: documentId,
      question: data['question'],
      answer: data['answer'],
    );
  }
}
