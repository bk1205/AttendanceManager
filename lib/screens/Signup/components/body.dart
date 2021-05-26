import 'package:auth_flutter_django/Networking/auth.dart';
import 'package:auth_flutter_django/components/already_have_an_account_check.dart';
import 'package:auth_flutter_django/components/auth_button.dart';
import 'package:auth_flutter_django/components/rounded_input_field.dart';
import 'package:auth_flutter_django/components/rounded_password_field.dart';
import 'package:auth_flutter_django/components/text_field_container.dart';
import 'package:auth_flutter_django/constants.dart';
import 'package:auth_flutter_django/screens/Login/login_screen.dart';
import 'package:auth_flutter_django/screens/Signup/components/social_icon.dart';
import 'file:///C:/Users/BHAVESH/AndroidStudioProjects/auth_flutter_django/lib/screens/Signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'background.dart';
import 'or_divider.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  String email;
  String password;


  void displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(title),
            content: Text(text),
          )
  );

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
            "SIGNUP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          SvgPicture.asset(
            "assets/icons/signup.svg",
            height: size.height * 0.35,
          ),
          RoundedInputField(
            hintText: "Your Email",
            icon: Icons.person,
            onChanged: (value) {
              email = value;
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              password = value;
            },
          ),
          RoundedButton(
            color: kPrimaryColor,
            buttonText: "SIGNUP",
            onClick: () async {
              if(email.length < 4)
                displayDialog(context, 'Invalid Username', 'The username should be at least 4 characters long');
              else if(password.length < 4)
                displayDialog(context, 'Invalid Password', 'The password should be at least 4 characters long');
              else {
                var res = Authentication().attemptSignup(email, password);
                if(res == 201)
                  displayDialog(context, "Success", "You are successfully registered with us. LogIn Now.");
                else if(res == 409)
                  displayDialog(context, "The username is already registered", "Please try to sign up with another username.");
                else 
                  displayDialog(context, "Error", "An unknown error occured.");
              }
            },
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          AlreadyHaveAnAccountCheck(
            login: false,
            onPress: () {
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
          OrDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialIcon(
                onPress: () {},
                iconSrc: "assets/icons/facebook.svg",
              ),
              SocialIcon(
                onPress: () {},
                iconSrc: "assets/icons/google-plus.svg",
              ),
              SocialIcon(
                onPress: () {},
                iconSrc: "assets/icons/twitter.svg",
              ),
            ],
          )
        ],
      ),
    ));
  }
}
