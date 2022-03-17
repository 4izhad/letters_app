import 'dart:io';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    // File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  bool isLoading;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  // var _userPickedImage;

  // void _pickedImage(File image) {
  //   _userPickedImage = image;
  // }

  // void _trySubmit() {
    // final isValid = _formKey.currentState.validate();

    // FocusScope.of(context).unfocus();

    // if (_userPickedImage == null && !_isLogin) {
    //   Scaffold.of(context)
    //       .showSnackBar(SnackBar(content: Text('Please pick an image.')));
    // }

  //   if (isValid) {
  //     _formKey.currentState.save();
  //     widget.submitFn(
  //       _userEmail.trim(),
  //       _userPassword.trim(),
  //       _userName.trim(),
  //       // _userPickedImage,
  //       _isLogin,
  //       context,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      key: ValueKey('Email'),
                      validator: (value) {
                        if(value != null){
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a Valid email address';
                        }}
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Registered Email Address'),
                      onSaved: (value) {
                         if(value != null)
                        _userEmail = value;
                      },
                    ),
                    // if (!_isLogin)
                    //   TextFormField(
                    //     autocorrect: true,
                    //     textCapitalization: TextCapitalization.words,
                    //     enableSuggestions: false,
                    //     key: ValueKey('UserName'),
                    //     validator: (value) {
                    //        if(value != null){
                    //       if (value.isEmpty || value.length < 4) {
                    //         return 'Please enter atleast 4 characters';
                    //       }}
                    //       return null;
                    //     },
                    //     decoration: InputDecoration(labelText: 'Username'),
                    //     onSaved: (value) {
                    //        if(value != null)
                    //       _userName = value;
                    //     },
                    //   ),
                    // TextFormField(
                    //   key: ValueKey('Password'),
                    //   validator: (value) {
                    //      if(value != null){
                    //     if (value.isEmpty || value.length < 7) {
                    //       return 'Please enter atleast 7 characters';
                    //     }}
                    //     return null;
                    //   },
                    //   decoration: InputDecoration(labelText: 'Password'),
                    //   obscureText: true,
                    //   onSaved: (value) {
                    //      if(value != null)
                    //     _userPassword = value;
                    //   },
                    // ),
                    SizedBox(height: 20,),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        child: Text( 'Login'),
                        onPressed: (){},
                        
                      ),
                    // if (!widget.isLoading)
                    //   TextButton(
                    //     child: Text(
                    //           ? 'Create new account?'
                    //           : 'Already  have an account?',
                    //     ),
                    //     onPressed: () {
                    //       setState(() {
                    //         _isLogin = !_isLogin;
                    //       });
                    //     },
                    //   )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
