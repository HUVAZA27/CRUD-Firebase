// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class User with ChangeNotifier {
//   String id;
//   String displayName;
//   String phrotoUrl;
//   String email;

//   User({
//     required this.id,
//     required this.displayName,
//     required this.phrotoUrl,
//     required this.email,
//   });

//   factory User.fromFirestore(DocumentSnapshot userDoc) {
//     Map userData = userDoc.data;
//     return User(
//         id: userDoc.documentoID,
//         displayName: userData['displayName'],
//         phrotoUrl: userData['phrotoUrl'],
//         email: userData['email']);
//   }
// }
