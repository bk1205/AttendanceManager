import 'package:flutter/material.dart';
import 'main.dart';

class TokenProvider extends ChangeNotifier {
  Map<String, dynamic> tokenMap;

    Future<Map<String, dynamic>> setToken() async {
      var jwtAccess = await storage.read(key: 'jwtAccess');
      var jwtRefresh = await(storage.read(key: 'jwtRefresh'));
      tokenMap = {
        'access': jwtAccess,
        'refresh': jwtRefresh
      };
      print(tokenMap);
      return tokenMap;
    }

    void accessSet(String access) {
      tokenMap['access'] = access;
      notifyListeners();
    }
    Map<String, dynamic> get tokens => tokenMap;



}