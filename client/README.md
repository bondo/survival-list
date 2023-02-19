# Survival List Client

A Flutter project for the Survival List clients.

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

## gRPC

### Setup

```
dart pub global activate protoc_plugin
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### Update generated proto files

```
protoc --dart_out=grpc:client/lib/src/generated -Iproto proto/api/v1/api.proto
```

## Manual client build

### aab

```
flutter build appbundle
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ~/upload-keystore.jks -signedjar release.aab build/app/outputs/bundle/release/app-release.aab upload
```

### apk

```
flutter build apk
~/Android/Sdk/build-tools/33.0.1/zipalign -p -v 4 build/app/outputs/flutter-apk/app-release.apk app-release-aligned.apk
~/Android/Sdk/build-tools/33.0.1/zipalign -vc 4 app-release-aligned.apk
~/Android/Sdk/build-tools/33.0.1/apksigner sign -verbose -ks ~/upload-keystore.jks --out app-release-signed.apk app-release-aligned.apk
adb install app-release-signed.apk
```
