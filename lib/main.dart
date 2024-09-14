import 'package:chat_with_notif/screen/auth_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App ',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor:
              const Color.fromARGB(255, 255, 193, 7), // Warna kuning terang
          brightness: Brightness.light, // Menetapkan tema cerah
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

