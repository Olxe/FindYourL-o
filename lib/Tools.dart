import 'package:flutter/material.dart';

class Tools {
  static Future<void> showAlertDialog(BuildContext context, String title,
      String content, Function onYes) async {
// set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Annuler"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuer"),
      onPressed: () {
        Navigator.of(context).pop();
        onYes();
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
