import 'package:auth_flutter_django/models/AttendanceSheet.dart';
import 'package:auth_flutter_django/models/json_parsing.dart';
import 'package:auth_flutter_django/models/student.dart';
import 'package:http/http.dart' as http;

class AttendanceApi {
  final jwt;
  final cId;
  AttendanceApi(this.jwt, this.cId);

  Future<int> updateAttendanceData(List<Attendance> jsonAttendanceSheet) async {
    print(jwt);
    final headers = {
      'Authorization': 'Bearer ${jwt['access']}',
      'Content-Type': 'application/json'
    };
    String jsonBody = convertToJson(jsonAttendanceSheet);
    print(jsonBody);
    final response = await http
        .patch('http://10.0.2.2:8000/api/attendance/update/${cId}/', headers: headers, body: jsonBody);
    return response.statusCode;
  }
}
