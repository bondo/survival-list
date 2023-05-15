# Survival List Client

A Flutter project for the Survival List clients.

## Firebase

Update `lib/firebase_options.dart`:

```
flutterfire configure
```

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## Localization

This project generates localized messages based on arb files found in
the `lib/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

### Update client localization

Run `flutter gen-l10n`

## gRPC

### Setup

```
dart pub global activate protoc_plugin
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### Update generated proto files

See [packages/generated_grpc_api/README.md](./packages/generated_grpc_api/README.md)

## Remote debug

- Enable usb debugger
- Connect phone with usb
- Run `adb tcpip 5555`
- Disconnect usb
- Run `adb connect 192.168.1.86`

## Manual client build

### aab

bump version in `pubspec.yaml`, then

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
