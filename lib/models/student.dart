class Student {
  final int rollNo;
  final String name;
  final int cId;
  Student({this.rollNo, this.name, this.cId});

  factory Student.fromJson(Map<String, dynamic> jsonParsed) {
    if(jsonParsed == null) return null;
    return Student(
      name: jsonParsed['name'],
      cId: jsonParsed['cId'],
      rollNo: jsonParsed['rollNo']
    );
  }


}