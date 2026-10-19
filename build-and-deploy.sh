#!/bin/bash
# Run from the ShrishtiGamesWeb folder:  ./build-and-deploy.sh
set -e
TOMCAT=/Users/shrishtidubey/Downloads/apache-tomcat-10.1.60
APP=ShrishtiGamesWeb

mkdir -p webapp/WEB-INF/classes
javac -cp "$TOMCAT/lib/servlet-api.jar:webapp/WEB-INF/lib/*" -d webapp/WEB-INF/classes src/com/shrishti/*.java

rm -rf "$TOMCAT/webapps/$APP"
cp -R webapp "$TOMCAT/webapps/$APP"

"$TOMCAT/bin/shutdown.sh" 2>/dev/null || true
sleep 2
"$TOMCAT/bin/startup.sh"
echo "Open: http://localhost:8080/$APP/"
