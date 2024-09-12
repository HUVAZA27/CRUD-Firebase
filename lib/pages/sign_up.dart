import 'package:crud_firebase/Services/firebase_auth_implementation/auth_google.dart';
import 'package:crud_firebase/Services/firebase_auth_implementation/firebase_auth_.services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isSigninUp = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Sign Up'),
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                height: 15,
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
                height: 15,
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Colors.deepPurple.withOpacity(0.2))),
                onPressed: () {
                  print(_emailController.text);
                  print(_passwordController.text);
                  _singUp();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: isSigninUp
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Sign Up'),
                ),
              ),
              const SizedBox(
                height: 20,
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

  void _singUp() async {
    setState(() {
      isSigninUp = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.singUpWithEmailAndPassword(email, password);

    setState(() {
      isSigninUp = false;
    });
    if (user != null) {
      print("User is successfuly created");
      setState(() {
        Navigator.pushNamed(context, "/home");
      });
    } else {
      print("Some error happend");
    }
  }
}
