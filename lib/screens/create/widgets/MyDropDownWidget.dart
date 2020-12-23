import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDropDownWidget extends StatefulWidget {
  int dropdownValue;

  MyDropDownWidget({
    Key key,
    this.dropdownValue,
  }) : super(key: key);

  @override
  _MyDropDownWidgetState createState() => _MyDropDownWidgetState();
}

class _MyDropDownWidgetState extends State<MyDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: widget.dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (int newValue) {
        setState(() {
          widget.dropdownValue = newValue;
        });
      },
      items: <int>[50, 100, 200, 300, 400, 600, 800, 1000]
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 24),
          ),
        );
      }).toList(),
    );
  }
}
