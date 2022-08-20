import 'package:cloud_firestore/cloud_firestore.dart';

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

class Community {
  final String name;

  Community({required this.name});

  Community.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
    };
  }
}

final communityRef = FirebaseFirestore.instance.collection('communities').withConverter<Community>(
      fromFirestore: (snapshot, _) => Community.fromJson(snapshot.data()!),
      toFirestore: (community, _) => community.toJson(),
    );

Future<List<QueryDocumentSnapshot<Community>>> getCommunities() async {
  return await communityRef.get().then((value) => value.docs);
}