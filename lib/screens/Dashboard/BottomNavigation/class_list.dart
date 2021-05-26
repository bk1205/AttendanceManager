import 'package:auth_flutter_django/screens/Dashboard/BottomNavigation/attendance_list_screen.dart';
import 'package:auth_flutter_django/screens/Dashboard/BottomNavigation/student_list_screen.dart';
import 'package:auth_flutter_django/token_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassList extends StatefulWidget {
  final Map<String, dynamic> payload;
  final int bottomTabIndex;

  ClassList(this.payload, this.bottomTabIndex);
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  DateTime selectedDate = DateTime.now();

  Future<DateTime> datePicker(BuildContext context, int index) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 7),
        lastDate: DateTime(2021, 7));
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
    return pickedDate;
  }

  void classTapHandler(BuildContext context, int index) {
    var tokens =
        Provider.of<TokenProvider>(context, listen: false).tokenMap;
    print('classlist: $tokens');
    if (widget.bottomTabIndex == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  StudentList(tokens, widget.payload, index + 1),
              settings: RouteSettings(
                  arguments: [index + 1, widget.bottomTabIndex])));
    } else {
      datePicker(context, index).then((date) {
        if(date == null) {
          return;
        }
        final String strDate =
            DateFormat('yyyy-MM-dd').format(selectedDate);
        print(strDate);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AttendanceSheet(tokens, index + 1, strDate),
            settings: RouteSettings(
                arguments: [index + 1, widget.bottomTabIndex]),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.blueGrey, offset: Offset(1, 3))
              ],
              borderRadius: BorderRadius.circular(10),
              color: widget.bottomTabIndex == 0
                  ? Color(0xFF16c79a)
                  : Color(0xFF14274e)),
          child: FlatButton(
            onPressed: () => classTapHandler(context, index),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                    fontSize: 62,
                    color: widget.bottomTabIndex == 0
                        ? Colors.indigoAccent
                        : Colors.greenAccent),
              ),
            ),
          ),
        );
      },
      itemCount: 12,
    );
  }
}
