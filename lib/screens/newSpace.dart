import 'package:flutter/material.dart';
import 'package:suivideuzy/database/Indicator.dart';
import 'package:suivideuzy/database/Space.dart';
import 'package:suivideuzy/database/db_helper.dart';

class newSpace extends StatefulWidget {
  @override
  _newSpaceState createState() => _newSpaceState();
}

class _newSpaceState extends State<newSpace> {
  final controllerSpaceName = TextEditingController();
  final controllerIndicatorName = TextEditingController();

  List<Indicator> _indicators = new List<Indicator>();

  String _spaceName, _indicatorName;
  String dropdownValue = 'String';

  // pour acceder a la bdd
  var dbHelper;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    // ici on peut insert tout un tas de trucs dans la bdd
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Create a new Space',
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 85,
              width: 400,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controllerSpaceName,
                    onChanged: (content) {
                      _spaceName = controllerSpaceName.text;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Space name',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: 400,
                child: Card(
                  child: showIndicatorsList(),
                ),
              ),
            ),
            Container(
              height: 200,
              width: 400,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controllerIndicatorName,
                        onChanged: (content) {
                          _indicatorName = controllerIndicatorName.text;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Indicator Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Indicator type : ',
                          ),
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.keyboard_arrow_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>[
                              'String',
                              'Integer',
                              'Boolean',
                              'Image'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      onPressed: _validateIndicator,
                      child: Text('VALIDER INDICATEUR'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      /*Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: controllerSpaceName,
                onChanged: (content) {
                  _spaceName = controllerSpaceName.text;
                },
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Space name',
                ),
              ),
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                showIndicatorsList(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controllerIndicatorName,
                    onChanged: (content) {
                      _indicatorName = controllerIndicatorName.text;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Indicator Name',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Indicator type : ',
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['String', 'Integer', 'Boolean', 'Image']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: _validateIndicator,
                  child: Text('VALIDER INDICATEUR'),
                ),
              ],
            ),
          ),
        ],
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_spaceName == null) {
            return print('le spaceName est null');
          } else {
            print('du coup je save');
            Space space = Space(null, _spaceName, 1);
            Future<Space> spaceBdd = dbHelper.insertSpace(space);
            spaceBdd.then((onValue) {
              print('je viens de creer l\'espace id :' + onValue.id.toString());
              _indicators.forEach((indicator) => {
                    print('insertion dun indicator'),
                    dbHelper.insertIndicator(Indicator(
                        null, indicator.name, indicator.type, onValue.id))
                  });
            });
            Navigator.pop(context);
          }

          // Add your onPressed code here!
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }

  showIndicatorsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _indicators.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
              title: Center(child: Text(_indicators[index].name)),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                tooltip: 'Delete',
                onPressed: () {
                  _deleteIndicator(_indicators[index]);
                },
              )),
        );
      },
    );
  }

  _validateIndicator() {
    print('ajout de l\'indicateur dans la liste');
    Indicator indicator = new Indicator(2, _indicatorName, dropdownValue, 1);
    // setState pour indiquer a l'objet qu'il a changé
    setState(() {
      _indicators.add(indicator);
    });
    for (var indic in _indicators) {
      print(indic);
    }
  }

  _deleteIndicator(Indicator data) {
    setState(() {
      _indicators.removeWhere(
          (item) => item.name == data.name && item.type == data.type);
    });
  }

/*
  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: _addIndicator,
                        child: Text('Add indicator'),
                      ),
                    ),
                  ],
                ),*/
}
