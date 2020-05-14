import 'package:flutter/rendering.dart';

class Space {
  int id;
  String name;
  int idUser;

  Space(this.id, this.name, this.idUser);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'idUser': idUser,
    };
    return map;
  }

  Space.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    idUser = map['idUser'];
  }

  @override
  String toString() {
    return 'Space{id: $id, name: $name, idUser: $idUser}';
  }
}
