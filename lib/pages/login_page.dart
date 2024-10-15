import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prueba_driveme/Componentes/my_botton.dart';
import 'package:prueba_driveme/Componentes/my_image.dart';
import 'package:prueba_driveme/Componentes/my_textfield.dart';
import 'package:prueba_driveme/Servicios/local_auth.dart';
import 'package:prueba_driveme/Servicios/servers_auth.dart';
import 'package:prueba_driveme/pages/home_page.dart'; // Asegúrate de que la ruta sea correcta
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controller 
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Autentificación de Datos Biometricos
  bool Auth = false;

  // Datos Biométricos
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricChoice();
  }

  // Cargar la preferencia de autenticación biométrica
  Future<void> _checkBiometricChoice() async {
    bool isEnabled = await loadBiometricChoice();
    setState(() {
      _biometricEnabled = isEnabled;
    });
  }

  // Método para iniciar sesión
  void IniciarSesion() async {
    // Mostrar un círculo de carga mientras se inicia la sesión
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // Intento de inicio de sesión
    try {
      if(emailController.text.isEmpty || passwordController.text.isEmpty){
        Navigator.pop(context);
        mostrarMensajeError("Por favor, Ingresa el correo y la contraseña");
        return;
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
      );

      // Finalización del círculo de carga
      Navigator.pop(context);
      
      // Redireccionar a HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage())
      );
    } on FirebaseAuthException catch (e) {
      // Finalización del círculo de carga
      Navigator.pop(context);

      //Mensajes de Error
      switch (e.code) {
        case 'invalid-email':
          mostrarMensajeError('Correo electrónico inválido');
          break;
        case 'user-not-found':
          mostrarMensajeError('No se encontró un usuario con ese correo electrónico');
          break;
        case 'wrong-password':
          mostrarMensajeError('Contraseña incorrecta');
          break;
        default:
          mostrarMensajeError('Error desconocido: ${e.code}');
      }
    }
  }

  void mostrarMensajeError(String mensaje) {
    showDialog(
      context: context, 
      builder: (context) {
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

  // Función para cargar la opción guardada
  Future<bool> loadBiometricChoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('useBiometric') ?? false; // Si no hay elección, retorna false
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(child: Center(
        child: SingleChildScrollView(
          child: Column(
            children:  [
              const SizedBox(height: 50),

              // Logo
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 30),

              // Mensaje de bienvenida 
              Text(
                "Bienvenidos a DriveMe!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 25),

              // Email TextField
              MyTextField(
                controller: emailController,
                hintText: "Usuario",
                obscureText: false,
              ),
              const SizedBox(height: 15),

              // Password TextField
              MyTextField(
                controller: passwordController,
                hintText: "Contraseña",
                obscureText: true,
              ),
              const SizedBox(height: 15),

              // Olvidaste la contraseña?
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Olvidaste la contraseña?",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),

              // Botón Iniciar Sesión
              MyButton(
                text: "Iniciar Sesion",
                onTap: IniciarSesion,
              ),
              const SizedBox(height: 20),

              // Line: O continúa con...
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

              const SizedBox(height: 30),
              // Google Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyImage(
                    onTap: () => AuthService().singInWithGoogle(),
                    imagePath: 'lib/Imagenes/GoogleIcon.webp'
                  ),
                  const SizedBox(width: 10),
                  if(_biometricEnabled)
                    MyImage(
                      imagePath: 'lib/Imagenes/Imagen_Huella.png',
                      onTap: () async {
                        final authen = await LocalAuth.authenticate();
                        setState(() {
                        Auth = authen;
                      });
                      if(Auth){
                        AuthService().singInWithGoogle();
                      }else{
                        mostrarMensajeError("Autenticación fallida. Intenta nuevamente.");
                      }
                      },
                    ),
                ],
              ),

              const SizedBox(height: 30),

              // No estás registrado? Regístrate Ahora
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No estás registrado?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Regístrate Ahora',
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

