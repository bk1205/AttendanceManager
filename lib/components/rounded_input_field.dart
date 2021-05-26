import 'package:auth_flutter_django/components/text_field_container.dart';
import 'package:auth_flutter_django/constants.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {

  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
            icon: Icon(icon, color: kPrimaryColor,),
            hintText: hintText,
            border: InputBorder.none
        ),
      ),
    );
  }
}