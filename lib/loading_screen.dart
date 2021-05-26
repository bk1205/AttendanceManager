import 'dart:convert';
import 'dart:io';

import 'file:///C:/Users/BHAVESH/AndroidStudioProjects/auth_flutter_django/lib/screens/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;


class LoadingScreen extends StatefulWidget {
  final String email;
  final String password;
  LoadingScreen({this.email, this.password});
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  var response;

  @override
  void initState() {
    super.initState();
    fetchStudents(widget.email, widget.password);
  }

  void fetchStudents(String email, String password) async {

    String emailId = email.trim();
    String passwordFinal = password.trim();
    String encoded = base64.encode(utf8.encode("${emailId}:${passwordFinal}"));
    String decoded = utf8.decode(base64.decode(encoded));
    print(encoded);
    print(decoded);

    final headers = {
      'Authorization': 'Basic ${encoded}',
      'Content-Type': 'application/json'
    };
    final response = await http.get('http://10.0.2.2:8000/students/', headers: headers);
//    final responseJson = jsonDecode(response.body);
    print(response.body);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}




