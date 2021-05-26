import 'student.dart';
import 'dart:convert';

Map<String, dynamic> parseJWT(String jwt) {
  final Map<String, dynamic> parsedJWT = jsonDecode(jwt);
  return parsedJWT;
}
