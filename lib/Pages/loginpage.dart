import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messagingapp/Functions/auth.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _formkey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // AuthService instance

  bool isLogin = false;
  String email = '';
  String password = '';
  String username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Email/Password Auth'),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Card(
              
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin ? 'Welcome Back 👋' : 'Create Account ✨',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!isLogin)
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Username',
                            hintText: "Enter Username"),
                        validator: (value) =>
                            value!.length < 3 ? 'Username too short' : null,
                        onSaved: (value) => username = value!,
                      ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Email',
                          hintText: "Enter Email"),
                      validator: (value) =>
                          !value!.contains('@') ? 'Invalid Email' : null,
                      onSaved: (value) => email = value!,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Password',
                          hintText: "Enter Password"),
                      validator: (value) =>
                          value!.length < 6 ? 'Password too short' : null,
                      onSaved: (value) => password = value!,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            try {
                              if (isLogin) {
                                await _authService.signin(email, password);
                              } else {
                                await _authService.signup(email, password);
                              }
                              if (FirebaseAuth.instance.currentUser != null) {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Authentication failed'),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          }
                        },
                        child: Text(isLogin ? 'Login' : 'Signup'),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => isLogin = !isLogin),
                      child: Text(
                        isLogin
                            ? "Don't have an account? Signup"
                            : "Already signed up? Login",
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool isLogged = await _authService.signInWithGoogle();
                          if (isLogged) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Google sign-in failed or was cancelled',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Sign in with Google'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
