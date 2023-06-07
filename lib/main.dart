
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/resister_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;
import 'constants/routes.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding();
  runApp(MaterialApp(
      title: 'MyNotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute : (context) => const LoginView(),
        resisterRoute : (context) => const ResisterView(),
        notesRoute : (context) => const NotesView(), 
        verifyEmailRoute : (context) => const VerifyEmailView(),        
      },
    ),);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: Firebase.initializeApp(
                     options: DefaultFirebaseOptions.currentPlatform,
                     ),
        builder: (context, snapshot) { 
          switch(snapshot.connectionState){              
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
              if(user!=null){
                if(user.emailVerified){
                  return const NotesView();
                }
                else{
                  devtools.log(user.toString());
                  return const VerifyEmailView();
                }
              }
              else{
                return const LoginView();
              }
              // if(user?.emailVerified ?? false){
              //     print('You are a verified user');
              // }
              // else{
              //   print(user);
              //     print('You need to verify your email');
              //     return const LoginView();
                  
              // }
              // return const Text('Done');
            default:
            return const CircularProgressIndicator();
          }
          
        }, 
        
      );
  }
}
enum MenuItems {logout}
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [ 
          PopupMenuButton<MenuItems> (onSelected: (value) async {
                    switch(value) {       
                      case MenuItems.logout:
                        final logOut = await showLogOutDiaBox(context) ;
                          
                        if(logOut){
                          FirebaseAuth.instance.signOut();
                          if (context.mounted) {Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, 
                            (_) => false,
                            );
                          }}
                        break;}
                    }, 
        itemBuilder: (context) {
          return const [
                  PopupMenuItem(value: MenuItems.logout ,child: Text('Log out')),
          ];
        },
        ) ],
        )
    );
  }
}

Future<bool> showLogOutDiaBox(BuildContext context){
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure want to logout'),
          actions: [
            TextButton ( onPressed: (){Navigator.of(context).pop(true);},child: const Text('Yes')),
            TextButton ( onPressed: (){Navigator.of(context).pop(false);},child: const Text('No'))
          ],
          );
      },
  ).then((value) => value ?? false) ;
}
