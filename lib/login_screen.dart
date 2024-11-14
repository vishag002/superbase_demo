import 'package:flutter/material.dart';
import 'package:supabase_project/auth/auth_service.dart';
import 'package:supabase_project/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //login
  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      await _authService.SignInWithEmailAndPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoginScreen"),
      ),
      body: ListView(
        children: [
          TextField(
            controller: emailController,
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
          ),
          ElevatedButton(onPressed: login, child: Text("login")),
          Center(
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ));
                  },
                  child: Text("Dont have an account ? sign up")))
        ],
      ),
    );
  }
}
