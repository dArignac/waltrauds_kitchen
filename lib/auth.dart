import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waltrauds_kitchen/widgets/center.dart';

import 'firebase.dart';
import 'main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

typedef OAuthSignIn = void Function();

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Map<Buttons, OAuthSignIn> authButtons;
  String error = '';
  bool isLoading = false;

  Future<void> _signInWithGoogle() async {
    setIsLoading();

    try {
      String clientId = '';
      // we only need the clientId for the web
      if (kIsWeb) {
        clientId = Environment.firebaseGoogleAuthWebClientId;
      }
      final googleUser = await GoogleSignIn(clientId: clientId).signIn();
      final googleAuth = await googleUser?.authentication;
      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        _createOrUpdateUserDocument();
      } else {
        // FIXME general error handling
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = '${e.message}';
      });
    } finally {
      setIsLoading();
    }
  }

  /// Creates or updates the user document in Firestore.
  _createOrUpdateUserDocument() {
    CollectionReference<Map<String, dynamic>> users = FirebaseFirestore.instance.collection('users');
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      users.doc(user.uid).get().then((snapshot) {
        // FIXME need to merge only FirebaseAuth data once the user object is extended further
        final userData = AuthenticatedUser(displayName: user.displayName!, photoURL: user.photoURL ?? '').toJson();
        // FIXME add general error handling
        users.doc(user.uid).set(userData).onError((error, _) => print("Error writing user document: $error"));
      });
    } else {
      // FIXME if auth failed we're lost
    }
  }

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      authButtons = {
        Buttons.Google: _signInWithGoogle,
      };
    } else {
      authButtons = {
        if (!Platform.isMacOS) Buttons.Google: _signInWithGoogle,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return CenterWidget(children: [
      Text('Welcome to Waltraud\'s kitchen.', style: Theme.of(context).textTheme.headline5),
      const SizedBox(
        height: 20,
      ),
      SingleChildScrollView(
        child: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              children: [
                Visibility(
                  visible: error.isNotEmpty,
                  child: MaterialBanner(
                    backgroundColor: Theme.of(context).errorColor,
                    content: Text(error),
                    actions: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              error = '';
                            });
                          },
                          child: const Text('Dismiss', style: TextStyle(color: Colors.white))),
                    ],
                    contentTextStyle: const TextStyle(color: Colors.white),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: isLoading ? const LinearProgressIndicator() : const Text("Please log in to continue:"),
                  ),
                ),
                // iterate the auth buttons
                ...authButtons.keys
                    .map(
                      (button) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isLoading
                              ? Container(
                                  color: Colors.grey[200],
                                  height: 50,
                                  width: double.infinity,
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: SignInButton(button, onPressed: authButtons[button]!),
                                ),
                        ),
                      ),
                    )
                    .toList()
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
