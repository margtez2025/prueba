import 'package:firebase_app_check/firebase_app_check.dart';

class AppCheckService {
  String appCheckToken;

  AppCheckService() {
    initializeAppCheck();
    setupTokenListener();
  }

  /// Inicializa App Check con Play Integrity para obtener tokens válidos.
  /// Si ocurre un error, el flujo lo captura e imprime un mensaje de error,
  /// pero permite reintentar la activación de manera controlada en otros métodos.
  void initializeAppCheck() async {
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
      );
      print("Firebase App Check activado.");
    } catch (e) {
      print("Error al activar App Check: $e");
    }
  }

  /// Método para obtener el token de App Check de manera manual.
  /// Este método permite solicitar explícitamente el token cuando sea necesario,
  /// como en una operación específica (ej., verificación del teléfono).
  /// Si falla, el flujo de la operación se puede manejar allí mismo, permitiendo
  /// que se realicen más intentos o que se capture el error de forma controlada.
  Future<String> getAppCheckToken() async {
    try {
      String token = await FirebaseAppCheck.instance.getToken(true);
      print('Token de App Check: $token');
      if (token != null && token.isNotEmpty) {
        appCheckToken = token;
        print("Token de App Check obtenido: $appCheckToken");
        return appCheckToken;
      } else {
        print('Error: Token de App Check inválido o vacío');
        return null;
      }
    } catch (e) {
      print('Error al obtener el token de App Check en AppCheckService: $e');
      // Si falla, permite gestionar el error aquí, como en el primer código,
      // ofreciendo la flexibilidad de manejar diferentes respuestas según el caso.
      return null;
    }
  }

  /// Listener para actualizar automáticamente el token de App Check cuando cambie.
  /// Aunque se actualiza el token automáticamente, este listener no siempre ofrece
  /// control directo como el método `getAppCheckToken` en operaciones específicas.
  void setupTokenListener() {
    FirebaseAppCheck.instance.onTokenChange.listen((token) {
      if (token != null && token.isNotEmpty) {
        appCheckToken = token;
        print("Nuevo Token de App Check recibido automáticamente: $appCheckToken");
      } else {
        print('Token de App Check no disponible');
      }
    });
  }
}
























































// import 'package:firebase_app_check/firebase_app_check.dart';

// class AppCheckService {
//   String appCheckToken;

//   AppCheckService() {
//     initializeAppCheck();
//     setupTokenListener();
//   }

//   void initializeAppCheck() async {
//     try {
//       await FirebaseAppCheck.instance.activate(
//         androidProvider: AndroidProvider.playIntegrity,
//       );
//       print("Firebase App Check activado.");
//     } catch (e) {
//       print("Error al activar App Check: $e");
//     }
//   }

//   Future<String> getAppCheckToken() async {
//     try {
//       String token = await FirebaseAppCheck.instance.getToken(true);
//       print('Token de App Check: $token');
//       if (token != null && token.isNotEmpty) {
//         appCheckToken = token;
//         print("Token de App Check obtenido: $appCheckToken");
//         return appCheckToken;
//       } else {
//         print('Error: Token de App Check inválido o vacío');
//         return null;
//       }
//     } catch (e) {
//       print('Error al obtener el token de App Check en AppCheckService: $e');
//       return null;
//     }
//   }

//   void setupTokenListener() {
//     FirebaseAppCheck.instance.onTokenChange.listen((token) {
//       if (token != null && token.isNotEmpty) {
//         appCheckToken = token;
//         print("Nuevo Token de App Check recibido automáticamente: $appCheckToken");
//       } else {
//         print('Token de App Check no disponible');
//       }
//     });
//   }
// }















// import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:http/http.dart' as http;

// import '../sistema.dart';

// class AppCheckService {
//   String appCheckToken;

//   AppCheckService() {
//     initializeAppCheck();
//     setupTokenListener();
//   }

//   void initializeAppCheck() async {
//     try {
//       await FirebaseAppCheck.instance.activate(
//         androidProvider: AndroidProvider.playIntegrity,
//       );
//       print("Firebase App Check activado.");
//     } catch (e) {
//       print("Error al activar App Check: $e");
//     }
//   }

//   Future<String> getAppCheckToken(bool bool) async {
//       String appCheckToken = await FirebaseAppCheck.instance.getToken(true);
//     if (appCheckToken != null) return appCheckToken;

//     try {
//       String appCheckToken = await FirebaseAppCheck.instance.getToken(true);
//       if (appCheckToken != null && appCheckToken.isNotEmpty) {
//         appCheckToken = appCheckToken;
//         print("Token de App Check obtenido: $appCheckToken");
//         return appCheckToken;
//       } else {
//         print('Error: Token de App Check inválido o vacío');
//         return null;
//       }
//     } catch (e) {
//       print('Error al obtener el token de App Check en AppCheckService: $e');
//       return null;
//     }
//   }

//   void setupTokenListener() {
//     FirebaseAppCheck.instance.onTokenChange.listen((token) {
//       if (token != null && token.isNotEmpty) {
//         appCheckToken = token;
//         print("Nuevo Token de App Check recibido automáticamente: $appCheckToken");
//       } else {
//         print('Token de App Check no disponible');
//       }
//     });
//   }
// }

// class ApiService {
//   final AppCheckService appCheckService = AppCheckService();

//   Future<http.Response> sendRequest(String url) async {
//     // Obtén el token de App Check
//     String appCheckToken = await appCheckService.getAppCheckToken(true);

//     // Agrega el token en el encabezado de la solicitud
//     final headers = {
//       'Content-Type': 'application/json',
//       'X-Firebase-AppCheck': appCheckToken ?? '',
//     };

//     // Realiza la solicitud GET o POST según tu necesidad
//     final response = await http.get(Uri.parse(url), headers: headers);

//     return response;
//   }
// }

// final String _tokenendpoint = 'cliente/verificar-validar-celular';

// void makeRequest() async {
//   final apiService = ApiService();
//   final response = await apiService.sendRequest(Sistema.dominio + _tokenendpoint);

//   if (response.statusCode == 200) {
//     print("Solicitud exitosa: ${response.body}");
//   } else {
//     print("Error en la solicitud: ${response.statusCode}");
//   }
// }

