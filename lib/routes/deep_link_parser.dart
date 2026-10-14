import '../core/constants/route_constants.dart';

/// Maps a verified HTTPS link (Android App Links / iOS Universal Links) to an
/// in-app route.
///
/// `https://api.kauri-app.com/reset-password/<64 lowercase hex chars>` reaches
/// the router as the path `/reset-password/<token>`. Only a well-formed token
/// is accepted: anything else returns `null` and is left to the normal routing
/// rules (and ends on the 404/login handling) instead of being forwarded.
String? resetPasswordRouteFor(Uri uri) {
  final match = RegExp(
    r'^/reset-password/([a-f0-9]{64})$',
  ).firstMatch(uri.path);
  if (match == null) return null;
  return '${RouteConstants.resetPassword}?token=${match.group(1)}';
}
