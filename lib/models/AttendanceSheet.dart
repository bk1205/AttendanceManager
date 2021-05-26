class Attendance {
  final int id;
  final String studentName;
  final String attendanceDate;
  String status;
  Attendance({this.id, this.studentName, this.attendanceDate, this.status});

  factory Attendance.fromJson(Map<String, dynamic> jsonParsed) {
    print(jsonParsed);
    if(jsonParsed == null) return null;
    return Attendance(
        id: jsonParsed['id'],
        studentName: jsonParsed['student_name'],
        attendanceDate: jsonParsed['attendance_date'],
        status: jsonParsed['status']
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'attendance_date': attendanceDate
    };
  }


}