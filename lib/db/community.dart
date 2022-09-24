import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityPrivateData {
  late final Map<String, String> roles;

  CommunityPrivateData({required this.roles});

  CommunityPrivateData.fromJson(Map<String, Object?> json)
      : this(
          roles: json['roles']! as Map<String, String>,
        );

  Map<String, Object?> toJson() {
    return {
      'roles': roles,
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

// FIXME needs to be user specific - aka the communities the user is owner
Future<List<QueryDocumentSnapshot<Community>>> getCommunities() async {
  return await communityRef.get().then((value) => value.docs);
}

void createCommunity(Community community, String userId) async {
  CollectionReference communities = FirebaseFirestore.instance.collection('communities');

  // FIXME implement transaction as in DEV.md
  // FIXME how to handle errors?
  FirebaseFirestore.instance.runTransaction((transaction) async {
    communities.add(community.toJson()).then((value) {
      var privateData = CommunityPrivateData(roles: {userId: 'owner'});
      communities.doc(value.id).collection('private_data').doc('private').set(privateData.toJson());
    });
  });
}
