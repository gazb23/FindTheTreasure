

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
    this.image,
    this.description, 
    this.title,    
    this.difficulty,
    this.numberOfDiamonds,
    this.numberOfKeys,
    
  });

  factory QuestModel.fromMap(Map data) {
    return QuestModel(
    title: data['title'],  
    difficulty: data['difficulty'],
    description: data['description'],
    image: data['image'],
    numberOfDiamonds: data['numberOfDiamonds'],
    numberOfKeys: data['numberOfKeys'],
    
    );
    
    
    
 
  }
}
