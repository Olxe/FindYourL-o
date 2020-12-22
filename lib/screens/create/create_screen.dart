import 'dart:io';

import 'package:find_your_leo/constants.dart';
import 'package:find_your_leo/data/model/level_model.dart';
import 'package:find_your_leo/screens/create/widgets/MyIconButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'widgets/MyDropDownWidget.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  File _image;
  final picker = ImagePicker();
  int dropDownValue = 100;
  List<Level> levels;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Création d\'un nouveau salon'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyDropDownWidget(),
          Stack(
            children: [
              Container(
                height: deviceHeight / 1.5,
                width: deviceWidth,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
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
                  elevation: 10.0,
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                onPressed: () {},
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 40,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  showAlertDialog(context);
                },
                child: Text(
                  'Terminer',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              RaisedButton(
                onPressed: () {},
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> showAlertDialog(BuildContext context) async {
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

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Créer la partie ?"),
      content: Text(
          "Générer de code d'accès à la partie ?"),
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
