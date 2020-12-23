import 'package:flutter/material.dart';

class Tools {

  static Future<bool> showAlertDialog(BuildContext context, String title,
      String content, Function onNo, Function onYes) async {
// set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Annuler"),
      onPressed: () {
        if (onNo != null) {
          onNo();
        }
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuer"),
      onPressed: () {
        if (onYes != null) {
          onYes();
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        ) ??
        false;
  }

  static Future<bool> showAlertDialogWithOneButton(BuildContext context, String title,
      String content, Function onOk) async {
// set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        if (onOk != null) {
          onOk();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
      ],
    );
    // show the dialog
    return showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        ) ??
        false;
  }
}
