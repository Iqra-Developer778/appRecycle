
import 'package:apprecycle/Admin/admin_redeem.dart';
import 'package:apprecycle/pages/ai_tips.dart';
import 'package:apprecycle/pages/bottomnav.dart';
import 'package:apprecycle/pages/login.dart';
import 'package:apprecycle/pages/points.dart';
import 'package:apprecycle/pages/upload_item.dart';
import 'package:flutter/material.dart';
import 'pages/onboarding.dart';
import 'pages/home.dart';
import 'admin/admin_approval.dart';
import 'pages/history.dart';


//firebase k liya git installl krna zaruri hai
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

      home: Onboarding(),

    );
  }
}
