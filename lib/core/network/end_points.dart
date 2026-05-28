abstract class EndPoints{
  static const String baseUrl = 'https://mo3tarib123.runasp.net';
  static const String login = '/api/Account/login';
  static const String register = '/api/Account/Register';

  // https://mo3tarib123.runasp.net/api/Account/UserRoles
  static const String userRoles = '/api/Account/UserRoles';

  // ============ Home (Admin) ============
  static const String getAllUsers = '/api/Account/GetAllUsers';
  static const String deleteUser = '/api/Account/DeleteUser';
  static const String searchByName = '/api/Account/SearchByName';

  static const String getAllSanaieeia = '/api/Account/GetAllSanaieeia';
  static const String getAllReports = '/api/Report/GetAllReports';

  // Token refresh endpoint (kept for ApiHelper refresh flow).
  // If your backend uses a different path, update this.
  static const String refresh = '/refresh_token';
}


