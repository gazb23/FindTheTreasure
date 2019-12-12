class QuestModel {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String numberOfLocations;
  final String location;
  final String image;
  final int numberOfDiamonds;
  final int numberOfKeys;
  final List tags;

  const QuestModel({
    this.id,
    this.image,
    this.numberOfLocations,
    this.location,
    this.description,
    this.title,
    this.difficulty,
    this.numberOfDiamonds,
    this.numberOfKeys,
    this.tags, 
  });

  factory QuestModel.fromMap(Map data) {
    return QuestModel(
      title: data['title'],
      difficulty: data['difficulty'],
      description: data['description'],
      numberOfLocations: data['numberOfLocations'],
      location: data['location'],
      image: data['image'],
      numberOfDiamonds: data['numberOfDiamonds'],
      numberOfKeys: data['numberOfKeys'],
      tags: data['tags'],
    );
  }
}
