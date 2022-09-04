import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waltrauds_kitchen/auth.dart';

import '../communities/list.dart';
import '../drawer.dart';
import '../globals.dart' as globals;
import '../widgets/layout.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(globals.applicationName)),
      drawer: const DrawerWidget(),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const CenterWidget(
              children: [CommunitySelector()],
            );
          }
          return const AuthGate();
        },
      ),
    );
  }
}
