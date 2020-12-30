import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Future<List<String>> futurePref;
  final Function onTap;

  const CustomDrawer({
    Key key,
    this.futurePref,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<List<String>>(
        future: futurePref,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildList(snapshot.data)
              : Text("Chargement...");
        },
      ),
    );
  }

  Widget _buildList(List<String> values) {
    return Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blueAccent,
            Colors.blue[100],
          ])),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(50.0),
                  elevation: 10.0,
                  color: Colors.blueAccent,
                  child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Image.asset(
                        'assets/images/app/logo.png',
                        width: 90,
                        height: 90,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    'Parties enregistrées',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(values[index]),
                onTap: () {
                  onTap(values[index]);
                  Navigator.pop(context);
                },
              );
            },
            itemCount: values.length,
          ),
        )
      ],
    );
  }
}
