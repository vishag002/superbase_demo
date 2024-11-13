import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_project/HomeScreen.dart';
import 'package:supabase_project/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //listen to the state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,
      //build page accourding to the state changes
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //...loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        //check if there is a current valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
