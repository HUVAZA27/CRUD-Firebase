import 'package:crud_firebase/Services/bloc/notifications_bloc.dart';
import 'package:crud_firebase/Services/firebase_service.dart';
import 'package:crud_firebase/preferences/pref_usuarios.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  static const String routename = '/home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    context.read<NotificationsBloc>().requestPermission();
    var prefs = PreferencesUser();
    print('TOKENn: ' + prefs.token);
    prefs.ultimaPagina = '/home';
    prefs.ultimouid = _auth!.uid;
    print(_auth.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase - CRUD'),
        automaticallyImplyLeading: false,
        elevation: 5,
        shadowColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, 'Login');
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: FutureBuilder(
          future: getPeople(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    onDismissed: (direction) async {
                      await deletePeople(snapshot.data?[index]["uid"]);
                      snapshot.data?.removeAt(index);
                    },
                    confirmDismiss: (direction) async {
                      bool result = false;

                      result = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  'Estas seguro de querer elimnar a ${snapshot.data?[index]["name"]}?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      return Navigator.pop(context, false);
                                    },
                                    child: const Text('Cancelar')),
                                TextButton(
                                    onPressed: () {
                                      return Navigator.pop(context, true);
                                    },
                                    child: const Text('Si, estoy seguro'))
                              ],
                            );
                          });
                      print('confirm dismismiss');
                      return result;
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    key: Key(snapshot.data?[index]["uid"]),
                    child: ListTile(
                      title: Text(snapshot.data?[index]["name"]),
                      onTap: () async {
                        await Navigator.pushNamed(context, "/edit", arguments: {
                          "name": snapshot.data?[index]["name"],
                          "uid": snapshot.data?[index]["uid"],
                        });
                        setState(() {});
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
          print('sigo ejecutando el home');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
