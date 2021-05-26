import 'package:auth_flutter_django/Networking/auth.dart';
import 'package:auth_flutter_django/Networking/get_api.dart';
import 'package:auth_flutter_django/Networking/post_api.dart';
import 'package:auth_flutter_django/components/dialog_box.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:auth_flutter_django/models/AttendanceSheet.dart';
import 'package:auth_flutter_django/screens/Login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:auth_flutter_django/token_provider.dart';

class AttendanceSheet extends StatefulWidget {
  final Map<String, dynamic> tokens;
  final int cId;
  final String dateStr;
  AttendanceSheet(this.tokens, this.cId, this.dateStr);

//  factory AttendanceSheet.fromBase64(String jwt) => AttendanceSheet(
//      jwt,
//      json.decode(
//        utf8.decode(
//          base64.decode(
//            base64.normalize(jwt.split(".")[1]),
//          ),
//        ),
//      ));

  @override
  _AttendanceSheetState createState() => _AttendanceSheetState();
}

class _AttendanceSheetState extends State<AttendanceSheet> {
  final SlidableController slidableController = SlidableController();
  List<Attendance> _attendList;

  Future<dynamic> sessionDialog(int cnt) {
    return showAlertDialogWithTwoButtons(context, 'Session expired!',
        'Do you want to extend your session?', 'No', 'Yes', () {
      Authentication().attemptLogout();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    }, () async {
      int count = 0;
      var newAccessToken = await Authentication()
          .attemptRefreshToken(widget.tokens['refresh'], context);
      Provider.of<TokenProvider>(context, listen: false)
          .accessSet(newAccessToken);
      return Navigator.popUntil(context, (route) => (count++ == cnt));
    });
  }

  Future<String> getData() async {
    var response =
        await StudentApi(widget.tokens, widget.cId, widget.dateStr)
            .getAttendanceData();
    if (response == '404') {
      sessionDialog(2);
    } else if (response == '500') {
      showAlertDialogWithOneAction(
          context,
          'Internal Server Error',
          'An error occurred from server side, Please try again later! ',
          () => Navigator.pop(context));
    } else {
      setState(() {
        _attendList = response;
      });
    }
    return 'Success';
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var tokens = Provider.of<TokenProvider>(context).tokens;
    final arg =
        ModalRoute.of(context).settings.arguments as List<int>;
    print(arg);
    return Scaffold(
      appBar: AppBar(
        title: Text('Class ${widget.cId}'),
        actions: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                  icon: Icon(Icons.cloud_done, color: Colors.white),
                  onPressed: () async {
                    var resStatus =
                        await AttendanceApi(tokens, widget.cId)
                            .updateAttendanceData(_attendList);
                    if (resStatus == 200) {
                      Fluttertoast.showToast(
                          msg:
                              "Attendance Sheet has been successfully updated!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black);
                    }
                    if (resStatus == 401) {
                      print('401 at updation');
                      print('beforeRefresh: $tokens');
                      sessionDialog(1);
                      print('afterRefresh: $tokens');
                    }
                  }))
        ],
      ),
      body: ListView.builder(
        itemBuilder: _buildItem,
        itemCount: _attendList != null ? _attendList.length : 0,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
//    print(att);
    return Slidable(
      key: Key(_attendList[index].id.toString()),
      actionPane: SlidableBehindActionPane(),
      controller: slidableController,
      actionExtentRatio: 0.2,
      closeOnScroll: true,
      actions: [
        IconSlideAction(
          caption: 'Present',
          color: Colors.greenAccent,
          icon: Icons.playlist_add_check,
          onTap: () {
            setState(() {
              _attendList[index].status = 'present';
            });
          },
        ),
        IconSlideAction(
          caption: 'Absent',
          color: Colors.red,
          icon: Icons.highlight_off,
          onTap: () {
            setState(() {
              _attendList[index].status = 'absent';
            });
          },
        )
      ],
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(color: Colors.white, spreadRadius: 1),
            ],
            border: Border(
                bottom:
                    BorderSide(width: 2, color: Colors.blueGrey))),
        child: GestureDetector(
          onLongPress: () {
            setState(() {
              _attendList[index].status = 'leave';
            });
          },
          child: ListTile(
            leading: Text(_attendList[index].id.toString()),
            key: Key(_attendList[index].studentName),
            title: Text(
              '${_attendList[index].studentName}',
              style: TextStyle(
                  fontSize: 20,
                  color: (_attendList[index].status == 'present')
                      ? Colors.indigoAccent
                      : (_attendList[index].status == 'absent')
                          ? Colors.red
                          : Colors.black),
            ),
            trailing: _attendList[index].status == 'leave'
                ? Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.5),
                            width: 5),
                        color: Colors.amber,
                        shape: BoxShape.circle),
                    child: Text(
                      'L',
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  )
                : SizedBox(
                    width: 1,
                  ),
          ),
        ),
      ),
    );
  }
}
