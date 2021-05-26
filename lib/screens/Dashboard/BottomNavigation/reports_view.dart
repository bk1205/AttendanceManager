import 'dart:io';

import 'package:auth_flutter_django/Networking/auth.dart';
import 'package:auth_flutter_django/Networking/get_api.dart';
import 'package:auth_flutter_django/components/dialog_box.dart';
import 'package:auth_flutter_django/screens/Login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:auth_flutter_django/token_provider.dart';

class ReportView extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Map<String, dynamic> tokens;
  final int bottomTabIndex;
  ReportView(this.tokens, this.payload, this.bottomTabIndex);
  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  var _classes = [for (var i = 1; i <= 12; i++) i];
  var _currClass = 1;
  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();

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

  _getReport(BuildContext context) async {
    if (_selectedToDate.difference(_selectedFromDate).inDays < 0) {
      Fluttertoast.showToast(
          msg: "The Duration must not be negative",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black);
      return;
    }
    print(_currClass);
    String fromDateStr =
        DateFormat('yyyy-MM-dd').format(_selectedFromDate);
    String toDateStr =
        DateFormat('yyyy-MM-dd').format(_selectedToDate);
    var tokens =
        Provider.of<TokenProvider>(context, listen: false).tokenMap;
    var resp = await StudentApi(tokens, _currClass)
        .getCSVreport(fromDateStr, toDateStr);
    if (resp == '404') {
      print('UnAuthorized');
      sessionDialog(1);
      return;
    } else if (resp == '500') {
      sessionDialog(1);
      return;
    }
    Directory dir = await getExternalStorageDirectory();
    String tempPath = dir.path;
    File file = new File(
        '$tempPath/report_${DateTime.now().toIso8601String()}.csv');
    await file.writeAsBytes(resp.bodyBytes);
    Fluttertoast.showToast(
      msg: "File successfully saved to $dir",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
    );
    print(dir);
  }

  Future<String> datePicker(BuildContext context, int index) async {
    final DateTime dateTimeIndex =
        index == 1 ? _selectedToDate : _selectedFromDate;
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: dateTimeIndex,
        firstDate: DateTime(2020, 7),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != dateTimeIndex) {
      setState(() {
        index == 1
            ? _selectedToDate = pickedDate
            : _selectedFromDate = pickedDate;
      });
    }
    final String strDate =
        DateFormat('yyyy-MM-dd').format(_selectedFromDate);
    return strDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Text(
            'Select the class for which you want to download report :',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(
                top: 20, left: 25, right: 25, bottom: 25),
            child: CupertinoPicker(
              backgroundColor: Colors.white10,
              children:
                  _classes.map((e) => Text(e.toString())).toList(),
              onSelectedItemChanged: (value) {
                setState(() {
                  _currClass = value + 1;
                });
              },
              itemExtent: 32,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Column(
            children: [
              Text(
                'Select the duration for which you want to download report :',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              buildDateRow(context, 'From', 0, 31, 13),
              buildDateRow(context, 'To', 1, 0, 0)
            ],
          ),
        ),
        Center(
          child: RaisedButton(
            onPressed: () => _getReport(context),
            child: Text('Download Report'),
          ),
        )
      ],
    );
  }

  Row buildDateRow(BuildContext context, String text, int index,
      double sizeBoxWidth, double rightIconPadding) {
    DateTime dateIndex =
        index == 1 ? _selectedToDate : _selectedFromDate;
    String strDate = DateFormat('yyyy-MM-dd').format(dateIndex);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          '$text : ',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '${strDate}',
          style: TextStyle(
            fontSize: 17,
            color: Colors.teal,
          ),
        ),
        SizedBox(
          width: sizeBoxWidth,
        ),
        IconButton(
          padding: EdgeInsets.only(right: rightIconPadding),
          icon: Icon(
            Icons.date_range,
            color: Colors.green,
            size: 30,
          ),
          onPressed: () => datePicker(context, index),
        )
      ],
    );
  }
}
