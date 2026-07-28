import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import  'package:messagingapp/Services/chats.dart';
import 'package:messagingapp/Functions/auth.dart';
import 'loginpage.dart';

import 'homepage.dart';



class AuthWrapper extends StatelessWidget {

  const AuthWrapper({super.key});


  @override
  Widget build(BuildContext context) {


    return StreamBuilder<User?>(
      
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {


        if(snapshot.connectionState ==
            ConnectionState.waiting){

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );

        }



        if(snapshot.hasData){

          // Already logged in
          return const Homepage();

        }



        // Not logged in
        return const Authentication();

      },

    );

  }

}