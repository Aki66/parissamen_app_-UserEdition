import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parissamin_app/UI/Auth/Auth.dart';
import 'package:parissamin_app/UI/Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Parissamin());
}

class Parissamin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //   theme: ThemeData(
      //     primarySwatch: Colors.blue,

      //   ),
      //   home: FirebaseAuth.instance.currentUser == null ? Auth() : Home(),
      // );
      home: Scaffold(
        backgroundColor: Color(0xFF4446AD),
        body: FirebaseAuth.instance.currentUser == null ? Auth() : Home(),
      ),
    );
  }
}
