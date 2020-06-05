import 'package:flutter/material.dart';
import 'package:suivideuzy/database/db_helper.dart';
import 'dart:io';
import 'home.dart';
import 'package:suivideuzy/database/User.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<List<User>> users;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password;

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    // ici on peut insert tout un tas de trucs dans la bdd
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Veuillez vous identifier'),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Identifiant',
                  ),
                  onSaved: (input) => _email = input,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                  ),
                  onSaved: (input) => _password = input,
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: _signIn,
                        child: Text('Inscription'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: _submitLogin,
                        child: Text('Connexion'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      // on get la liste des users
      users = dbHelper.getUsers();
      // var pour savoir si le user est deja present en bdd
      bool exist = false;
      // on parcours la liste des users
      await users.then((user) {
        for (var u in user) {
          // si un mail dans la liste est egal au mail dans le form, on passe exist a true
          if (u.email == _email) {
            exist = true;
            break;
          }
        }
      });
      // si on a trouvé le mail dans la bdd on affiche la snackbar
      if (exist == true) {
        var snackBar = SnackBar(
          content: Text(
            'Utilisateur déjà existant',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        return;
      } else if (exist == false) {
        // sinon on crée l'utilisateur
        User u = User(null, _email, _password);
        await dbHelper.insert('user', u);
        var snackBar = SnackBar(
          content: Text(
            'Bienvenue',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.greenAccent,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  void _submitLogin() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      // je get la liste des users
      bool found = false;
      users = dbHelper.getUsers();
      await users.then((user) {
        for (var u in user) {
          print(u.toString());
          // si un mail dans la liste est egal au mail dans le form, on passe exist a true
          if (u.email == _email && u.password == _password) {
            found = true;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return Home(user: u);
              }),
            );
          }
        }
      });
      if (found == false) {
        var snackBar = SnackBar(
          content: Text(
            'Mauvais utilisateur/mot de passe',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }
}
