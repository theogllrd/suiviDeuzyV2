import 'package:flutter/material.dart';
import 'package:suivideuzy/database/Indicator.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create a new Space',
        ),
      ),
      body: Column(
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
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _indicators.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                            title: Center(child: Text(_indicators[index].name)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              tooltip: 'Delete',
                              onPressed: () {},
                            )),
                      );
                    },
                  ),
                ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('je dois save l\'espace');
          // Add your onPressed code here!
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
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
