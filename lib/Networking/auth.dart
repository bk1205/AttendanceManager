import 'package:auth_flutter_django/main.dart';
import 'package:auth_flutter_django/models/jwt_parsing.dart';
import 'package:auth_flutter_django/screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Authentication {
  Future<dynamic> attemptLogin(String username, String password) async {
    print(username);
    print(password);
    try {
      var res = await http.post(
          'http://10.0.2.2:8000/gettoken/',
          body: {
            "username": username.trim(),
            "password": password.trim()
          }
      );
      return res;
    } catch(e) {
      return null;
    }
  }

  Future<int> attemptSignup(String username, String password) async {
    print(username);
    print(password);
    var res = await http.post(
        'http://10.0.2.2:8000/api/user/',
        body: {
          "username": username.trim(),
          "password": password.trim()
        }
    );
    return res.statusCode;
  }

  Future<dynamic> attemptRefreshToken(String refresh, BuildContext context) async {
    print(refresh);
    var res = await http.post(
        'http://10.0.2.2:8000/refreshtoken/',
        body: {
          "refresh": refresh,
        }
    );
    if(res.statusCode == 200) {
      var token = parseJWT(res.body);
      var newToken = token['access'];
      storage.write(key: 'jwtAccess', value: newToken);
      return newToken;

    }
    if(res.statusCode == 401) {
      Authentication().attemptLogout();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
    }
    return res.statusCode;

  }

  Future<void> attemptLogout() async {
    storage.deleteAll();

  }

}