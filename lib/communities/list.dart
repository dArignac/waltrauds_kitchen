import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waltrauds_kitchen/database.dart';
import 'package:waltrauds_kitchen/widgets/auth.dart';
import 'package:waltrauds_kitchen/widgets/layout.dart';

import '../main.dart';

class CommunitySelector extends StatefulWidget {
  const CommunitySelector({Key? key}) : super(key: key);

  @override
  State<CommunitySelector> createState() => _CommunitySelectorState();
}

/// List and link all communities.
/// Show community addition button.
class _CommunitySelectorState extends State<CommunitySelector> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> children = [
              const SizedBoxWidget(
                height: 50,
                child: Text(
                  'Your communities:',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              CommunityLinkList(userId: snapshot.data?.uid),
              const SizedBox(height: 20),
              SizedBoxWidget(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.communitiesCreate);
                  },
                  style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary),
                  child: const Text('Create a new community'),
                ),
              ),
            ];

            return BoxWidget(
              width: 500,
              children: children,
            );
          }
          return const UnauthorizedWidget();
        });
  }
}

class CommunityLinkList extends StatefulWidget {
  final String? userId;
  const CommunityLinkList({Key? key, required this.userId}) : super(key: key);

  @override
  State<CommunityLinkList> createState() => _CommunityLinkListState();
}

class _CommunityLinkListState extends State<CommunityLinkList> {
  @override
  Widget build(BuildContext context) {
    if (widget.userId == null) {
      return const UnauthorizedWidget();
    }

    return _getCommunities();
  }

  _getCommunities() {
    return FutureBuilder<List<QueryDocumentSnapshot<Community>>>(
        future: getCommunities(), // FIXME only list the comms the user belongs to
        builder: (context, snapshot) {
          List<Widget> communityLinks = [];

          snapshot.data?.forEach((element) {
            communityLinks.add(
              SizedBoxWidget(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {}, // FIXME impl
                  child: Text(element.data().name),
                ),
              ),
            );
          });

          if (communityLinks.isEmpty) {
            communityLinks = [
              const SizedBoxWidget(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text('No communities found.'),
                  )),
            ];
          }
          return Column(children: communityLinks);
        });
  }
}
