import 'package:amber_hackathon/auth/auth.dart';
import 'package:amber_hackathon/home/homewrapper.dart';
import 'package:amber_hackathon/notice.dart';
import 'package:amber_hackathon/setting.dart';
import 'package:flutter/material.dart';

import 'complaints/new_complaints_bottom_sheet.dart';
import 'mess_menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeWrapper(),
    );
  }
}





