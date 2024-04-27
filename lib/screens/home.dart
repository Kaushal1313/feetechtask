import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/database.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String? password = await _showPasswordDialog(context);
            if (password != null) {
              bool isAuthenticated = await _verifyPassword(password);
              if (isAuthenticated) {
                Get.to(MyHomePage());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Incorrect password. Please try again.'),
                  ),
                );
              }
            }
          },
          child: Text('Access'),
        ),
      ),
    );
  }

  Future<String?> _showPasswordDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String password = '';
        return AlertDialog(
          title: Text('Enter Your Password'),
          content: TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
            onChanged: (value) => password = value,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, password);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _verifyPassword(String password) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email!;
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return true;
      } catch (e) {
        print("Password verification failed: $e");
        return false;
      }
    } else {
      return false;
    }
  }
}
