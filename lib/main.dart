import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'Pages/homepage.dart';
import 'Pages/loginpage.dart';
import 'Theme/mode.dart';
import 'Theme/themeprovider.dart';
import 'Pages/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Android-only Firebase initialization
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeProvider>().themeData,
      home:  const AuthWrapper(),
      routes: {
        '/home': (context) => Homepage(),
        '/auth': (context) => Authentication(),
        '/settings': (context) => const Modechange(),
      },
    );
  }
}
