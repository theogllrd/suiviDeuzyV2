import 'package:flutter/material.dart';
import 'package:suivideuzy/screens/SpaceDetails.dart';

import 'newSpace.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return newSpace();
                }),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                child: Text(
                  'Bienvenue sur mon applicaBienvenue sur mon applicaBienvenue sur mon applicaBienvenue sur mon applica',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                margin: EdgeInsets.only(
                    top: 15.0, left: 15.0, bottom: 15.0, right: 15.0),
                color: Colors.black26,
              ),
              RaisedButton(
                child: Text(
                  'clic ici',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                color: Colors.blueGrey,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return SpaceDetails();
                  }));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
