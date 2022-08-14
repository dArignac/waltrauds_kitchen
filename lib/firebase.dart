/// The user class as stored in Firestore. Cannot use the name "User" as this clashes with the FirebaseAuth user.
class AuthenticatedUser {
  final String photoURL;

  AuthenticatedUser({required this.photoURL});

  AuthenticatedUser.fromJson(Map<String, Object?> json)
      : this(
          photoURL: json['photoURL']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'photoURL': photoURL,
    };
  }
}
