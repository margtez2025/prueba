import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/agencia_model.dart';
import '../sistema.dart';

class AgenciaProvideraid {
  final String _urlObtenerAgencias = 'agenciaa/obtenerAgencias';
  List<AgenciaModel> _agencias = [];

  List<AgenciaModel> get agencias => _agencias;

  Future<void> obtenerAgencias() async {
    final response = await http.get(Uri.parse(Sistema.dominio + _urlObtenerAgencias)); // URL del API
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _agencias = data.map((item) => AgenciaModel.fromJson(item)).toList();
    } else {
      // Manejo de errores
      print('Error al obtener agencias: ${response.statusCode}');
    }
  }
}
