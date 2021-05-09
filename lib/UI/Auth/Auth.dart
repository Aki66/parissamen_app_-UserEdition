import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parissamin_app/UI/Home.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool ready = true;

  void signInWithGoogle() async {
    setState(() {
      ready = false;
    });
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.offAll(() => Home());
    } catch (ex) {
      setState(() {
        ready = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Align(

    //   alignment: Alignment.bottomCenter,

    // child: ConstrainedBox(

    //     constraints: BoxConstraints.tightFor(width: 300, height: 50),
    //     child: ready
    //         ? ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               primary: Colors.red[900],
    //               textStyle: new TextStyle(
    //                 fontSize: 20.0,
    //                 color: Colors.yellow,
    //               ),
    //             ),
    //             child: Text('G Sign in with Google'),
    //             onPressed: () {
    //               signInWithGoogle();
    //             },
    //           )
    //         : CircularProgressIndicator(),

    //   ),

    // );
    return Stack(
      children: [
        // Image(
        //   image: AssetImage("assets/images/mainlogo.png"),
        // ),
        Container(
          child: Image.asset('assets/images/Logo 01.png'),
          margin: const EdgeInsets.only(top: 70.0),
        ),

        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 300, height: 50),
            child: ready
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[900],
                      textStyle: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.yellow,
                      ),
                    ),
                    child: Text('G Sign in with Google'),
                    onPressed: () {
                      signInWithGoogle();
                    },
                  )
                : CircularProgressIndicator(),
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
      ],
    );
  }
}
