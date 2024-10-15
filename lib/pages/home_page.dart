import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prueba_driveme/Componentes/my_botton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usuario = FirebaseAuth.instance.currentUser!;

  

  //Metodo salirIncioSesion
  void salirIncioSesion(){
    FirebaseAuth.instance.signOut();
  }

  //Metodo que captura la preferencia de inicio de sesion.
  Future<void> mensajeEmergente(BuildContext context) async {

    bool? opcionHuella = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
            title: const Text("Estás Seguro?"),
            actions: [
              //Opcion: Si
              MaterialButton(
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
                child: const Text("Si"),
                ),
                //Opcion: No
                MaterialButton(
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
                ),
            ],
        );
      }
      );
      // Guardar la elección del usuario
      if (opcionHuella != null) {
        await saveBiometricChoice(opcionHuella);
      }
  }

  //Metodo para guardar la opcion de la huella  
  Future<void> saveBiometricChoice(bool enableBiometrics) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useBiometric', enableBiometrics); // Guarda true o false
  }

  // Función para cargar la opción guardada (para mostrar el botón de huella dactilar)
  Future<bool> loadBiometricChoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('useBiometric') ?? false; // Si no hay elección, retorna false
  }
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold (
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        actions: [
          IconButton(
            onPressed: salirIncioSesion, 
            icon: const Icon(Icons.logout, color: Colors.black,)
          ) 
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 300,
              width: 350,
              decoration:const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.white,  
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 90),
                child: Column(
                  children: [
                    const Text(
                      "¡FELICIDADES HAS INICIADO SESION!" ,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                
                    ),
                    const SizedBox(height: 30),
                    Text(
                      usuario.email!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Flexible(child: 
                      Icon(
                      Icons.check_circle,
                      color: Color.fromRGBO(61, 167, 84, 1.0),
                      size: 60,
                    ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80,),
            
            //Boton para guardar la preferencia del usuario
            MyButton(
              text: "Iniciar con Huella",
              onTap: (){
                mensajeEmergente(context);
              },
             ),
          ],
        ),
      ),
    );
  }
}