import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'User.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
  static const String TABLE = 'user';
  static const String DB_NAME = "suivideuzy";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $EMAIL TEXT, $PASSWORD TEXT");
  }

  Future<User> save(User user) async {
    var dbClient = await db;
    user.id = await dbClient.insert(TABLE, user.toMap());
    return user;
  }

  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query(TABLE, columns: [ID, EMAIL, PASSWORD]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<User> users = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMap(maps[i]));
      }
    }
    return users;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    var dbClient = await db;
    return await dbClient
        .update(TABLE, user.toMap(), where: '$ID = ?', whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
