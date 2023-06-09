
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/routes.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email,
                 password: password,
                 );
                 final user = FirebaseAuth.instance.currentUser;
              if(user!=null){
                if(user.emailVerified){
                  if(context.mounted){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute, (route) => false,);
                    }
                }
                else{
                  devtools.log(user.toString());
                  if(context.mounted){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute, (route) => false,);
                    }
                }
              }
              else{
                if(context.mounted){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, (route) => false,);
                    }
              }
                 
              } on FirebaseAuthException catch(e){
                if(e.code=='wrong-password'){
                  devtools.log('You have entered wrong password');
                }
                devtools.log(e.code);
              }
                
            },
                  child: const Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(resisterRoute, (route) => false);
              },child: const Text('Not Resistered? Resister here')
            )
          ],
        );
            default:
            return const CircularProgressIndicator();
          }
          
        }, 
        
      )
    );
  }
}
