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
  final AuthService _authService = AuthService();

  bool isLogin = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String email = '';
  String password = '';
  String username = '';

  static const _primaryColor = Color(0xFF4F46E5); // indigo
  static const _secondaryColor = Color(0xFF7C3AED); // purple

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: _primaryColor),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primaryColor, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

Future<void> _handleSubmit() async {
  if (!_formkey.currentState!.validate()) return;

  _formkey.currentState!.save();

  setState(() => _isLoading = true);

  try {

    if (isLogin) {

      await _authService.signin(email, password);

    } else {

      await _authService.signup(
        email,
        password,
        username,
      );

    }


    if (!mounted) return;


    Navigator.pushReplacementNamed(
      context,
      '/home',
    );


  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );

  } finally {

    if (mounted) {
      setState(() => _isLoading = false);
    }

  }
}
Future<void> _handleGoogleSignIn() async {

  setState(() => _isLoading = true);

  try {

    bool isLogged = await _authService.signInWithGoogle();

    if (!mounted) return;


    if (!isLogged) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Google sign-in failed or was cancelled',
          ),
        ),
      );

    }


  } finally {

    if (mounted) {
      setState(() => _isLoading = false);
    }

  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo
                    const Icon(
                      Icons.chat_rounded,
                      size: 55,
                      color: _primaryColor,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      isLogin ? "Welcome Back" : "Create Account",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff111827),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      isLogin
                          ? "Login to continue chatting"
                          : "Join and start conversations",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    if (!isLogin) ...[
                      TextFormField(
                        decoration: _fieldDecoration(
                          label: "Username",
                          hint: "Enter username",
                          icon: Icons.person_outline,
                        ),
                        style: TextStyle(color: Colors.black),
                        validator: (value) =>
                            value!.length < 3 ? "Username too short" : null,
                        onSaved: (value) => username = value!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: _fieldDecoration(
                        label: "Email",
                        hint: "Enter email",
                        icon: Icons.email_outlined,
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) =>
                          !value!.contains("@") ? "Invalid email" : null,
                      onSaved: (value) => email = value!,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      obscureText: _obscurePassword,
                      style: TextStyle(color: Colors.black),
                      decoration: _fieldDecoration(
                        label: "Password",
                        hint: "Enter password",
                        icon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) => value!.length < 6
                          ? "Password must be 6 characters"
                          : null,
                      onSaved: (value) => password = value!,
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                isLogin ? "Login" : "Create Account",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin
                            ? "Create new account"
                            : "Already have an account?",
                        style: const TextStyle(
                          color: _primaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _handleGoogleSignIn,
                      icon: const Icon(
                        Icons.g_mobiledata,
                        size: 28,
                      ),
                      label: const Text(
                        "Continue with Google",
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
