import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _phone;
  String? _name;
  String? _role = 'user';
  bool _isAuthenticated = false;

  String? get userId => _userId;
  String? get phone => _phone;
  String? get name => _name;
  String? get role => _role;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String phone, String otp) async {
    // TODO: Implement OTP verification
    _userId = 'user_123';
    _phone = phone;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _userId = null;
    _phone = null;
    _name = null;
    _role = 'user';
    _isAuthenticated = false;
    notifyListeners();
  }
}
