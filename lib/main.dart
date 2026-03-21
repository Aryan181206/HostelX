import 'package:amber_hackathon/api/user_sheet_api.dart';
import 'package:amber_hackathon/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth/auth.dart';
import 'firebase_options.dart';
import 'package:amber_hackathon/home/homewrapper.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await UserSheetsApi.init() ;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginScreen(),
    );
  }
}