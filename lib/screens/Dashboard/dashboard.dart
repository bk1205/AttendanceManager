import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auth_flutter_django/Networking/auth.dart';
import 'package:auth_flutter_django/components/dialog_box.dart';
import 'package:auth_flutter_django/screens/Dashboard/BottomNavigation/class_list.dart';
import 'package:auth_flutter_django/screens/Dashboard/BottomNavigation/reports_view.dart';
import 'package:auth_flutter_django/screens/Login/login_screen.dart';



class Dashboard extends StatefulWidget {
  final Map<String, dynamic> tokens;
  final Map<String, dynamic> payload;

  Dashboard(this.tokens, this.payload);

  factory Dashboard.fromBase64(Map<String, dynamic> tokens) =>
      Dashboard(
          tokens,
          json.decode(
            utf8.decode(
              base64.decode(
                base64.normalize(tokens['access'].split(".")[1]),
              ),
            ),
          ));

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String appBarTitle() {
    if (_selectedIndex == 0)
      return 'Students';
    else if (_selectedIndex == 1)
      return 'Attendance';
    else
      return 'Reports';
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_selectedIndex) {
      case 0:
        child = ClassList(widget.payload, 0);
        break;
      case 1:
        child = ClassList(widget.payload, 1);
        break;
      case 2:
        child = ReportView(widget.tokens, widget.payload, 2);
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle()),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.white,
              onPressed: () {
                showAlertDialogWithTwoButtons(
                    context, 'Log out ?', 'Are you sure you want to log out ?', 'Cancel', 'Log out', () => {
                  Navigator.pop(context)
                }, () {
                  Authentication().attemptLogout();
                  int count = 0;
                  Navigator.popUntil(
                      context, (route) => (count++ == 2));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                });
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text(
                'Students',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fingerprint),
              title: Text(
                'Attendance',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.report),
                title: Text(
                  'Reports',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
        body: child);
  }
}
