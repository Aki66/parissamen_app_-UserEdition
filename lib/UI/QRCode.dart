import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'Auth/Auth.dart';

class QRCode extends StatefulWidget {
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  bool ready = false;

  var user;

  FirebaseAuth fAuth = FirebaseAuth.instance;
  FirebaseFirestore fStore = FirebaseFirestore.instance;

  void getUserData() async {
    await fStore
        .collection('Users')
        .doc(fAuth.currentUser.email)
        .get()
        .then((value) {
      user = {
        'Name': value['Name'],
        'Contact': value['Contact'],
        'NIC': value['NIC'],
        'Address': value['Address'],
        'Time': DateTime.now()
      };
      setState(() {
        ready = true;
      });
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ready
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF4446AD),
              title: Text('පරිස්සමෙන්'),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF4446AD),
                    textStyle: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.yellow,
                    ),
                  ),
                  onPressed: () {
                    Get.defaultDialog(
                        radius: 4,
                        title: 'Sign out',
                        content: Text('Are you sure?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await GoogleSignIn().signOut();
                              await FirebaseAuth.instance.signOut();
                              Get.offAll(() => Auth());
                            },
                            child: Text(
                              'Sign out',
                              style: GoogleFonts.inter(color: Colors.red),
                            ),
                          )
                        ]);
                  },
                  child: Text(
                    'Sign out',
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                )
              ],
            ),
            body: Center(
              child: Container(
                width: Get.width * 0.9,
                height: Get.width * 0.9,
                child: QrImage(
                  data: user.toString(),
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
