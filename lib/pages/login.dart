import 'package:crud_firebase/Services/bloc/notifications_bloc.dart';
import 'package:crud_firebase/Services/firebase_auth_implementation/auth_google.dart';
import 'package:crud_firebase/Services/firebase_auth_implementation/firebase_auth_.services.dart';
import 'package:crud_firebase/util/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  static const String routename = 'Login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<NotificationsBloc>().requestPermission();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.android_rounded,
                color: Colors.green,
                size: 130,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Hello Again",
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                ),
              ),
              const Text(
                "Welcome back, you've been missed!",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12)),
                      border: InputBorder.none,
                      hintText: "Email",
                      fillColor: Colors.grey[200],
                      filled: true),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12)),
                      border: InputBorder.none,
                      hintText: "Password",
                      fillColor: Colors.grey[200],
                      filled: true),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: TextButton(
                          onPressed: () {
                            // singIn(_emailController.text,
                            //     _passwordController.text);
                            print(_emailController.text);
                            print(_passwordController.text);
                            _singIn();
                            showSnackBar(
                                context, 'Estamos mostrando un mensaje');
                          },
                          child: isSigning
                              ? CircularProgressIndicator(
                                  color: Colors.cyan,
                                )
                              : Text('Sing In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signUp');
                    },
                    child: const Text(
                      ' Register now',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  )
                ],
              ),
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple.withOpacity(0.2)),
                onPressed: () async {
                  try {
                    final user = await AuthUser().loginGoogle();
                    if (user != null) {
                      Navigator.popAndPushNamed(context, '/home');
                    }
                  } on FirebaseAuthException catch (error) {
                    print(error.message);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text(error.message ?? 'Ups... Algo salio mal')));
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())));
                  }
                },
                icon: const Icon(
                  Icons.login,
                  color: Colors.deepPurple,
                ),
                label: const Text(
                  'Continua con Google',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _singIn() async {
    setState(() {
      isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.singInWithEmailAndPassword(email, password);

    setState(() {
      isSigning = false;
    });

    if (user != null) {
      print("User is successfuly signedIn");
      setState(() {
        Navigator.pushNamed(context, "/home");
      });
    } else {
      print("Some error happend");
    }
  }
}
