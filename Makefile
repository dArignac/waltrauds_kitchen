deploy:
	flutter build web --dart-define FIREBASE_GOOGLE_AUTH_CLIENT_ID=$FIREBASE_GOOGLE_AUTH_CLIENT_ID --dart-define=FIREBASE_EMULATOR=false
	firebase deploy

signingReport:
	cd android && ./gradlew signingReport
