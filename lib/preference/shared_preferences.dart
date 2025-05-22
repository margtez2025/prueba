import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../model/cliente_model.dart';
import '../model/direccion_model.dart';
import '../sistema.dart';

class PreferenciasUsuario {
  static PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    if (_instancia == null) {
      _instancia = PreferenciasUsuario._internal();
    }
    return _instancia;
  }

  init() async {
    try {
      _instancia._prefs = await SharedPreferences.getInstance();
    } catch (err) {
      print(err);
    }
  }

  SharedPreferences _prefs;



  get testig {
    return _prefs.getBool('testig') ?? false;
  }

  get param {
    return _prefs.getString('param') ?? '';
  }


  get auth {
    return _prefs.getString('auth') ?? '';
  }





  get sms {
    return _prefs.getString('sms') ?? '';
  }


  get solicitados {
    return _prefs.getInt('solicitados') ?? 0;
  }


  get fechaCodigo {
    return _prefs.getString('fechaCodigo') ?? DateTime.now().toIso8601String();
  }


  get estadoTc {
    return _prefs.getInt('estadoTc') ?? 0;
  }


  get mensajeTc {
    return _prefs.getString('mensajeTc') ??
        'Próximamente podrás pagar con tus tarjetas favoritas.';
  }


  get conf {
    return _prefs.getString('conf') ?? 'null';
  }

  

  get clienteModel {
    final cliente = ClienteModel();
    cliente.link = _prefs.getString('link') ?? '';
    cliente.nombres = _prefs.getString('nombres') ?? '';
    cliente.apellidos = _prefs.getString('apellidos') ?? '';
    cliente.correo = _prefs.getString('correo') ?? '';
    cliente.idCliente = _prefs.getString('idCliente') ?? '';
    cliente.cedula = _prefs.getString('cedula') ?? '';
    cliente.celular = _prefs.getString('celular') ?? '';
    cliente.img = _prefs.getString('img') ?? '';
    cliente.perfil = _prefs.getString('perfil') ?? '';
    cliente.beta = _prefs.getString('beta') ?? 'null';

    cliente.celularValidado = _prefs.getInt('celularValidado') ?? 0;
    cliente.sexo = _prefs.getInt('sexo') ?? 0;
    cliente.calificacion = _prefs.getDouble('calificacion') ?? 0.0;
    cliente.calificaciones = _prefs.getInt('calificaciones') ?? 0;
    cliente.registros = _prefs.getInt('registros') ?? 0;
    cliente.puntos = _prefs.getInt('puntos') ?? 0;
    cliente.direcciones = _prefs.getInt('direcciones') ?? 0;
    cliente.correctos = _prefs.getInt('correctos') ?? 0;
    cliente.canceladas = _prefs.getInt('canceladas') ?? 0;
    cliente.fechaNacimiento = _prefs.getString('fechaNacimiento') ?? '';
    return cliente;
  }



  get direccionModel {
    final direccion = DireccionModel();
    direccion.idDireccion = _prefs.getInt('idDireccion') ?? -1;
    direccion.lt = _prefs.getDouble('lt') ?? Sistema.lt;
    direccion.lg = _prefs.getDouble('lg') ?? Sistema.lg;
    direccion.alias = _prefs.getString('direccion') ?? '';
    return direccion;
  }

  get isDemo {
    return clienteModel.correo ==
            'explorar@${Sistema.aplicativoTitle.toLowerCase()}.com' ||
        isExplorar;
  }

  get isExplorar {
    return '' == _prefs.getString('idCliente') ||
        _prefs.getString('idCliente') == Sistema.ID_CLIENTE;
  }

  get idCliente {
    return _prefs.getString('idCliente') ?? '';
  }


  get uuid {
    if (_prefs.getString('uuid') == null) {
      _prefs.setString('uuid', Uuid().v4());
    }
    return _prefs.getString('uuid');
  }



  get imei {
    return _prefs.getString('imei') ?? '';
  }


  get token {
    if (_prefs == null) return '';
    return _prefs.getString('token') ?? '';
  }



  get empezamos {
    if (_prefs == null) return false;
    return _prefs.getBool('empezamos') ?? false;
  }



  get idUrbe {
    return _prefs.getString('idUrbe') ?? '1';
  }


  get alias {
    return _prefs.getString('alias') ?? '?';
  }



  get idAgencia {
    return _prefs.getString('idAgencia') ?? '0';
  }



  get simCountryCode {
    return _prefs.getString('simCountryCode') ?? 'BO';
  }


  get rastrear {
    return _prefs.getBool('rastrear') ?? false;
  }



  get optimizado {
    return _prefs.getBool('optimizado') ?? false;
  }

set testig(bool value) {
  if (_prefs != null) {
    _prefs.setBool('testig', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set param(String value) {
  if (_prefs != null) {
    _prefs.setString('param', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set auth(String value) {
  if (_prefs != null) {
    _prefs.setString('auth', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set sms(String value) {
  if (_prefs != null) {
    _prefs.setString('sms', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set solicitados(int value) {
  if (_prefs != null) {
    _prefs.setInt('solicitados', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set fechaCodigo(String value) {
  if (_prefs != null) {
    _prefs.setString('fechaCodigo', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set estadoTc(int value) {
  if (_prefs != null) {
    _prefs.setInt('estadoTc', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set mensajeTc(String value) {
  if (_prefs != null) {
    _prefs.setString('mensajeTc', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set conf(String value) {
  if (_prefs != null) {
    _prefs.setString('conf', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set clienteModel(ClienteModel cliente) {
  if (_prefs != null) {
    _prefs.setString('idUrbe', cliente.idUrbe.toString());
    _prefs.setString('link', cliente.link.toString());
    _prefs.setString('nombres', cliente.nombres.toString());
    _prefs.setString('apellidos', cliente.apellidos.toString());
    _prefs.setString('correo', cliente.correo.toString());
    _prefs.setString('idCliente', cliente.idCliente.toString());
    _prefs.setString('cedula', cliente.cedula.toString());
    _prefs.setString('celular', cliente.celular.toString());
    _prefs.setString('img', cliente.img.toString());
    _prefs.setString('perfil', cliente.perfil.toString());
    _prefs.setString('beta', cliente.beta.toString());
    _prefs.setInt('celularValidado', cliente.celularValidado);
    _prefs.setInt('sexo', cliente.sexo);
    _prefs.setDouble('calificacion', cliente.calificacion);
    _prefs.setInt('calificaciones', cliente.calificaciones);
    _prefs.setInt('registros', cliente.registros);
    _prefs.setInt('puntos', cliente.puntos);
    _prefs.setInt('direcciones', cliente.direcciones);
    _prefs.setInt('correctos', cliente.correctos);
    _prefs.setInt('canceladas', cliente.canceladas);
    _prefs.setString('fechaNacimiento', cliente.fechaNacimiento);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

 set direccionModel(DireccionModel direccion) {
  if (_prefs != null) {
    _prefs.setInt('idDireccion', direccion.idDireccion);
    _prefs.setDouble('lt', direccion.lt);
    _prefs.setDouble('lg', direccion.lg);
    _prefs.setString('direccion', direccion.alias.toString());
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set idCliente(String value) {
  if (_prefs != null) {
    _prefs.setString('idCliente', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set uuid(String value) {
  if (_prefs != null) {
    _prefs.setString('uuid', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set imei(String value) {
  if (_prefs != null) {
    _prefs.setString('imei', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set token(String value) {
  if (_prefs != null) {
    _prefs.setString('token', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set empezamos(bool value) {
  if (_prefs != null) {
    _prefs.setBool('empezamos', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set idUrbe(String value) {
  if (_prefs != null) {
    _prefs.setString('idUrbe', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set alias(String value) {
  if (_prefs != null) {
    _prefs.setString('alias', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set idAgencia(String value) {
  if (_prefs != null) {
    _prefs.setString('idAgencia', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set simCountryCode(String value) {
  if (_prefs != null) {
    _prefs.setString('simCountryCode', value.toUpperCase());
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set rastrear(bool value) {
  if (_prefs != null) {
    _prefs.setBool('rastrear', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

set optimizado(bool value) {
  if (_prefs != null) {
    _prefs.setBool('optimizado', value);
  } else {
    print("Error: SharedPreferences no está inicializado.");
  }
}

}
