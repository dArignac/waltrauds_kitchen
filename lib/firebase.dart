/// The user class as stored in Firestore. Cannot use the name "User" as this clashes with the FirebaseAuth user.
class AuthenticatedUser {
  final String displayName;
  final String photoURL;

  AuthenticatedUser({required this.displayName, required this.photoURL});

  AuthenticatedUser.fromJson(Map<String, Object?> json)
      : this(
          displayName: json['displayName']! as String,
          photoURL: json['photoURL']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}
