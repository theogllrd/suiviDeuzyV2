import 'package:flutter/rendering.dart';

class User {
  int id;
  String email;
  String password;

  User(this.id, this.email, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    email = map['email'];
    password = map['password'];
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password}';
  }

  String getEmail() {
    return '$email';
  }
}
