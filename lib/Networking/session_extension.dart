//import 'package:auth_flutter_django/components/dialog_box.dart';
//import 'package:auth_flutter_django/screens/Dashboard/BottomNavigation/attendance_list_screen.dart';
//import 'package:auth_flutter_django/screens/Login/login_screen.dart';
//import 'package:flutter/material.dart';
//
//import '../main.dart';
//import 'auth.dart';
//
//
//class SessionExtension extends StatefulWidget {
//  final Map<String, dynamic> tokens;
//  final int cId;
//  SessionExtension(this.tokens, this.cId);
//  @override
//  _SessionExtensionState createState() => _SessionExtensionState();
//}
//
//class _SessionExtensionState extends State<SessionExtension> {
//
//  Future<dynamic> get sessionExtendHandler async {
//    var newAccess = await Authentication().attemptRefreshToken(widget.tokens['refresh']);
//    print(newAccess);
//    print("old tokens: ${widget.tokens}");
//    return newAccess;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder(
//      future: sessionExtendHandler,
//      builder: (context, snapshot) {
//        if(!snapshot.hasData) {
//          return Center(child: CircularProgressIndicator(),);
//        }
//        if(snapshot.data != null) {
//          widget.tokens['access'] = snapshot.data;
//          print("newTokens: ${widget.tokens}");
//          Navigator.pop(context);
//          print(context);
//          Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceSheet(widget.tokens, widget.cId)));
//          return snapshot.data;
//        }
//        return snapshot.error;
//      },
//    );
//  }
//}
//
//
//
//
//String sessionExtension(BuildContext context, String refresh) {
//  int count = 0;
//  String accessToken;
//
//  showAlertDialogWithTwoButtons(context, 'Session Expired!',
//      'Do you want to extend your session?', 'No', 'Yes', () {
//    Authentication().attemptLogout();
//      Navigator.pushAndRemoveUntil(
//        context,
//        MaterialPageRoute(builder: (context) => LoginScreen()),
//        (route) => false);
//  }, () async {
//    var newAccess =
//        await Authentication().attemptRefreshToken(refresh);
//    Navigator.pop(context);
//    Navigator.pop(context);
//    accessToken = newAccess;
//    print(accessToken.runtimeType);
//  });
//  print(accessToken);
//  return accessToken;
//}
