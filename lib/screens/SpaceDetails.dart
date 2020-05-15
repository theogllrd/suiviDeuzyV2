import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivideuzy/database/Indicator.dart';
import 'package:suivideuzy/database/Space.dart';

class SpaceDetails extends StatefulWidget {
  // pour recuperer le space courant depuis le home
  final Space currentSpace;
  SpaceDetails({Key key, this.currentSpace}) : super(key: key);

  @override
  _SpaceDetailsState createState() => _SpaceDetailsState();
}

class _SpaceDetailsState extends State<SpaceDetails> {
  DateTime _dateTime = DateTime.now();
  bool editMode = false;
  final List<Indicator> _indicators = new List<Indicator>.generate(
      5, (i) => Indicator(i, 'Indicator $i', 'String', 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _indicators.length,
      itemBuilder: (context, index) {
        return _indicator(_indicators[index]);
      },
    );
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
    setState(() {
      _indicators.removeWhere(
        (item) => item.id == data.id,
      );
    });
  }

  _deleteSpace() {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Delete Space'),
              content: Text('Are you sure ?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => print('je dois faire le delete !!!!!!'),
                    child: Text('YES')),
                FlatButton(
                    onPressed: () => Navigator.pop(context), child: Text('NO'))
              ],
            ));
  }
}
