import 'package:firebase_app_check/firebase_app_check.dart';

class AppCheckHelper {
  Future<void> getAppCheckToken({bool forceRefresh = false}) async {
    try {
      // Intento de obtener el token de App Check con forceRefresh
      final appCheckToken = await FirebaseAppCheck.instance.getToken(forceRefresh);
      
      if (appCheckToken != null) {
        print('Token de App Check obtenido: $appCheckToken');
      } else {
        print('Token no disponible');
      }
      
    } on FirebaseException catch (e) {
      // Manejo de errores específicos de Firebase
      switch (e.code) {
        case 'app-check/invalid-configuration':
          print('Error: Configuración inválida para App Check.');
          break;
        case 'app-check/network-failure':
          print('Error: Fallo de red al intentar obtener el token de App Check.');
          break;
        case 'app-check/unverified-device':
          print('Error: El dispositivo no pasó la verificación de App Check.');
          break;
        case 'app-check/api-not-available':
          print('Error: App Check no está disponible en este dispositivo.');
          break;
        default:
          print('Error de Firebase desconocido: ${e.message}');
      }
    } catch (e) {
      // Manejo de otros tipos de errores
      print('Error desconocido al obtener el token de App Check: $e');
    }
  }
}


// import 'package:firebase_app_check/firebase_app_check.dart';

// class AppCheckHelper {
//   Future<void> getAppCheckToken() async {
//     try {
//       // Intento de obtener el token de App Check con forceRefresh activado
//       final appCheckToken = await FirebaseAppCheck.instance.getToken(false);
//       //final appCheckToken = await FirebaseAppCheck.instance.getToken(true);

      
//       if (appCheckToken != null) {
//         print('Token de App Check obtenido: $appCheckToken');
//       } else {
//         print('Token no disponible');
//       }
      
//     } on FirebaseException catch (e) {
//       // Manejo de errores específicos de Firebase
//       switch (e.code) {
//         case 'app-check/invalid-configuration':
//           print('Error: Configuración inválida para App Check.');
//           break;
//         case 'app-check/network-failure':
//           print('Error: Fallo de red al intentar obtener el token de App Check.');
//           break;
//         case 'app-check/unverified-device':
//           print('Error: El dispositivo no pasó la verificación de App Check.');
//           break;
//         case 'app-check/api-not-available':
//           print('Error: App Check no está disponible en este dispositivo.');
//           break;
//         default:
//           print('Error de Firebase desconocido: ${e.message}');
//       }
//     } catch (e) {
//       // Manejo de otros tipos de errores
//       print('Error desconocido al obtener el token de App Check: $e');
//     }
//   }
// }
