# Waltraud's Kitchen

A weekly menu planning and receipt helper.


## Development

### Setup
* create a Firebase project
* run `flutterfire configure`
* create `.env.development` and `.env.production` based on the `.env.example`

#### Web
* update the _Authorized JavaScript Origin_ of the web client and add/edit `http://localhost:44444` under _Credentials_ on https://console.cloud.google.com/ (select the right project on the top)
  * also check if all required domain names are configured
* in Android Studio, edit the run config and add additional run arguments as provided below - this runs the web app on port 44444 and enables to use the Firebase emulators etc.
  * `--web-port=44444 --dart-define=FIREBASE_EMULATOR=true --dart-define=FIREBASE_GOOGLE_AUTH_CLIENT_ID=<clientid>`

#### Android
* add the SHA1 signing key to the Firebase project (project settings, select the Android app, add fingerprint), get the SHA1 by running `make signingReport` from root folder

### Start
* `firebase emulators:start`
* run Web or Android from IDE

### Firebase
* update Firebase config/bindings `flutterfire configure`
* configure emulator `firebase init` (choose emulator setup)

### Deploy web app
* `FIREBASE_GOOGLE_AUTH_CLIENT_ID=<clientid> make deploy`
