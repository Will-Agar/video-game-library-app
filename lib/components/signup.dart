import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Center(
          child: Column(
            children: [
              Text('Sign Up'),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  Navigator.pushNamed(context, '/app');
                },
              ),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              )
            ],
          ),
        )
      ),
    );
  }
}