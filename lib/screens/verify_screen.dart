import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letter_app/screens/auth_screen.dart';
import 'package:letter_app/screens/message.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();

  final String email;

  VerifyScreen({
    this.email,
  });

  static const routeName = '/verify-screen';
}

class _VerifyScreenState extends State<VerifyScreen>
    with TickerProviderStateMixin {
  Timer timer;
  bool isVerified = false;
  final _auth = FirebaseAuth.instance;
  User user;
  int count = 0;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    () async {
      await user.sendEmailVerification();
    }();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      checkEmailVerification();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size _deviceSize = MediaQuery.of(context).size;

    Timer(const Duration(seconds: 60), () async {
      timer.cancel();
      await user.reload();
      if (!user.emailVerified) {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      }
    });

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Stack(
        children: [
          if (!isVerified)
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              // decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Center(child: CircularProgressIndicator()),
            ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: _deviceSize.height * 0.1,
              right: _deviceSize.height * 0.1,
              top: _deviceSize.height * 0.42,
            ),
            child: Text(
              !isVerified
                  ? 'We have sent you an email. Please verify it'
                  : "Verified Successfully !",
              style: const TextStyle(
                  color: Color.fromARGB(255, 50, 27, 255),
                  fontSize: 29,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkEmailVerification() async {
    user = _auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      // await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      //   'email': widget.email,
      // });

      setState(() {
        isVerified = true;
        Navigator.of(context).pushReplacementNamed(MessageScreen.routeName);
      });

      timer.cancel();
    }
  }
}
