import 'dart:convert';

import 'package:auth_flutter_django/Networking/get_api.dart';
import 'package:auth_flutter_django/Networking/auth.dart';
import 'package:auth_flutter_django/components/dialog_box.dart';
import 'package:auth_flutter_django/models/student.dart';
import 'package:auth_flutter_django/models/json_parsing.dart';
import 'package:auth_flutter_django/screens/Login/login_screen.dart';
import 'package:auth_flutter_django/token_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class StudentList extends StatefulWidget {
  final Map<String, dynamic> tokens;
  final Map<String, dynamic> payload;
  final int cId;
  StudentList(this.tokens, this.payload, this.cId);

//  factory StudentList.fromBase64(String jwt) => StudentList(
//      jwt,
//      json.decode(
//        utf8.decode(
//          base64.decode(
//            base64.normalize(jwt.split(".")[1]),
//          ),
//        ),
//      ));

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Student> _students;

  Future<String> getData(BuildContext context) async {
    var response =
        await StudentApi(widget.tokens, widget.cId).getStudentData();
    if (response == 'Failed') {
      int count = 0;
      showAlertDialogWithTwoButtons(context, 'Session Expired!',
          'Do you want to extend your session?', 'No', 'Yes', () {
        Authentication().attemptLogout();
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      }, () async {
        var newAccessToken = await Authentication()
            .attemptRefreshToken(widget.tokens['refresh'], context);
        Provider.of<TokenProvider>(context, listen: false).accessSet(newAccessToken);
        return Navigator.popUntil(context, (route) => (count++ == 2));
      });
    } else {
      setState(() {
        _students = response;
      });
    }
    return 'Success';
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData(context);
    });

  }

  @override
  Widget build(BuildContext context) {
    var tokens = Provider.of<TokenProvider>(context).tokenMap;
    print('student_list_screen: $tokens');
    final arg =
        ModalRoute.of(context).settings.arguments as List<int>;
    print(arg);
    return Scaffold(
        appBar: AppBar(
          title: Text('Class ${arg[0]}'),
        ),
        body: ListView.builder(
            itemCount: _students != null ? _students.length : 0,
            itemBuilder: _buildItem));
  }

  Widget _buildItem(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            new BoxShadow(color: Colors.white, spreadRadius: 1),
          ],
          border: Border(
              bottom: BorderSide(width: 2, color: Colors.blueGrey))),
      child: ExpansionTile(
        key: Key(_students[index].rollNo.toString()),
        childrenPadding: EdgeInsets.all(5),
        title: Text(
          _students[index].name,
          style: TextStyle(fontSize: 20, color: Colors.indigoAccent),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '${_students[index].rollNo}',
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
              Text(
                '${_students[index].cId}',
                style: TextStyle(
                    fontSize: 16, color: Colors.purpleAccent),
              )
            ],
          )
        ],
      ),
    );
  }
}
