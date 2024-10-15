import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prueba_driveme/pages/home_page.dart';
import 'package:prueba_driveme/pages/login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //Inicio de sesion Correcto
          if(snapshot.hasData){
            return HomePage();
          }

          //Inicio de sesion Incorrecto
          else{
            return const LoginOrRegisterPage();
          }
        },
        
      ),
    );
  }
}