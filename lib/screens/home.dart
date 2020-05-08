import 'package:flutter/material.dart';
import 'package:suivideuzy/screens/SpaceDetails.dart';

import 'newSpace.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var SpaceList = [1, 2, 3];

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
            children: [
              /*Card(
                child: Text(
                  'Space 1',
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
                margin: EdgeInsets.only(
                    top: 15.0, left: 15.0, bottom: 15.0, right: 15.0),
                color: Colors.black26,
                
              ),*/

              for (var number in SpaceList)
                SizedBox(
                  height: 100.0,
                  width: 500.0,
                  child: RaisedButton(
                    child: Text(
                      'Space $number',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                    color: Colors.blueGrey,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return SpaceDetails(value: number);
                      }));
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
