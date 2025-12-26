import '../storage/storage_service.dart';

class SessionManager {
  // KEYS (same as React Native AsyncStorage keys)
  static const String _tokenKey = 'token';
  static const String _usernameKey = 'username';
  static const String _userIdKey = 'userId';
  static const String _roleIdKey = 'roleId';

  // ================= SAVE SESSION =================
  static Future<void> saveSession({
    required String token,
    required String username,
    required String userId,
    required String roleId,
  }) async {
    await StorageService.save(_tokenKey, token);
    await StorageService.save(_usernameKey, username);
    await StorageService.save(_userIdKey, userId);
    await StorageService.save(_roleIdKey, roleId);
  }

  // ================= GET TOKEN =================
  static Future<String?> getToken() async {
    return await StorageService.get(_tokenKey);
  }

  // ================= GET USERNAME =================
  static Future<String?> getUsername() async {
    return await StorageService.get(_usernameKey);
  }

  // ================= CHECK LOGIN =================
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ================= LOGOUT =================
  static Future<void> logout() async {
    await StorageService.clear();
  }
}
