import 'dart:convert';

import 'package:auth_flutter_django/Networking/auth.dart';
import 'package:auth_flutter_django/constants.dart';
import 'package:auth_flutter_django/loading_screen.dart';
import 'package:auth_flutter_django/screens/Login/login_screen.dart';
import 'package:auth_flutter_django/screens/Signup/signup_screen.dart';
import 'package:auth_flutter_django/screens/Welcome/welcome_screen.dart';
import 'package:auth_flutter_django/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'screens/Dashboard/dashboard.dart';

final storage = FlutterSecureStorage();


void main() {
  runApp(ChangeNotifierProvider(create: (context) => TokenProvider(),child: MyApp()));
}

class MyApp extends StatelessWidget {

//  Future<Map<String, dynamic>> get jwtOrEmpty async {
//   Provider.of<TokenProvider>(context).tokenMap;
//    print('access: $jwtAccess' + " jwtOrEmpty Function main.dart");
//    print('refresh: $jwtRefresh' + " jwtOrEmpty Function main.dart");
//    if(jwtAccess == null ) return {};
//    return {
//      'access': jwtAccess,
//      'refresh': jwtRefresh
//    };
//  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: kPrimaryColor
      ),
      home: FutureBuilder(
        future: Provider.of<TokenProvider>(context).setToken(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if(!snapshot.hasData) return CircularProgressIndicator();
          if(snapshot.data['access'] != null && snapshot.data['refresh'] != null) {
            var tokens = snapshot.data;
            var jwt = tokens['access']?.split(".");
            if(jwt.length != 3) {
              print('jwt length error');
              return WelcomeScreen();
            } else {
              var payload = json.decode(utf8.decode(base64.decode(base64.normalize(jwt[1]))));
              if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                print('access token is valid and redirecting to Dashbopard ');
                return Dashboard(tokens, payload);
              } else {
                print('access token is timed out and redirecting to Dashboard ');
                Authentication().attemptRefreshToken(tokens['refresh'], context).then((token) {

                  print('access: $token');
                  print('hi');
                });
                return WelcomeScreen();
              }
            }
          } else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}

