import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:waltrauds_kitchen/pages/communities.dart';
import 'package:waltrauds_kitchen/pages/home.dart';

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

/// Holds routes for re-usability.
class Routes {
  static const String home = '/';
  static const String communitiesList = '/communities';
  static const String communitiesCreate = '/communities/new';
}

class WaltraudKitchenApp extends StatelessWidget {
  const WaltraudKitchenApp({Key? key}) : super(key: key);

  _getRoutes() {
    return {
      Routes.home: (context) => const Home(), // default route
      Routes.communitiesList: (context) => const CommunityListPage(),
      Routes.communitiesCreate: (context) => const CommunityCreatePage(),
    };
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(primarySwatch: Colors.indigo);
    return MaterialApp(
      title: globals.applicationName,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.blue),
      ),
      //darkTheme: ThemeData.dark(), // FIXME this looks weird, maybe need to configure properly
      routes: _getRoutes(),
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: FormBuilderLocalizations.delegate.supportedLocales,
    );
  }
}
