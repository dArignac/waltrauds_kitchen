deploy:
	./deploy.sh

signingReport:
	cd android && ./gradlew signingReport
