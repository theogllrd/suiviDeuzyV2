import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivideuzy/database/Indicator.dart';
import 'package:suivideuzy/database/Space.dart';
import 'package:suivideuzy/database/db_helper.dart';
import 'package:suivideuzy/screens/home.dart';

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

  DateTime _dateTime = DateTime.now();
  bool editMode = false;

  //final List<Indicator> _indicators = new List<Indicator>.generate(
  // 5, (i) => Indicator(i, 'Indicator $i', 'String', 1));

  Future<List<Indicator>> indicators;

  // pour acceder a la bdd
  var dbHelper;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();

    indicators = dbHelper.getIndicators(widget.currentSpace.id);
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
        title: Text(_dateTime == null
            ? "${widget.currentSpace.name}"
            : "${widget.currentSpace.name} - $_dateTime"),
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
              : {
                  print('je save'),
                };
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
      title: Text(indicator.name),
      trailing: editMode
          ? IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              tooltip: 'delete indicator',
              onPressed: () {
                setState(() {
                  _deleteIndicator(indicator);
                });
              },
            )
          : null,
      onTap: () {
        print(indicator.name + ' clicked');
      },
    );
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
