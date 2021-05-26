import 'dart:convert';

import 'package:auth_flutter_django/models/json_parsing.dart';
import 'package:http/http.dart' as http;

class StudentApi {
  final jwt;
  final cId;
  final dateStr;
  StudentApi(this.jwt, this.cId, [this.dateStr]);

  Future<dynamic> getAttendanceData() async {
    print(jwt);
    final headers = {
      'Authorization': 'Bearer ${jwt['access']}',
      'Content-Type': 'application/json'
    };
    print(cId);
    final response = await http
        .post('http://10.0.2.2:8000/api/attendance/${cId}/', headers: headers, body: jsonEncode({'date': dateStr}));
    if(response.statusCode >= 400 && response.statusCode < 500) {
      return '404';
    } else if(response.statusCode >= 500) {
      return '500';
    }

    return parseAttendanceObject(response.body);
  }

  Future<dynamic> getStudentData() async {
    print(jwt);
    final headers = {
      'Authorization': 'Bearer ${jwt['access']}',
      'Content-Type': 'application/json'
    };
    final response = await http
        .get('http://10.0.2.2:8000/api/students/cid/${cId}', headers: headers);
    if(response.statusCode >= 400 && response.statusCode < 500) {
      return '404';
    } else if(response.statusCode >= 500) {
      return '500';
    }
    return parseStudentObject(response.body);
  }

  Future<dynamic> getCSVreport(String fromDate, String toDate) async {
    print(jwt);
    final headers = {
      'Authorization': 'Bearer ${jwt['access']}',
      'Content-Type': 'application/json'
    };
    final response = await http
        .get('http://10.0.2.2:8000/api/reports/${cId}/$fromDate+$toDate', headers: headers);
    if(response.statusCode >= 400 && response.statusCode < 500) {
      return '404';
    } else if(response.statusCode >= 500) {
      return '500';
    }
    return response;
  }
}
