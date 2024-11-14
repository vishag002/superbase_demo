import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Get the current user's ID
  String? getUserId() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;
    return user?.id; // Return the user's unique ID (UUID)
  }

  // SignIn with email and password
  Future<AuthResponse> SignInWithEmailAndPassword(
      String email, String password) async {
    return await _supabaseClient.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  // SignUp with email and password
  Future<AuthResponse> SignUpWithEmailAndPass(
      String email, String password) async {
    return await _supabaseClient.auth.signUp(
      password: password,
      email: email,
    );
  }

  // Sign out
  Future<void> SignOut() async {
    return await _supabaseClient.auth.signOut();
  }

  // Get the current user's email
  String? getUserEmail() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
