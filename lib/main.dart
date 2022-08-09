import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:waltrauds_kitchen/auth.dart';

import 'firebase_options.dart';

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
  }

  runApp(const WaltraudKitchenApp());
}

class WaltraudKitchenApp extends StatelessWidget {
  const WaltraudKitchenApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const name = 'Waltraud\'s Kitchen';
    return MaterialApp(
      title: name,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      // FIXME move the scaffold to sub components?
      home: Scaffold(
        appBar: AppBar(title: const Text(name)),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const Text("FIXME I'm logged in"),
                  TextButton(onPressed: (){}, child: Text("Logout")),
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
