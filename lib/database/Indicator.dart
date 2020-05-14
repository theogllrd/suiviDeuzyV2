import 'package:flutter/rendering.dart';

class Indicator {
  int id;
  String name;
  String type;
  int idSpace;

  Indicator(this.id, this.name, this.type, this.idSpace);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'idSpace': idSpace,
    };
    return map;
  }

  Indicator.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    type = map['type'];
    idSpace = map['idSpace'];
  }

  @override
  String toString() {
    return 'Indicator{id: $id, name: $name, type: $type, idSpace: $idSpace}';
  }
}
