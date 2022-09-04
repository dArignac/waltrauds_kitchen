#!/usr/bin/env sh
if [ -z "${FIREBASE_GOOGLE_AUTH_CLIENT_ID}" ]; then
  echo "Please set the Google Auth client id to the environment variable FIREBASE_GOOGLE_AUTH_CLIENT_ID"
else
  REV=$(git rev-parse --short HEAD)
  sed -i "s/const String gitRevision = 'main';/const String gitRevision = '${REV}';/" lib/drawer.dart
  flutter build web --dart-define FIREBASE_GOOGLE_AUTH_CLIENT_ID="$FIREBASE_GOOGLE_AUTH_CLIENT_ID" --dart-define=FIREBASE_EMULATOR=false
  firebase deploy
fi