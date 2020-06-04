import 'package:flutter/rendering.dart';

class Value {
  int id;
  String value;
  int idIndicator;
  String createdDate;

  Value(this.id, this.value, this.idIndicator, this.createdDate);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'value': value,
      'idIndicator': idIndicator,
      'createdDate': createdDate,
    };
    return map;
  }

  Value.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    value = map['value'];
    idIndicator = map['idIndicator'];
    createdDate = map['createdDate'];
  }

  @override
  String toString() {
    return 'Value{id: $id, value: $value, idIndicator: $idIndicator, createdDate: $createdDate}';
  }
}
