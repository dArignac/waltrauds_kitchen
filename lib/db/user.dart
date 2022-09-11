/// The user class as stored in Firestore. Cannot use the name "User" as this clashes with the FirebaseAuth user.
class AuthenticatedUser {
  final String displayName;
  String photoURL;
  final int communityCount;

  AuthenticatedUser({
    required this.displayName,
    required this.photoURL,
    required this.communityCount,
  });

  AuthenticatedUser.fromJson(Map<String, dynamic>? json)
      : this(
    displayName: json!['displayName']! as String,
    photoURL: json['photoURL']! as String,
    communityCount: json['communityCount'] as int,
  );

  Map<String, Object?> toJson() {
    return {
      'displayName': displayName,
      'photoURL': photoURL,
      'communityCount': communityCount,
    };
  }
}