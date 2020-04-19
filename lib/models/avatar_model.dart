class AvatarReference {
  AvatarReference(this.photoURL);
  final String photoURL;

  factory AvatarReference.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String photoURL = data['photoURL'];
    if (photoURL == null) {
      return null;
    }
    return AvatarReference(photoURL);
  }

  Map<String, dynamic> toMap() {
    return {
      'photoURL': photoURL,
    };
  }
}