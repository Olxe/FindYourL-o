import 'package:flutter/material.dart';

class MyIconButtonWidget extends StatelessWidget {
  final Function function;
  final IconData icon;

  const MyIconButtonWidget({
    Key key,
    this.function,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: function,
      elevation: 2.0,
      fillColor: Colors.lightBlue,
      child: Icon(
        icon,
        size: 20.0,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }
}
