import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivideuzy/database/Indicator.dart';
import 'package:suivideuzy/database/Space.dart';
import 'package:suivideuzy/database/Value.dart';
import 'package:suivideuzy/database/db_helper.dart';
import 'package:suivideuzy/screens/editIndicator.dart';
import 'package:suivideuzy/screens/home.dart';
import 'package:suivideuzy/database/StructValues.dart';

class SpaceDetails extends StatefulWidget {
  // pour recuperer le space courant depuis le home
  final Space currentSpace;
  SpaceDetails({Key key, this.currentSpace}) : super(key: key);

  @override
  _SpaceDetailsState createState() => _SpaceDetailsState();
}

class _SpaceDetailsState extends State<SpaceDetails> {
  // cle du scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // controlleur pour quand on edit le name du space
  final controllerSpaceName = TextEditingController();
  String _spaceName;

  DateTime _dateTime = DateTime.now();
  bool editMode = false;

  //final List<Indicator> _indicators = new List<Indicator>.generate(
  // 5, (i) => Indicator(i, 'Indicator $i', 'String', 1));

  Future<List<Indicator>> indicators;
  List<dynamic> values = [];

  // pour acceder a la bdd
  var dbHelper;
  @override
  Future<void> initState() {
    super.initState();

    //values.add({"id": 1, "value": 'Coucou'});
    //values.add({"id": 2, "value": '32'});
    //print(values[1]["value"]);

    dbHelper = DBHelper();
    //dbHelper.insertValue(new Value(null, 'coucou', 6, 'today'));
    //dbHelper.insertValue(new Value(null, '92', 7, 'today'));
    //dbHelper.insertValue(new Value(null, 'false', 8, 'today'));

    dbHelper
        .getIndicators(widget.currentSpace.id)
        .then((indicators) => indicators.forEach((indicator) => {
              //print('id === ' + indicator.id.toString()),
              //indicators2.add(indicator),
              dbHelper.getValue(indicator.id).then((value) => {
                    /*value != null
                        ? values.add({"id": indicator.id, "value": value.value})
                        : print("pas de value pour l'indicateur :" +
                            indicator.name),*/
                    setState(() {
                      values.add({
                        "id": indicator.id.toString(),
                        "value": value.value
                      });
                    })

                    //print(values),
                  })
            }))
        .then(refreshList());
    //.then(print(values));
    // ici on peut insert tout un tas de trucs dans la bdd
  }

  void refreshList() {
    setState(() {
      indicators = dbHelper.getIndicators(widget.currentSpace.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: !editMode
            ? Text(_dateTime == null
                ? "${widget.currentSpace.name}"
                : "${widget.currentSpace.name} - $_dateTime")
            : TextField(
                controller: controllerSpaceName,
                onChanged: (content) {
                  widget.currentSpace.name = controllerSpaceName.text;
                },
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: widget.currentSpace.name,
                ),
              ),
        actions: <Widget>[
          !editMode
              ? IconButton(
                  icon: const Icon(Icons.calendar_today),
                  tooltip: 'Calendar',
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate:
                          _dateTime == null ? DateTime.now() : _dateTime,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
                    ).then((date) {
                      setState(() {
                        _dateTime = date;
                      });
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: 'delete space',
                  onPressed: () {
                    _deleteSpace();
                  },
                ),
        ],
      ),
      body: _showIndicators(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            editMode = !editMode;
          });
          editMode
              ? {
                  print('je passe en mode edit'),
                }
              : dbHelper.updateSpace(Space(widget.currentSpace.id,
                  widget.currentSpace.name, widget.currentSpace.idUser));
          //widget.currentSpace.name = controllerSpaceName.text;
        },
        child: Icon(editMode ? Icons.check : Icons.edit),
        backgroundColor: editMode ? Colors.green : Colors.blueAccent,
      ),
    );
  }

  Widget _showIndicators() {
    return FutureBuilder<List<Indicator>>(
        future: indicators,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _indicator(snapshot.data[index]);
              },
            );
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text('No data found');
          }
          return CircularProgressIndicator();
        });
  }

  Widget _indicator(Indicator indicator) {
    return ListTile(
      title: Text(indicator.name +
          '     |     ' +
          showValueForIndicator(indicator.id).toString()),
      trailing: editMode
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  tooltip: 'edit indicator',
                  onPressed: () {
                    setState(() {
                      print('edit indicator');
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: 'delete indicator',
                  onPressed: () {
                    setState(() {
                      _deleteIndicator(indicator);
                    });
                  },
                ),
              ],
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => editIndicator(currentIndicator: indicator),
          ),
        );
      },
    );
  }

  showValueForIndicator(int idIndicator) {
    String phrase = "";
    values.forEach((value) =>
        value["id"] == idIndicator.toString() ? phrase = value["value"] : null);

    phrase == "" ? phrase = "Pas de data" : null;
    return phrase;
  }

  _deleteIndicator(Indicator data) {
    dbHelper.deleteIndicator(data.id);
    refreshList();
  }

  _deleteSpace() {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Delete Space'),
              content: Text('Are you sure ?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => {
                          dbHelper.deleteSpace(widget.currentSpace.id),
                          Navigator.pop(context), // to close the popup
                          Navigator.pop(context), // to get back to Home()
                        },
                    child: Text('YES')),
                FlatButton(
                    onPressed: () => Navigator.pop(context), child: Text('NO'))
              ],
            ));
  }
}
