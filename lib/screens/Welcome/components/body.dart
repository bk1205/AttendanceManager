import 'package:auth_flutter_django/components/auth_button.dart';
import 'package:auth_flutter_django/constants.dart';
import 'package:auth_flutter_django/screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "WELCOME TO ATTENDANCE MONITOR",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(
              height: size.height * 0.08,
            ),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.35,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            RoundedButton(
              color: kPrimaryColor,
              buttonText: "LOGIN",
              textColor: Colors.white,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
//            RoundedButton(
//              color: kPrimaryLightColor,
//              buttonText: "SIGNUP",
//              textColor: Colors.black,
//              onClick: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) {
//                      return SignupScreen();
//                    },
//                  ),
//                );
//              },
//            )
          ],
        ),
      ),
    );
  }
}
