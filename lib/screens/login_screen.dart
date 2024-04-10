import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isSignUp = false;
  String _errorMessage = '';
  double _backgroundPosition = 0;

  @override
  void initState() {
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    Color primaryColor = Colors.blue[800]!; 
    Color accentColor = Colors.white;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -_backgroundPosition,
            left: -_backgroundPosition,
            right: -_backgroundPosition,
            bottom: -_backgroundPosition,
            child: Image.asset(
              'assets/images/background.png', 
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'STORM.LY',
                      style: GoogleFonts.permanentMarker(
                        textStyle: TextStyle(
                          fontSize: 60,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.thunderstorm_outlined,
                      color: Colors.blue[800],
                      size: 50.0,
                    ),
                    SizedBox(height: 20),
                    if (_isSignUp) _buildTextField(_usernameController, 'Username', primaryColor, accentColor),
                    SizedBox(height: _isSignUp ? 10 : 0),
                    _buildTextField(_emailController, 'Email', primaryColor, accentColor),
                    SizedBox(height: 10),
                    _buildTextField(_passwordController, 'Password', primaryColor, accentColor, isPassword: true),
                    SizedBox(height: 20),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: accentColor,
                      ),
                      onPressed: () => _isSignUp ? _signUp() : _signIn(),
                      child: Text(_isSignUp ? 'Sign Up' : 'Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                          _errorMessage = '';
                        });
                      },
                      child: Text(
                        _isSignUp ? 'Already have an account? Sign In' : 'Don\'t have an account? Sign Up',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String labelText, Color primaryColor, Color accentColor, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: primaryColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: primaryColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor),
        ),
        fillColor: accentColor,
        filled: true,
      ),
    );
  }

  void _signIn() async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/homepage');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred during sign in.';
      });
    }
  }

  void _signUp() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': _usernameController.text,
          'email': _emailController.text,
          'registrationDateTime': FieldValue.serverTimestamp(),
        });
        Navigator.pushReplacementNamed(context, '/homepage');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred during sign up.';
      });
    }
  }
}
