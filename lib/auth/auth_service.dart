import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  //sigin with email and password
  Future<AuthResponse> SignInWithEmailAndPassword(
      String email, String password) async {
    return await _supabaseClient.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  //signup with email and passord
  Future<AuthResponse> SignUpWithEmailAndPass(
      String email, String password) async {
    return await _supabaseClient.auth.signUp(
      password: password,
      email: email,
    );
  }

  //sign out
  Future<void> SignOut() async {
    return await _supabaseClient.auth.signOut();
  }

  //get user email
  String? getUserEmail() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
