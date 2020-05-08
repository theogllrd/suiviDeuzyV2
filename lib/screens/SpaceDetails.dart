import 'package:flutter/material.dart';

class SpaceDetails extends StatefulWidget {
  final int value;
  SpaceDetails({Key key, this.value}) : super(key: key);

  @override
  _SpaceDetailsState createState() => _SpaceDetailsState();
}

class _SpaceDetailsState extends State<SpaceDetails> {
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dateTime == null
            ? "Space ${widget.value} - Today"
            : "Space ${widget.value} - $_dateTime"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Calendar',
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                firstDate: DateTime(2000),
                lastDate: DateTime(2050),
              ).then((date) {
                setState(() {
                  _dateTime = date;
                });
              });
            },
          )
        ],
      ),
    );
  }
}
