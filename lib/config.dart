// Base URL of the Django backend.
//
// This used to be a fixed LAN address, which meant every installed copy of
// the app tried to reach one particular laptop on one particular home WiFi.
// It is now supplied at build time, exactly like the customer app.
//
// While developing, the default below is used:
//   - Android Emulator  -> http://10.0.2.2:8000/api
//   - Real phone on the same WiFi as your PC -> http://<YOUR_PC_LAN_IP>:8000/api
//     Find the IP with `ipconfig` on Windows, and run Django with
//     `python manage.py runserver 0.0.0.0:8000` so it listens beyond localhost.
//
// For any build a real vendor will install, pass the production URL:
//   flutter build apk --dart-define=API_BASE_URL=https://api.example.com/api
//
// Note there is no trailing slash, and https is required once the backend
// enforces it -- an https page cannot call an http API.
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: "http://192.168.1.9:8000/api",
);

/// The wordmark shown when the backend has no branding set.
///
/// An admin can override the name (and the logo) from the dashboard's
/// branding screen; this is only what the app falls back to when that call
/// returns nothing, which is what happens today. Keep it in one place -- it
/// was previously spelled out per screen, so the splash and the login card
/// could drift apart. The customer app has the same constant, set to
/// "RNI Services".
const String kAppName = 'RNI Vendor';
