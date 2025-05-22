import 'dart:convert';
import 'dart:developer';

bool validateIntegrityToken(String integrityToken) {
  try {
    log("Token de integridad recibido: $integrityToken");

    // Dividir el token en sus tres partes.
    final parts = integrityToken.split('.');
    if (parts.length != 3) {
      log("Token de integridad inválido: no tiene las tres partes esperadas.");
      return false;
    }

    // Decodificar el payload (segunda parte del token JWT).
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    log("Payload decodificado: $payload");

    // Convertir el payload a JSON para su análisis.
    final Map<String, dynamic> jsonPayload = json.decode(payload);
    log("Payload JSON: $jsonPayload");

    // Validación del campo `appIntegrity`.
    final appIntegrity = jsonPayload['appIntegrity'];
    if (appIntegrity == null) {
      log("Error: Campo 'appIntegrity' no encontrado en el payload.");
      return false;
    } else {
      log("appIntegrity encontrado: $appIntegrity");
    }

    // Verificar el valor de `appRecognitionVerdict`.
    final appRecognitionVerdict = appIntegrity['appRecognitionVerdict'];
    if (appRecognitionVerdict != "PLAY_RECOGNIZED") {
      log("Error: 'appRecognitionVerdict' tiene un valor inesperado: $appRecognitionVerdict");
      return false;
    }
    log("appRecognitionVerdict válido: $appRecognitionVerdict");

    // Validación del campo `deviceIntegrity`.
    final deviceIntegrity = jsonPayload['deviceIntegrity'];
    if (deviceIntegrity == null) {
      log("Error: Campo 'deviceIntegrity' no encontrado en el payload.");
      return false;
    } else {
      log("deviceIntegrity encontrado: $deviceIntegrity");
    }

    // Verificar el valor de `deviceRecognitionVerdict`.
    final deviceRecognitionVerdict = deviceIntegrity['deviceRecognitionVerdict'];
    if (deviceRecognitionVerdict == null || !deviceRecognitionVerdict.contains("MEETS_DEVICE_INTEGRITY")) {
      log("Error: 'deviceRecognitionVerdict' tiene un valor inesperado: $deviceRecognitionVerdict");
      return false;
    }
    log("deviceRecognitionVerdict válido: $deviceRecognitionVerdict");

    // Validación del campo `accountDetails`.
    final accountDetails = jsonPayload['accountDetails'];
    if (accountDetails == null) {
      log("Error: Campo 'accountDetails' no encontrado en el payload.");
      return false;
    } else {
      log("accountDetails encontrado: $accountDetails");
    }

    // Verificar el valor de `appLicensingVerdict`.
    final appLicensingVerdict = accountDetails['appLicensingVerdict'];
    if (appLicensingVerdict != "LICENSED") {
      log("Error: 'appLicensingVerdict' tiene un valor inesperado: $appLicensingVerdict");
      return false;
    }
    log("appLicensingVerdict válido: $appLicensingVerdict");

    // Todos los campos tienen valores esperados
    log("Token de integridad válido.");
    return true;

  } catch (e) {
    log("Error al validar el token de integridad: $e");
    return false;
  }
}
