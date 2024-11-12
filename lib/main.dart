import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_project/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//supabase setup
  await Supabase.initialize(
    url: "https://rfbjgefremekgljqhjmd.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJmYmpnZWZyZW1la2dsanFoam1kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE0MzE5MzMsImV4cCI6MjA0NzAwNzkzM30.yV6sRM1IIKvSOcD-52O7l2yhHHlB-Q0Mb2tPYUTm_Bg",
  );
//runapp
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
