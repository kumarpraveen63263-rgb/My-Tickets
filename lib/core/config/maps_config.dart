/// Central switch for the Google Maps integration.
///
/// The interactive metro map requires a real Google Maps API key configured
/// natively — the `com.google.android.geo.API_KEY` meta-data in
/// `android/app/src/main/AndroidManifest.xml`, and the
/// `GMSServices.provideAPIKey(...)` call in `ios/Runner/AppDelegate.swift`.
/// Both files already have the wiring in place with a `YOUR_API_KEY_HERE`
/// placeholder and a `// TODO` pointing at where to get a key.
///
/// A placeholder/invalid key doesn't just fail to render — on Android in
/// particular, the native map view can crash during initialization before
/// any Dart-side try/catch or error boundary gets a chance to run. There is
/// no reliable cross-platform signal from `google_maps_flutter` for "the key
/// is missing/invalid" that Dart code can catch safely.
///
/// So instead of trying to detect a bad key at runtime, this flag is the
/// single source of truth: leave it `false` until a real key has been added
/// to BOTH platform files above, then flip it to `true`. Every map surface
/// in the app (embedded card + fullscreen screen) checks this flag and shows
/// a graceful fallback — with a path back into the existing text-based
/// station search — while it's `false`, so the app never crashes for anyone
/// who hasn't configured a key yet.
class MapsConfig {
  MapsConfig._();

  static const bool hasApiKey = false;
}
