import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waltrauds_kitchen/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

class Environment {
  static bool get useFirebaseEmulator => dotenv.env['FIREBASE_EMULATOR'] == 'true';
  static String get firebaseGoogleAuthWebClientId => dotenv.env['FIREBASE_GOOGLE_AUTH_CLIENT_ID'] ?? 'none';
}

void main() async {
  await dotenv.load(fileName: '.env.${kReleaseMode ? 'production' : 'development'}');

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
              return const Text("FIXME I'm logged in");
            }
            return const AuthGate();
          },
        ),
      ),
    );
  }
}
