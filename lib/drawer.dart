import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

final FirebaseAuth _auth = FirebaseAuth.instance;

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
            var elements = <Widget>[
              _createHeader(),
              snapshot.hasData ? _createSignOut() : const SizedBox.shrink()
            ];
            return ListView(
              padding: EdgeInsets.zero,
              children: elements,
            );
          }),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor
      ),
      child: Text(
        globals.applicationName,
        style: Theme.of(context).textTheme.titleLarge?.merge(const TextStyle(color: Colors.white))
      ),
    );
  }

  Widget _createSignOut() {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Log out'),
      onTap: () {
        _auth.signOut();
      },
    );
  }
}
