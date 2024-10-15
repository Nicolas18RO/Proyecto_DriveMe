import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //Inicio de seseion con Google
  singInWithGoogle() async {
    //Inicio de sesion interactivo en proceso
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //Obtencion de detalles de Autentificación
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;


    //Crear una nueva credencial para el usuario
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //Finalmente, se inicia sesion 
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}