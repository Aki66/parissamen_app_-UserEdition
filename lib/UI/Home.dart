import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parissamin_app/Themes/TextEditingTheme.dart';
import 'package:parissamin_app/UI/Auth/Auth.dart';
import 'package:parissamin_app/UI/QRCode.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth fAuth = FirebaseAuth.instance;
  FirebaseFirestore fStore = FirebaseFirestore.instance;

  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController nic = TextEditingController();
  TextEditingController address = TextEditingController();

  bool ready = false;
  bool _validate = false;

  void checkIfNew() async {
    await fStore
        .collection('Users')
        .doc(fAuth.currentUser.email)
        .get()
        .then((value) {
      print(value.exists.toString());
      if (value.exists) {
        Get.offAll(() => QRCode());
      } else {
        setState(() {
          ready = true;
        });
      }
    });
  }

  void register() async {
    setState(() {
      ready = false;
    });
    await fStore.collection('Users').doc(fAuth.currentUser.email).set({
      'Name': name.text,
      'Contact': contact.text,
      'NIC': nic.text,
      'Address': address.text,
      'Time': DateTime.now()
    }).then((value) {
      Get.offAll(() => QRCode());
    });
  }

  final _text = TextEditingController();

  // @override
  // void dispose() {
  //   _text.dispose();
  //   super.dispose();
  // }

// validation testing

  // bool validateTextField(String userInput) {
  //   if (userInput.isEmpty) {
  //     setState(() {
  //       _validate = true;
  //     });
  //     return false;
  //   }
  //   setState(() {
  //     _validate = false;
  //   });
  //   return true;
  // }

  @override
  void initState() {
    checkIfNew();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ready
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Color(0xFF4446AD),
              // sbackgroundColor: Colors.purple[400],
              title: Text('Register'),
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
                          FlatButton(
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
            body: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            decoration: mainInputs(
                              'Name',
                            ),
                            controller: name,
                            // errorText : _validate ? 'value cannot be Empty': null,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextField(
                            maxLength: 10,
                            decoration: mainInputs('Contact Number'),
                            keyboardType: TextInputType.phone,
                            controller: contact,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextField(
                            decoration: mainInputs('NIC Number'),
                            controller: nic,
                            cursorColor: Colors.black,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextField(
                            minLines: 3,
                            maxLines: 3,
                            decoration: mainInputs('Address'),
                            controller: address,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: Get.width,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF2B2D7C),
                          textStyle: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.yellow,
                          ),
                        ),
                        onPressed: () {
                          // setState(() {
                          //   _text.text.isEmpty
                          //       ? _validate = true
                          //       : _validate = false;
                          // });
                          register();
                        },
                        child: Text('Register'),
                      ),
                    )
                  ],
                )))
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
