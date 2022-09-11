import 'package:cloud_firestore/cloud_firestore.dart';

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

// FIXME needs to be user specific - aka the communities the user is owner
Future<List<QueryDocumentSnapshot<Community>>> getCommunities() async {
  return await communityRef.get().then((value) => value.docs);
}
