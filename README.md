# Waltraud's Kitchen

A weekly menu planning and receipt helper.


## Development

### Setup
* create a Firebase project
* run `flutterfire configure`
* update the _Authorized JavaScript Origin_ of the web client and add/edit `http://localhost:44444` under _Credentials_ on https://console.cloud.google.com/ (select the right project on the top)
* create `lib/config.dart` (see below)
* in Android Studio, edit the run config and add additional run argument `--web-port=44444` - this runs the web app on port 44444
* 

```
# lib/config.dart
const String firebaseGoogleAuthWebClientId = '<get from Firebase console - SignIn method config';
```

### Firebase
* update Firebase config/bindings `flutterfire configure`
* configure emulator `firebase init` (choose emulator setup)
* run emulators `firebase emulators:start`