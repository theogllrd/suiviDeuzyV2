import 'package:flutter/material.dart';
import 'package:suivideuzy/database/Space.dart';
import 'package:suivideuzy/database/User.dart';
import 'package:suivideuzy/database/db_helper.dart';
import 'package:suivideuzy/screens/SpaceDetails.dart';

import 'newSpace.dart';

class Home extends StatefulWidget {
  // pour recuperer le user courant depuis la page de login
  final User user;
  Home({Key key, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // cle du scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //final List<Space> _spaces =
  //  new List<Space>.generate(20, (i) => Space(i, 'Space $i', 1));

  Future<List<Space>> spaces;

// pour acceder a la bdd
  var dbHelper;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();

    spaces = dbHelper.getSpaces(widget.user.id);
    // ici on peut insert tout un tas de trucs dans la bdd
    print('coucou initstate !!!!!!!!!!!!!!!!!!!! idUser = ' +
        widget.user.id.toString());
  }

  // call au retour de la page newSpace
  void refreshList() {
    spaces = dbHelper.getSpaces(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Bienvenue ${widget.user.email}'),
      ),
      body: _showSpaces(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Create a new space');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => newSpace(userId: widget.user.id),
            ),
          ).then((onValue) => refreshList());
        },
        child: Icon(Icons.add_box),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  _showSpaces() {
    refreshList(); // un peu degeu mais pour refresh la liste quand je supprimer un espace
    return FutureBuilder<List<Space>>(
        future: spaces,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _space(snapshot.data[index]);
              },
            );
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text('Pas d\'espaces existants');
          }
          return CircularProgressIndicator();
        });
  }

  Widget _space(Space space) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title:
            Text(space != null ? space.name : 'Erreur sur la lecteur du titre'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpaceDetails(currentSpace: space),
            ),
          );
        },
      ),
    );
  }
}
