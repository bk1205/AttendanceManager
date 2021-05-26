import 'AttendanceSheet.dart';
import 'student.dart';
import 'dart:convert';

List<Student> parseStudentObject(String jsonStr) {
  print(jsonStr);
  final List parsedList = jsonDecode(jsonStr);
  List<Student> studentList = parsedList.map((val) => Student.fromJson(val)).toList();
  return studentList;
}
List<Attendance> parseAttendanceObject(String jsonStr) {
  print(jsonStr);
  final List parsedList = jsonDecode(jsonStr);
  print(parsedList);
  List<Attendance> attendanceList = parsedList.map((val) => Attendance.fromJson(val)).toList();
  return attendanceList;
}

String convertToJson(List<Attendance> att) {
  List<Map<String, dynamic>> jsonData = att.map((a) => a.toMap()).toList();
  return jsonEncode(jsonData);
}
