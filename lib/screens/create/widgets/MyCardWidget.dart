import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:find_your_leo/Tools.dart';
import 'package:find_your_leo/constants.dart';
import 'package:find_your_leo/data/model/level_model.dart';

import 'MyDropDownWidget.dart';
import 'MyIconButtonWidget.dart';

// ignore: must_be_immutable
class MyCardWidget extends StatefulWidget {
  final Function onDelete;
  final LevelModel level;

  MyCardWidget({
    Key key,
    @required this.onDelete,
    @required this.level,
  }) : super(key: key);

  @override
  _MyCardWidgetState createState() => _MyCardWidgetState();
}

class _MyCardWidgetState extends State<MyCardWidget> {
  final picker = ImagePicker();
  Image _image;
  // File _image;

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        final bytes = File(pickedFile.path).readAsBytesSync();
        setImage(base64Encode(bytes));
      } else {
        print('No image selected');
      }
    });
  }

  void setImage(String base64Encode) {
    widget.level.base64Image = base64Encode;
    if (widget.level.base64Image != null) {
      _image = Image.memory(base64Decode(widget.level.base64Image));
    } else {
      _image = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nombres d\'images: ',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(width: 10),
                MyDropDownWidget(dropdownValue: widget.level.amount),
              ],
            ),
            Stack(
              children: [
                _image == null
                    ? RaisedButton(
                        onPressed: getImage,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue)),
                        child: Text(
                          'Ajouter une image',
                          style: TextStyle(fontSize: 24),
                        ),
                      )
                    : Card(child: _image),
                _image != null
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: MyIconButtonWidget(
                          icon: Icons.clear,
                          function: () {
                            setState(() {
                              setImage(null);
                            });
                          },
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: () {
                    Tools.showAlertDialog(
                        context,
                        'Supprimer un niveau ?',
                        'Le niveau ${widget.level.id} sera supprimé.',
                        () => widget.onDelete(widget.level.id - 1));
                  },
                ),
                Text(
                  'Level ${widget.level.id}',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
