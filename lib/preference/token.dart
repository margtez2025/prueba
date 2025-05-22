// token.dart
import 'package:firebase_app_check/firebase_app_check.dart';

class TokenService {
  String _eventToken = 'Token aún no obtenido';

  TokenService() {
    _initializeAppCheck();
  }

  String get token => _eventToken;

  Future<void> _initializeAppCheck() async {
    await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.playIntegrity);
    FirebaseAppCheck.instance.onTokenChange.listen((token) {
      _eventToken = token ?? 'Token no disponible';
    });
  }

Future<void> obtenerTokenManualmente() async {
  try {
    _eventToken = await FirebaseAppCheck.instance.getToken(true);
    
    // Escuchar cambios en el token automáticamente después de obtenerlo.
    FirebaseAppCheck.instance.onTokenChange.listen((token) {
      _eventToken = token ?? 'Token no disponible';
    });
  } catch (e) {
    print('Error al obtener el token de App Check: $e');
    throw Exception('Error al obtener el token de App Check');
  }
}

}
