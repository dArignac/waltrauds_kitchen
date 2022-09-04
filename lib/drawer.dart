import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waltrauds_kitchen/database.dart';

import 'globals.dart' as globals;
import 'main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

// this is replaced by deploy.sh
const String gitRevision = 'main';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // the navigation list
            var elements = <Widget>[
              _createHeader(snapshot.hasData ? _createUserInfo(snapshot.data) : const SizedBox.shrink()),
              _createCommunityOverview(),
              snapshot.hasData ? _createSignOut() : const SizedBox.shrink(),
              const SizedBox(height: 20),
              _createVersionInfo(),
            ];

            return ListView(
              padding: EdgeInsets.zero,
              children: elements,
            );
          }),
    );
  }

  Widget _createHeader(Widget userInfo) {
    return DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            globals.applicationName,
            style: Theme.of(context).textTheme.titleLarge?.merge(const TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 20),
          userInfo,
        ],
      ),
    );
  }

  Widget _createUserInfo(User? firebaseUser) {
    if (firebaseUser != null) {
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get(),
        builder: (context, snapshot) {
          var isEmpty = snapshot.hasData && !snapshot.data!.exists;

          if (!snapshot.hasError && !isEmpty && snapshot.connectionState == ConnectionState.done) {
            var user = AuthenticatedUser.fromJson(snapshot.data?.data() as Map<String, dynamic>);

            return Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(user.photoURL)),
                const SizedBox(width: 10),
                Text(
                  user.displayName,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _createCommunityOverview() {
    return ListTile(
      leading: const Icon(Icons.list),
      title: const Text('Your Communities'),
      onTap: () {
        Navigator.pushReplacementNamed(context, Routes.communitiesList);
      },
    );
  }

  Widget _createSignOut() {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Log out'),
      onTap: () {
        _auth.signOut();
        Navigator.pushReplacementNamed(context, Routes.home);
      },
    );
  }

  Widget _createVersionInfo() {
    return const ListTile(
      leading: Icon(Icons.code),
      title: Text(gitRevision),
    );
  }
}
