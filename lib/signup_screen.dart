import 'package:flutter/material.dart';
import 'package:supabase_project/auth/auth_service.dart';
import 'package:supabase_project/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  //signUpFun
  void signUP() async {
    final _email = emailController.text;
    final _password = passwordController.text;
    final _confirmPass = confirmPassController.text;

//check if password matches
    if (_password != _confirmPass) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("password does not match ")));
      return;
    }
    //attempt sign up
    try {
      await _authService.SignUpWithEmailAndPass(_email, _password);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up Screen")),
      body: ListView(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: "Enter Email"),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(hintText: "Enter Password"),
          ),
          TextField(
            controller: confirmPassController,
            decoration: InputDecoration(hintText: "Re-Enter password "),
          ),
          ElevatedButton(
              onPressed: () {
                signUP();
              },
              child: Text("Sign UP")),
          Center(
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                  child: Text("Already have an account? login here"))),
        ],
      ),
    );
  }
}
