import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:suivideuzy/database/Indicator.dart';
import 'package:suivideuzy/database/Space.dart';
import 'package:suivideuzy/database/Value.dart';

import 'User.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
  static const String NAME = 'name';
  static const String SURNAME = 'surname';

  static const String IDUSER = 'idUser';

  static const String TYPE = 'type';
  static const String IDSPACE = 'idSpace';

  static const String VALUE = 'value';
  static const String IDINDICATOR = 'idIndicator';
  static const String CREATEDDATE = 'createdDate';

  // V2 = implementation des espaces
  static const String DB_NAME = "suivideuzyV7";

  Future<Database> get db async {
    if (_db != null) {
      //print('renvoie de la bdd existante');
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    //print('initialisation de la base de données');
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    print('insertion de la table user');
    await db.execute(
        "CREATE TABLE user ($ID INTEGER PRIMARY KEY, $EMAIL TEXT, $PASSWORD TEXT, $NAME TEXT, $SURNAME TEXT)");
    print('insertion de la table space');
    await db.execute(
        "CREATE TABLE space ($ID INTEGER PRIMARY KEY, $NAME TEXT, $IDUSER INTEGER)");
    print('insertion de la table indicator');
    await db.execute(
        "CREATE TABLE indicator ($ID INTEGER PRIMARY KEY, $NAME TEXT, $TYPE TEXT, $IDSPACE INTEGER)");
    print('insertion de la table value');
    await db.execute(
        "CREATE TABLE value ($ID INTEGER PRIMARY KEY, $VALUE TEXT, $IDINDICATOR INTEGER, $CREATEDDATE TEXT)");
  }

  Future<User> insert(String table, User user) async {
    print('insertion d\'un user en bdd');
    var dbClient = await db;
    user.id = await dbClient.insert(
      table,
      user.toMap(),
    );
    return user;
  }

  Future<List<User>> getUsers() async {
    print('recuperation de la liste des users');
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query('user', columns: [ID, EMAIL, PASSWORD]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<User> users = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMap(maps[i]));
      }
    }
    return users;
  }

  Future<int> delete(String table, int id) async {
    print('suppresion d\'un utilisateur');
    var dbClient = await db;
    return await dbClient.delete(table, where: '$ID = ?', whereArgs: [id]);
  }

  Future<Space> insertSpace(Space space) async {
    print('insertion d\'un espace en bdd');
    var dbClient = await db;
    space.id = await dbClient.insert(
      'space',
      space.toMap(),
    );
    return space;
  }

  Future<List<Space>> getSpaces(int userId) async {
    //print('recuperation de la liste des espaces');
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      'space',
      columns: [ID, NAME, IDUSER],
      where: '$IDUSER = ?',
      whereArgs: [userId],
    );
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Space> spaces = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        spaces.add(Space.fromMap(maps[i]));
      }
    }
    return spaces;
  }

  Future<int> deleteSpace(int id) async {
    //print('suppresion d\'un space');
    var dbClient = await db;
    return await dbClient.delete('space', where: '$ID = ?', whereArgs: [id]);
  }

  Future<Indicator> insertIndicator(Indicator indicator) async {
    print('insertion d\'un indicateur en bdd');
    var dbClient = await db;
    indicator.id = await dbClient.insert(
      'indicator',
      indicator.toMap(),
    );
    return indicator;
  }

  Future<List<Indicator>> getIndicators(int idSpace) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('indicator',
        columns: [ID, NAME, TYPE, IDSPACE],
        where: '$IDSPACE = ?',
        whereArgs: [idSpace]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Indicator> indicators = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        indicators.add(Indicator.fromMap(maps[i]));
      }
    }
    return indicators;
  }

  Future<int> deleteIndicator(int id) async {
    print('suppresion d\'un indicator');
    var dbClient = await db;
    return await dbClient
        .delete('indicator', where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateSpace(Space space) async {
    var dbClient = await db;
    return await dbClient.update('space', space.toMap(),
        where: '$ID = ?', whereArgs: [space.id]);
  }

  Future<int> updateIndicator(Indicator indicator) async {
    var dbClient = await db;
    return await dbClient.update('indicator', indicator.toMap(),
        where: '$ID = ?', whereArgs: [indicator.id]);
  }

  Future<Value> insertValue(Value value) async {
    print('insertion d\'une valeur en bdd   ' + value.createdDate);
    var dbClient = await db;
    value.id = await dbClient.insert(
      'value',
      value.toMap(),
    );
    return value;
  }

  Future<Value> getValue(int idIndicator, String date) async {
    print('en bdd jai reuc la date ' + date);
    //print('recuperation dune value');
    var dbClient = await db;
    List<Map> maps = await dbClient.query('value',
        //columns: [ID, NAME, TYPE, IDSPACE],
        where: '$IDINDICATOR = ? AND $CREATEDDATE = ?',
        whereArgs: [idIndicator, date]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Value> value = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        value.add(Value.fromMap(maps[i]));
      }
      //print('je return une value §!!!!!!!!!!!!!!!!!!!');
      return value[0];
    }
    //print('je return nul !!!!!!!!!!!!!!!!!!!!!');
    return null;
  }

  Future<int> deleteValue(int id) async {
    print('suppresion d\'un value');
    var dbClient = await db;
    return await dbClient.delete('value', where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateValue(Value value) async {
    print('update de value en bdd    ' + value.createdDate);
    var dbClient = await db;
    return await dbClient.update('value', value.toMap(),
        where: '$ID = ?', whereArgs: [value.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
