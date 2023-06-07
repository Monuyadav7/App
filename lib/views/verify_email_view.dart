
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Column(
          children: [
            const Text('Please verify your email'),          
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              }, child: const Text('Click here to verify your email'),
            ),
            TextButton(
              onPressed: () {
                   Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false,);
              },child: const Text('Verified your email?login here')
            )
          ],
        ),
    );
  }
}
