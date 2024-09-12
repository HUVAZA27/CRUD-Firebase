import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPeople() async {
  List people = [];

  CollectionReference collectionReferencePeople = db.collection('people');
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  for (var doc in queryPeople.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final person = {
      "name": data['name'],
      "uid": doc.id,
    };

    people.add(person);
  }
  Future.delayed(const Duration(seconds: 5));
  return people;
}

Future<void> addPeople(String name) async {
  await db.collection("people").add({"name": name});
}

Future<void> updatePeople(String uid, String newName) async {
  await db.collection("people").doc(uid).set({"name": newName});
}

Future<void> deletePeople(String uid) async {
  await db.collection("people").doc(uid).delete();
}

Future singIn(String email, String password) async {
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
}
