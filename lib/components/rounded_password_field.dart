import 'package:auth_flutter_django/components/text_field_container.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const RoundedPasswordField({
    this.onChanged,
    Key key,
    this.controller
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool obscurePassword = true;
  IconData visibilityIcon = Icons.visibility_off;

  void toggleVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
      visibilityIcon = obscurePassword ? Icons.visibility_off : Icons.visibility;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(child: TextField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      obscureText: obscurePassword,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          icon: Icon(Icons.lock, color: kPrimaryColor,),
          border: InputBorder.none,
          hintText: "Password",
          suffixIcon: IconButton(icon: Icon(visibilityIcon, color: kPrimaryColor,), onPressed: toggleVisibility, )
      ),
    ));
  }
}