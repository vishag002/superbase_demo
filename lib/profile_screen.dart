import 'package:flutter/material.dart';
import 'package:supabase_project/auth/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();

  //logout
  void logOut() async {
    try {
      await _authService.SignOut();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final _userEmail = _authService.getUserEmail();
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Screen"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(_userEmail.toString()),
          ),
          Center(
            child: InkWell(
              onTap: logOut,
              child: Container(
                width: MediaQuery.of(context).size.width * .6,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
