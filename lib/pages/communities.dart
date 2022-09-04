import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waltrauds_kitchen/communities/list.dart';
import 'package:waltrauds_kitchen/widgets/layout.dart';
import 'package:waltrauds_kitchen/widgets/auth.dart';

import '../communities/edit.dart';
import '../drawer.dart';
import '../globals.dart' as globals;

class CommunityListPage extends StatelessWidget {
  const CommunityListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FIXME refactor to reuse scaffold
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
          return const UnauthorizedWidget();
        },
      ),
    );
  }
}

class CommunityCreatePage extends StatelessWidget {
  const CommunityCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FIXME refactor to reuse scaffold
    return Scaffold(
      appBar: AppBar(title: Text(globals.applicationName)),
      drawer: const DrawerWidget(),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const CenterWidget(
              children: [CommunityCreateForm()],
            );
          }
          return const UnauthorizedWidget();
        },
      ),
    );
  }
}
