class QuestModel {
  final String id;
  final String timeDifficulty;
  final String brainDifficulty;
  final String hikeDifficulty;
  final String title;
  final String description;
  final String difficulty;
  final String location;
  final String image;
  final int numberOfLocations;
  final int numberOfDiamonds;
  final int numberOfKeys;
  final int bountyDiamonds;
  final int bountyKeys;
  final List tags;
  final List likedBy;

  QuestModel({
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
    this.timeDifficulty,
    this.brainDifficulty,
    this.hikeDifficulty,
    this.bountyDiamonds,
    this.bountyKeys,
  });

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
      timeDifficulty: data['timeDifficulty'],
      brainDifficulty: data['brainDifficulty'],
      hikeDifficulty: data['hikeDifficulty'],
      bountyDiamonds: data['bountyDiamonds'],
      bountyKeys: data['bountyKeys'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'likedBy': likedBy,
      'title': title,
      'difficulty': difficulty,
      'description': description,
      'numberOfLocations': numberOfLocations,
      'location': location,
      'image': image,
      'numberOfDiamonds': numberOfDiamonds,
      'numberOfKeys': numberOfKeys,
      'tags': tags,
      'timeDifficulty': timeDifficulty,
      'brainDifficulty': brainDifficulty,
      'hikeDifficulty': hikeDifficulty,
      'bountyKeys': bountyKeys,
      'bountyDiamonds' : bountyDiamonds,
    };
  }

  Map<String, dynamic> updateHeart() {
    return {
      'id': id,
      'likedBy': likedBy,
    };
  }
}
