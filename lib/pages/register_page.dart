import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prueba_driveme/Componentes/my_botton.dart';
import 'package:prueba_driveme/Componentes/my_image.dart';
import 'package:prueba_driveme/Componentes/my_textfield.dart';
import 'package:prueba_driveme/Servicios/servers_auth.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Text editing controller 
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //Metodo Registrar ususario de Sesion
  void registrarSesion () async {

    //Mostrar un circulo de carga mientras se inisia la sesion
    showDialog(context: 
      context, 
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    //Intento de crear usuario de sesion
    try{
      //Confirmar si la contraseña está confirmada
      if(passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text
        );
      } else {
        //Mostrar mensaje de Error
        monstrarMensajeError("¡Las contraseñas no Coinciden!");
      }
    //Finalizacion de ciruculo de carga
    Navigator.pop(context);
    } on FirebaseAuthException catch (e){
      //Finalizacion de ciruculo de carga
      Navigator.pop(context);
      //Mostrar mensaje de Error
      monstrarMensajeError(e.code);
    }
  }

  void monstrarMensajeError (String mensaje){
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                mensaje,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: 
        SafeArea(child: Center(
          child: SingleChildScrollView(
            child: Column(
              children:  [
                const SizedBox(height: 50),
            
                //Logo
                const Icon(
                  Icons.alternate_email_rounded,
                  size: 50,
                ),
                const SizedBox(height: 30),
                
                //Mensaje: Vamos a crear una cuenta para ti
                Text(
                  "¡Vamos a crear una cuenta para ti!",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    ),
                ),
                const SizedBox(height: 25),
            
                //email Textfield
                MyTextField(
                  controller: emailController,
                  hintText: "Usuario",
                  obscureText: false,
            
                ),
                const SizedBox(height: 15),
            
                //Password Textfield
                MyTextField(
                  controller: passwordController,
                  hintText: "Contraseña",
                  obscureText: true,
                ),

                const SizedBox(height: 15),

                //Confirmar Password Textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirmar Contraseña",
                  obscureText: true,
                ),
                
                const SizedBox(height: 40),
            
                //Button Crear cuenta
                MyButton(
                  text: "Crear Cuenta",
                  onTap: registrarSesion,
                ),
                const SizedBox(height: 20),
            
                //Line: O continuan con...
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                  
                      ),
                      ),
                  
                      Text(
                        "O continua con",
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                  
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                  
                      ),
                      )
                      
                      
                    ],
                  ),
                ),
            
                const SizedBox(height: 10),

                //Google Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyImage(
                      onTap: () => AuthService().singInWithGoogle(),
                      imagePath: 'lib/Imagenes/GoogleIcon.webp'),
                  ],
                ),

                const SizedBox(height: 20),
                
                //Ya estás registradod? Inicia sesion ahora
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ya estás registrado?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Inicia Sesion Ahora',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )),
    );
  }
}

