import 'dart:io';
import 'package:flutter/material.dart';

enum Password { visibility, nonVisibility }

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    BuildContext ctx,
  ) submitFn;
  bool isLoading;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Password _password = Password.nonVisibility;
  // var _userEmail = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // if (!_isLogin) UserImagePicker(_pickedImage),
                    InputContainer(
                      child: TextField(
                        controller: _emailController,
                        cursorColor: Colors.blue,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          icon: const Icon(
                            Icons.email,
                            color: Colors.blue,
                          ),
                          hintText: "Registered Email",
                          hintStyle: const TextStyle(color: Colors.blue),
                          border: InputBorder.none,
                          suffixIcon: _emailController.text.isNotEmpty
                              ? InkWell(
                                  child: const Icon(Icons.clear_rounded),
                                  onTap: () {
                                    setState(() {
                                      _emailController.text = "";
                                    });
                                  },
                                )
                              : null,
                        ),
                        style: const TextStyle(color: Colors.blue),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                    ),
                    InputContainer(
                      child: TextField(
                        controller: _passwordController,
                        cursorColor: Colors.blue,
                        obscureText:
                            _password == Password.nonVisibility ? true : false,
                        style: const TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          icon:const  Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.blue),
                          border: InputBorder.none,
                          suffixIcon: InkWell(
                            child: Icon(
                              _password == Password.nonVisibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onTap: () {
                              if (_password == Password.nonVisibility) {
                                setState(() {
                                  _password = Password.visibility;
                                });
                              } else {
                                setState(() {
                                  _password = Password.nonVisibility;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        child: Text('Login'),
                        onPressed: _trySubmit,
                      ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class InputContainer extends StatelessWidget {
  const InputContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
