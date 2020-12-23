import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDropDownWidget extends StatefulWidget {
  String dropdownValue = '100';

  @override
  _MyDropDownWidgetState createState() => _MyDropDownWidgetState();
}

class _MyDropDownWidgetState extends State<MyDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          widget.dropdownValue = newValue;
        });
      },
      items: <String>['50', '100', '200', '300', '400', '600', '800', '1000']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 24),
          ),
        );
      }).toList(),
    );
  }
}
