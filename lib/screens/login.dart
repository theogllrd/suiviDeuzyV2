import 'package:flutter/material.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Please login'),
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
                    labelText: 'Email',
                  ),
                  onSaved: (input) => _email = input,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                        onPressed: _submitLogin,
                        child: Text('Sign in'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: _submitLogin,
                        child: Text('Log in'),
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

  void _submitLogin() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(_email);
      //print(_password);
      if (_email == "theo" && _password == "theo") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return Home();
          }),
        );
      } else {
        final snackBar = SnackBar(
          content: Text(
            'Wrong email / password',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }
}
