import 'package:crud_firebase/Services/bloc/notifications_bloc.dart';
import 'package:crud_firebase/Services/local_notifications/local_notifications.dart';
import 'package:crud_firebase/pages/add_name_page.dart';
import 'package:crud_firebase/pages/edit_name_page.dart';
import 'package:crud_firebase/pages/home_page.dart';
import 'package:crud_firebase/pages/login.dart';
import 'package:crud_firebase/pages/sign_up.dart';
import 'package:crud_firebase/preferences/pref_usuarios.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesUser.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await LocalNotification.initializeLocalNotifications();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationsBloc(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final prefs = PreferencesUser();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: prefs.ultimaPagina,
      routes: {
        'Login': (context) => const LoginPage(),
        '/home': (context) => const Home(),
        '/add': (context) => const AddNamePage(),
        '/edit': (context) => const EditNamePage(),
        '/signUp': (context) => const SignUp(),
      },
    );
  }
}
