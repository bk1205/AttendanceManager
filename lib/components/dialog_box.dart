import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> showAlertDialogWithTwoButtons(BuildContext context, String title, String instruction, String leftString, String rightString, Function leftAction, Function rightAction) {
  showDialog(
      barrierDismissible: false,
      context: context,
      child: CupertinoAlertDialog(
        title: Text(title),
        content: Text(instruction),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: leftAction,
            child: Text(leftString),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: rightAction,
            child: Text(rightString),
            textStyle: TextStyle(color: Colors.red),
          )
        ],
      ));
}

Future<dynamic> showAlertDialogWithOneAction(BuildContext context,
    String title, String text, Function actionHandler) {
  return showDialog(
    barrierDismissible: false,
      context: context,
      child: CupertinoAlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: actionHandler,
            child: Text('Ok'),
          )
        ],
      ));
}

