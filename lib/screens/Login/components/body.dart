import 'package:auth_flutter_django/Networking/auth.dart';
import 'package:auth_flutter_django/components/already_have_an_account_check.dart';
import 'package:auth_flutter_django/components/auth_button.dart';
import 'package:auth_flutter_django/components/rounded_input_field.dart';
import 'package:auth_flutter_django/components/rounded_password_field.dart';
import 'package:auth_flutter_django/constants.dart';
import '../../Dashboard/dashboard.dart';
import 'package:auth_flutter_django/components/dialog_box.dart';
import 'package:auth_flutter_django/main.dart';
import 'package:auth_flutter_django/models/jwt_parsing.dart';
import 'package:auth_flutter_django/screens/Signup/signup_screen.dart';
import 'package:auth_flutter_django/token_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String email;
  String password;
  bool isClicked = false;
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  void displayLoadingDialog(context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.03,
          ),
          Text(
            "LOGIN",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          SvgPicture.asset(
            "assets/icons/login.svg",
            height: size.height * 0.35,
          ),
          RoundedInputField(
            hintText: "Your Email",
            icon: Icons.person,
            onChanged: (value) {
              email = value;
            },
            controller: _controllerEmail,
          ),
          RoundedPasswordField(
            onChanged: (value) {
              password = value;
            },
            controller: _controllerPassword,
          ),
          RoundedButton(
            color: kPrimaryColor,
            buttonText: "LOGIN",
            onClick: () async {
              _controllerEmail.clear();
              _controllerPassword.clear();
              displayLoadingDialog(context);
              var response = await Authentication()
                  .attemptLogin(email, password);
              if (response == null) {
                Navigator.pop(context);
                showAlertDialogWithOneAction(
                  context,
                  "An error occured",
                  "Connection timed out, Please try later!",
                    () => Navigator.pop(context),
                );
              }
              if (response!= null && response.statusCode == 200) {
                var jwt = response.body;
                var parsedJWT = parseJWT(jwt);
                storage.write(key: "jwtAccess", value: parsedJWT['access']);
                storage.write(key: "jwtRefresh", value: parsedJWT['refresh']);
                Provider.of<TokenProvider>(context, listen: false).setToken();
                int count = 0;
                Navigator.popUntil(
                    context, (route) => (count++ == 2));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dashboard.fromBase64(
                            parsedJWT)));
              }
              if (response != null && response.statusCode != 200) {
                Navigator.pop(context);
                showAlertDialogWithOneAction(
                  context,
                  "An error occured",
                  "Invalid username or password, Please try again!",
                    () => Navigator.pop(context)
                );
              }
            },
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
//          AlreadyHaveAnAccountCheck(
//            login: true,
//            onPress: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) {
//                    return SignupScreen();
//                  },
//                ),
//              );
//            },
//          )
        ],
      ),
    ));
  }
}
