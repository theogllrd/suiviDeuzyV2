import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivideuzy/database/Indicator.dart';
import 'package:suivideuzy/database/db_helper.dart';

class editIndicator extends StatefulWidget {
  final Indicator currentIndicator;
  const editIndicator({Key key, this.currentIndicator}) : super(key: key);

  @override
  _editIndicatorState createState() => _editIndicatorState();
}

class _editIndicatorState extends State<editIndicator> {
  // cle du scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // controlleur pour quand on edit le name du space
  final controllerIndicatorName = TextEditingController();

  // pour acceder a la bdd
  var dbHelper;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: TextField(
          controller: controllerIndicatorName,
          onChanged: (content) {
            widget.currentIndicator.name = controllerIndicatorName.text;
            print('on changed');
          },
          obscureText: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.currentIndicator.name,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Text(
              'Indicator type : ',
            ),
            DropdownButton<String>(
              value: widget.currentIndicator.type,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              onChanged: (String newValue) {
                setState(() {
                  widget.currentIndicator.type = newValue;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('save');
          // j'update le name
          dbHelper.updateIndicator(Indicator(
              widget.currentIndicator.id,
              widget.currentIndicator.name,
              widget.currentIndicator.type,
              widget.currentIndicator.idSpace));
          //widget.currentIndicator.name = controllerIndicatorName.text;
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }
}
