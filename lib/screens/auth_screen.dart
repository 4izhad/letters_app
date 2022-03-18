import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:letter_app/screens/message.dart';
import 'package:letter_app/screens/verify_screen.dart';
import '../widgets/auth/auth_form.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:gossips/screens/chat_screen.dart';

// import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth_screen";
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  String errorMessage = 'Please enter your credentials.';
  var _isLoading = false;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  void _createUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => VerifyScreen(
              email: email,
            ),
          ),
        );
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-in-use") {
        _signInUser(email,password, context);
      } else {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Please enter a valid email address..............";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests. Try again later.";
            break;
        }
        showSnackBar(context);
      }
    }
  }

  void _signInUser(
    String email,
     String password,
    BuildContext context,
  ) async {
    UserCredential authResult;
    // var acs = ActionCodeSettings(
    //     url: 'https://lettersapp.page.link/',
    //     handleCodeInApp: true,
    //     iOSBundleId: 'com.example.letter_app',
    //     androidPackageName: 'com.example.letter_app',
    //     androidInstallApp: true,
    //     androidMinimumVersion: '12');

    // await _auth.sendSignInLinkToEmail(
    //   email: email,
    //   actionCodeSettings: acs,
    // );

    // final PendingDynamicLinkData data =
    //     await FirebaseDynamicLinks.instance.getInitialLink();

    // if (_auth.isSignInWithEmailLink(data?.link.toString())) {
    //   _auth
    //       .signInWithEmailLink(email: email, emailLink: data?.link.toString())
    //       .then((value) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(
    //         builder: (ctx) => MessageScreen(),
    //       ),
    //     );
    //   });
    // }
     authResult = await _auth
              .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
              .then((_) async {
            final _user = FirebaseAuth.instance.currentUser;
            if (_user.emailVerified) {
              var doc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(_user.uid)
                  .get();
              if (!doc.exists) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(_user.uid)
                    .set({
                  'email': email,
                  'username': 'Arjun',
                  'avatarIndex': 0,
                });
              }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) =>MessageScreen(),
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.orange.shade50,
                  content:const  Text("Please verify the email."),
                  actions: [
                    OutlinedButton(
                      onPressed: () async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        _user.sendEmailVerification();
                        Navigator.of(context)
                            .pushReplacementNamed(AuthScreen.routeName);
                      },
                      child: const Text("Okay"),
                    ),
                  ],
                ),
              );
            }
            return null;
          });

  }

  void _saveAuhForm(
    String email,
    String password,
    BuildContext context,
  ) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        _createUser(email, password, context);
      } on FirebaseAuthException catch (error) {
        if (error.code == "user-not-found") {
          _createUser(email, password, context);
        } else {
          switch (error.code) {
            case "invalid-email":
              errorMessage = "Please enter a valid email address..............";
              break;

            case "too-many-requests":
              errorMessage = "Too many requests. Try again later.";
              break;
          }
          showSnackBar(context);
        }
      }
    } else {
      showSnackBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_saveAuhForm, _isLoading),
    );
  }
}
