


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import '../constants/routes.dart';
import '../firebase_options.dart';

class ResisterView extends StatefulWidget {
  const ResisterView({super.key});

  @override
  State<ResisterView> createState() => _ResisterViewState();
}

class _ResisterViewState extends State<ResisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
                     options: DefaultFirebaseOptions.currentPlatform,
                     ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){            
            case ConnectionState.done:
              return  Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
            ),
            TextButton(onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try{
                  final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email, 
                password: password
                );
                devtools.log(userCredential.toString());
            }
             on FirebaseAuthException catch(e){
              if(e.code=='email-already-in-use'){
                devtools.log('You have already resistered, please login');
              }
            }
              },
              
                  child: const Text('Resister')),
                  TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false,);
              },child: const Text('Already Resistered? Login here')
            )
          ],
        );
            default:
            return const Text('Loading...');
          }
          
        }, 
        
      )
    );
  }
}
