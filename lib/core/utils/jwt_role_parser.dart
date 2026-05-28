import 'dart:convert';

class JwtRoleParser {
  /// Extracts role from JWT payload **without** calling any backend endpoint.
  ///
  /// Reads role claim from:
  /// - `http://schemas.microsoft.com/ws/2008/06/identity/claims/role`
  /// - fallback keys: `role`, `Role`, `userRole`, `UserRole`
  ///
  /// Returns raw role string (e.g. `Admin`) or null.
  static String? extractRole(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;

      final payloadBase64Url = parts[1];
      final payloadJson = utf8.decode(base64Url.decode(_padBase64Url(payloadBase64Url)));

      final payload = jsonDecode(payloadJson);
      if (payload is! Map<String, dynamic>) return null;

      final dynamic role =
          payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
          payload['role'] ??
          payload['Role'] ??
          payload['userRole'] ??
          payload['UserRole'];

      if (role == null) return null;
      final r = role.toString().trim();
      return r.isEmpty ? null : r;
    } catch (_) {
      return null;
    }
  }

  static String _padBase64Url(String input) {
    // base64Url.decode expects proper padding.
    final mod = input.length % 4;
    if (mod == 2) return '$input==';
    if (mod == 3) return '$input=';
    if (mod == 0) return input;
    return input;
  }
}
