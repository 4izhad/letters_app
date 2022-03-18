import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letter_app/screens/auth_screen.dart';
import 'package:letter_app/screens/message.dart';

import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then(((value) {
    runApp(const MyApp());
  }));
}

class MyApp extends StatelessWidget {
  const MyApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          // AuthScreen(),
          StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapShot) {
          if (userSnapShot.hasData) {
            final _user = FirebaseAuth.instance.currentUser;
            if(_user != null){
            if (_user.emailVerified) {
              return MessageScreen();
            }}

            return AuthScreen();
          }
          return AuthScreen();
        },
      ),
      onGenerateRoute: (route) => onGenerateRoute(route),
    );
  }
}

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(builder: (_) => AuthScreen());
    case MessageScreen.routeName:
      return MaterialPageRoute(builder: (_) => MessageScreen());
  }
}
