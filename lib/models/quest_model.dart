

class QuestModel {
  final String id;
  final List likedBy;
  final String title;
  final String description;
  final String difficulty;
  final String location;
  final String image;
  final int numberOfLocations;
  final int numberOfDiamonds;
  final int numberOfKeys;
  final List tags;

  QuestModel(
    {
    this.id,
    this.likedBy, 
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

  // Factory doesn't
  factory QuestModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return QuestModel(
      id: documentId,
      likedBy: data['likedBy'] != null ? data['likedBy'] : [],
      title: data['title'],
      difficulty: data['difficulty'],
      description: data['description'],
      numberOfLocations:
          data['numberOfLocations'] != null ? data['numberOfLocations'] : 1,
      location: data['location'],
      image: data['image'],
      numberOfDiamonds: data['numberOfDiamonds'],
      numberOfKeys: data['numberOfKeys'] != null ? data['numberOfKeys'] : 0,
      tags: data['tags'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'likedBy' : likedBy,
      'title': title,
      'difficulty': difficulty,
      'description': description,
      'numberOfLocations': numberOfLocations,
      'location': location,
      'image': image,
      'numberOfDiamonds': numberOfDiamonds,
      'numberOfKeys': numberOfKeys,
      'tags': tags,
      
    };
  }
}
