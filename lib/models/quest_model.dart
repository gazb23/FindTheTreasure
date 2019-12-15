class QuestModel {
  final String id;
  final bool heartIsSelected;
  final String title;
  final String description;
  final String difficulty;  
  final String location;
  final String image;
  final int numberOfLocations;
  final int numberOfDiamonds;
  final int numberOfKeys;
  final List tags;

  const QuestModel( {
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
    this.heartIsSelected,
  });

  factory QuestModel.fromMap(Map data) {
    return QuestModel(
      title: data['title'],
      difficulty: data['difficulty'],
      description: data['description'],
      numberOfLocations: data['numberOfLocations'] != null ? data['numberOfLocations'] : 1,
      location: data['location'] ,
      image: data['image'],
      numberOfDiamonds: data['numberOfDiamonds'] ,
      numberOfKeys: data['numberOfKeys'] != null ? data['numberOfKeys'] : 0,
      tags: data['tags'],
      heartIsSelected: data['heartIsSelected'] ?? false,
    );
  }
}
