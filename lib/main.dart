import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:waltrauds_kitchen/auth.dart';
import 'package:waltrauds_kitchen/drawer.dart';
import 'package:waltrauds_kitchen/widgets/center.dart';

import 'firebase_options.dart';
import 'globals.dart' as globals;

class Environment {
  static bool get useFirebaseEmulator => const String.fromEnvironment('FIREBASE_EMULATOR') == 'true';
  static String get firebaseGoogleAuthWebClientId => const String.fromEnvironment('FIREBASE_GOOGLE_AUTH_CLIENT_ID');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (Environment.useFirebaseEmulator) {
    try {
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      //print(e);
    }
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }

  runApp(const WaltraudKitchenApp());
}

class WaltraudKitchenApp extends StatelessWidget {
  const WaltraudKitchenApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: globals.applicationName,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: Text(globals.applicationName)),
        drawer: const DrawerWidget(),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CenterWidget(
                children: [
                  Column(
                    children: const [
                      Text("Hello!"),
                    ],
                  )
                ],
              );
            }
            return const AuthGate();
          },
        ),
      ),
    );
  }
}
