import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../sistema.dart';
import '../utils/global.dart';
import '../utils/utils.dart' as utils;

class ConnectBloc {
  static ConnectBloc _instancia;

  ConnectBloc._internal();

  factory ConnectBloc() {
    if (_instancia == null) {
      _instancia = ConnectBloc._internal();
      _instancia.init();
    }
    return _instancia;
  }

  final connectStreamController = StreamController<int>.broadcast();

  Function(int) get connectSink => connectStreamController.sink.add;

  Stream<int> get connectStream => connectStreamController.stream;

  void disposeStreams() {
    connectStreamController?.close();
  }

  init() {
    Connectivity().onConnectivityChanged.listen(checkConnectivity);
    Connectivity().checkConnectivity().then(checkConnectivity);
  }

  checkConnectivity(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.mobile) {
      GLOBAL.mensaje = 'Conectado a red movil';
      GLOBAL.icono = Icons.phone;
      GLOBAL.color = Colors.green;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      GLOBAL.mensaje = 'Conectado a red wifi';
      GLOBAL.icono = Icons.wifi;
      GLOBAL.color = Colors.green;
    } else {
      GLOBAL.mensaje = 'Sin acceso a internet';
      GLOBAL.icono = Icons.stop;
      GLOBAL.color = Colors.red;
    }

    if (connectivityResult == ConnectivityResult.none) {
      connectSink(GLOBAL.DISCONECT);
    } else {
      bool isConectado = await verificarConexionAlServidor();
      if (isConectado) {
        connectSink(GLOBAL.CONECT);
      } else {
        GLOBAL.mensaje = 'Por favor cambia de red';
        GLOBAL.icono = Icons.error;
        GLOBAL.color = Colors.yellow;
        connectSink(GLOBAL.DISCONECT);
        _verificar();
      }
    }
  }

  _verificar({int intento = 1}) async {
    bool isConectado = await verificarConexionAlServidor();
    if (isConectado) {
      connectSink(GLOBAL.CONECT);
    } else {
      GLOBAL.mensaje = 'Por favor cambia de red';
      GLOBAL.icono = Icons.error;
      GLOBAL.color = Colors.yellow;
      connectSink(GLOBAL.DISCONECT);

      // Reconexión exponencial: multiplica el tiempo por el número de intentos, con un máximo de 5 intentos
      if (intento <= 5) {
        Future.delayed(Duration(seconds: 10 * intento), () {
          _verificar(intento: intento + 1);
        });
      }
    }
  }

  Future<bool> verificarConexionAlServidor() async {
    var client = http.Client();
    try {
      final resp = await client
          .get(Uri.parse(Sistema.dominio), headers: utils.headers)
          .timeout(Duration(seconds: 15)); // Reduce el tiempo de espera para respuestas más rápidas
      Map<String, dynamic> decodedResp = json.decode(resp.body);
      return decodedResp['status'];
    } catch (err) {
      print('Error en verificarConexionAlServidor: $err');
    } finally {
      client.close();
    }
    return false;
  }
}
