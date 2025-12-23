import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userName;
  String? _userRole;
  String? _accessToken;
  
  static const String baseUrl = 'http://wqms.bwssb.gov.in/api';

  bool get isAuthenticated => _isAuthenticated;
  String? get userName => _userName;
  String? get userRole => _userRole;
  String? get accessToken => _accessToken;
  String? get token => _accessToken;

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userName = prefs.getString('userName');
    _userRole = prefs.getString('userRole');
    _accessToken = prefs.getString('accessToken');
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      // Prepare form data
      final data = {
        'username': username.isNotEmpty ? username : 'public',
        'password': password.isNotEmpty ? password : 'dw\$83v\$!D*z2WvAC',
        'grant_type': 'password'
      };

      // Convert to form body
      List<String> formBody = [];
      data.forEach((key, value) {
        String encodedKey = Uri.encodeComponent(key);
        String encodedValue = Uri.encodeComponent(value);
        formBody.add('$encodedKey=$encodedValue');
      });
      String formBodyString = formBody.join('&');

      // Make API call
      final response = await http.post(
        Uri.parse('$baseUrl/Useraccess'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
        },
        body: formBodyString,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (kDebugMode) {
          print('Login API Response: $responseData');
        }
        
        // Extract token and user info from response
        if (responseData['access_token'] != null) {
          _isAuthenticated = true;
          _userName = responseData['UserName'] ?? (username.isNotEmpty ? username : 'public');
          _userRole = responseData['RoleId'] == '3' ? 'Public User' : 'Field Officer';
          _accessToken = responseData['access_token'];
          
          if (kDebugMode) {
            print('Setting authenticated state: $_isAuthenticated');
            print('User: $_userName, Role: $_userRole');
          }
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isAuthenticated', true);
          await prefs.setString('userName', _userName!);
          await prefs.setString('userRole', _userRole!);
          await prefs.setString('accessToken', _accessToken!);
          
          // Store additional user info
          if (responseData['Email'] != null) {
            await prefs.setString('userEmail', responseData['Email']);
          }
          if (responseData['UserId'] != null) {
            await prefs.setString('userId', responseData['UserId']);
          }
          
          notifyListeners();
          return true;
        }
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return false;
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userName = null;
    _userRole = null;
    _accessToken = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }
}