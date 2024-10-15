import 'package:flutter/material.dart';
import 'package:prueba_driveme/pages/login_page.dart';
import 'package:prueba_driveme/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {  
  //Inicialmente se mostrará LoginPage
  bool showLoginPage = true;

  //Luego entre login y Register page
  void togglePage(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(
        onTap: togglePage,
      );

    } else{
      return RegisterPage(onTap: togglePage);
    }
  }
}