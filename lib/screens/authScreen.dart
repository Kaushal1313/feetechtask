import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/home.dart';
import 'package:flutter_application_2/widgets/appcolors.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _errorMessage = '';

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to the next screen or perform other actions upon successful signup
      print('User signed up: ${userCredential.user!.uid}');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If sign-in is successful, navigate to the home screen
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Please enter a valid email and password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'FeelTech Login',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 12.0),
            Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 12.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    child: Text('Sign Up'),
                    style: ElevatedButton.styleFrom(
                      primary: CustomColors.red,
                      textStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Sign In'),
                    style: ElevatedButton.styleFrom(
                      primary: CustomColors.green,
                      textStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
