import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivideuzy/database/Indicator.dart';
import 'package:suivideuzy/database/Value.dart';
import 'package:suivideuzy/database/db_helper.dart';
import 'package:suivideuzy/screens/lineGraph.dart';

class editIndicator extends StatefulWidget {
  final Indicator currentIndicator;
  final String currentValue;
  final int idValue;
  final String valueDate;

  const editIndicator(
      {Key key,
      this.currentIndicator,
      this.currentValue,
      this.idValue,
      this.valueDate})
      : super(key: key);

  @override
  _editIndicatorState createState() => _editIndicatorState();
}

class _editIndicatorState extends State<editIndicator> {
  // cle du scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // controlleur pour quand on edit le name du space
  final controllerIndicatorName = TextEditingController();
  final controllerDataValue = TextEditingController();

  String dataValue;
  bool isValueChanged = false;

  bool chart = true;
  final dataTEST = [
    new TimeSeriesSales(new DateTime(2020, 6, 2), 2),
    new TimeSeriesSales(new DateTime(2020, 6, 3), 3),
    new TimeSeriesSales(new DateTime(2020, 6, 4), 1),
    new TimeSeriesSales(new DateTime(2020, 6, 5), 3),
  ];

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
          child: Column(
            children: <Widget>[
              Row(
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
              TextField(
                controller: controllerDataValue,
                onChanged: (String newValue) {
                  setState(() {
                    dataValue = newValue;
                    isValueChanged = true;
                  });
                },
                obscureText: false,
                decoration: InputDecoration(
                  labelText: widget.currentValue,
                ),
              ),
              Container(
                  child:
                      chart == true && widget.currentIndicator.type == 'Integer'
                          ? Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: SimpleTimeSeriesChart.withSampleData(
                                      dataTEST)))
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text("Pas de graphique à afficher"))),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // j'update le name
          dbHelper.updateIndicator(Indicator(
              widget.currentIndicator.id,
              widget.currentIndicator.name,
              widget.currentIndicator.type,
              widget.currentIndicator.idSpace));
          //widget.currentIndicator.name = controllerIndicatorName.text;

          widget.idValue != null
              ? dbHelper.updateValue(Value(
                  widget.idValue,
                  isValueChanged ? dataValue : widget.currentValue,
                  widget.currentIndicator.id,
                  widget.valueDate))
              : dbHelper.insertValue(Value(
                  null,
                  isValueChanged ? dataValue : widget.currentValue,
                  widget.currentIndicator.id,
                  widget.valueDate));
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }
}
