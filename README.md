# Waltraud's Kitchen

A weekly menu planning and receipt helper.


## Development

### Setup
* create a Firebase project
* run `flutterfire configure`
* create `.env.development` and `.env.production` based on the `.env.example`
* update the _Authorized JavaScript Origin_ of the web client and add/edit `http://localhost:44444` under _Credentials_ on https://console.cloud.google.com/ (select the right project on the top)
* in Android Studio, edit the run config and add additional run argument `--web-port=44444` - this runs the web app on port 44444 and enables to use the Firebase emulators

### Start
* `firebase emulators:start`
* run Web or Android from IDE

### Firebase
* update Firebase config/bindings `flutterfire configure`
* configure emulator `firebase init` (choose emulator setup)

### Deploy web app
* `flutter build web`
* `firebase deploy`
