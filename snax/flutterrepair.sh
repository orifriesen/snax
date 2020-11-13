#!/bin/sh

# To run, download the script or copy the code to a '.sh' file (for example 'flutterrepair.sh') and run like any other script:
#   sh ./flutterrepair.sh
# or
#   sudo sh flutterrepair.sh

echo "Flutter Repair (by jeroen-meijer on GitHubGist)"

echo Cleaning project...
flutter clean 2>&1 >/dev/null

echo Updating Pod...
pod repo update

if ! ( "${PWD##*/}" == 'ios')
    then cd ios
fi

echo Removing pod files...
rm -rf Podfile.lock Pods/ 2>&1 >/dev/null

cd ..

echo Removing cached flutter dependency files...
rm -rf .packages .flutter-plugins 2>&1 >/dev/null

echo Getting all flutter packages...
flutter packages get

cd ios

echo Running pod install...
pod install

cd ..

echo DONE!
