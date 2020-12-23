import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:find_your_leo/Tools.dart';
import 'package:find_your_leo/constants.dart';

import 'MyDropDownWidget.dart';
import 'MyIconButtonWidget.dart';

// ignore: must_be_immutable
class MyCardWidget extends StatefulWidget {
  final Function onDelete;
  final int index;
  int levelId;

  MyCardWidget({
    Key key,
    @required this.onDelete,
    @required this.index,
    @required this.levelId,
  }) : super(key: key);

  @override
  _MyCardWidgetState createState() => _MyCardWidgetState();
}

class _MyCardWidgetState extends State<MyCardWidget> {
  final picker = ImagePicker();
  File _image;
  int dropDownValue = 100;

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0,
        clipBehavior: Clip.antiAlias,
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nombres d\'images: ',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(width: 10),
                MyDropDownWidget(),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: deviceHeight / 1.5,
                  width: deviceWidth,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: Card(
                    child: _image == null
                        ? Center(
                            child: RaisedButton(
                              onPressed: getImage,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blue)),
                              child: Text(
                                'Ajouter une image',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          )
                        : Image.file(_image, fit: BoxFit.cover),
                    clipBehavior: Clip.antiAlias,
                  ),
                ),
                _image != null
                    ? Positioned(
                        top: 35,
                        right: 0,
                        child: MyIconButtonWidget(
                          icon: Icons.clear,
                          function: () {
                            setState(() {
                              _image = null;
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
                        'Le niveau ${widget.index + 1} sera supprimé.',
                        () => widget.onDelete(widget.index));
                  },
                ),
                Text(
                  'Level ${widget.levelId}',
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
