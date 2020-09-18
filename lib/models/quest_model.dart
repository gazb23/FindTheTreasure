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
  final String treasureImage;
  final String treasureDirections;
  final int numberOfLocations;
  final int numberOfDiamonds;
  final int numberOfKeys;
  final int bountyDiamonds;
  final int bountyKeys;
  final int questPoints;
  final int hintCost;
  final int skipCost;
  final bool isLive;
  final List tags;
  final List likedBy;
  final List questStartedBy;
  final List questCompletedBy;
  final List treasureDiscoveredBy;
  final List imageURL;
  final Map<String, dynamic> treasureCoordinates;

  QuestModel( {
    this.id,
    this.likedBy,
    this.questStartedBy,
    this.questCompletedBy,
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
    this.questPoints,
    this.isLive,
    this.hintCost,
    this.skipCost,
    this.treasureDirections,
    this.treasureCoordinates,
    this.treasureDiscoveredBy,
    this.treasureImage,
    this.imageURL,
  });

  factory QuestModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return QuestModel(
      id: documentId,
      likedBy: data['likedBy'] != null ? data['likedBy'] : [],
      questStartedBy:
          data['questStartedBy'] != null ? data['questStartedBy'] : [],
      questCompletedBy:
          data['questCompletedBy'] != null ? data['questCompletedBy'] : [],
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
      questPoints: data['questPoints'],
      isLive: data['isLive'],
      hintCost: data['hintCost'],
      skipCost: data['skipCost'],
      treasureCoordinates: data['treasureCoordinates'],
      treasureDirections: data['treasureDirections'],
      treasureDiscoveredBy: data['treasureDiscoveredBy'],
      treasureImage: data['treasureImage'],
      imageURL: data['imageURL']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'likedBy': likedBy,
      'questStartedBy': questStartedBy,
      'questCompletedBy': questCompletedBy,
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
      'bountyDiamonds': bountyDiamonds,
      'questPoints': questPoints,
      'imageURL': imageURL
    };
  }

  Map<String, dynamic> updateHeart() {
    return {
      'id': id,
      'likedBy': likedBy,
    };
  }
}
