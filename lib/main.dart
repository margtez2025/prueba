import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:permission_handler/permission_handler.dart';

import './sistema.dart';
import './utils/permisos.dart' as permisos;
import './utils/personalizacion.dart' as prs;
import './utils/utils.dart' as utils;
import 'firebase_options.dart'; // archivo generado con flutterfire configure
import 'pages/admin/agencia_page.dart';
import 'pages/admin/compras_cajero_page.dart';
import 'pages/admin/sucursales_page.dart';
import 'pages/admin/ventas_page.dart';
import 'pages/delivery/carrito_page.dart';
import 'pages/delivery/catalogo_page.dart';
import 'pages/delivery/compras_cliente_page.dart';
import 'pages/delivery/compras_despacho_page.dart';
import 'pages/planck/about_page.dart';
import 'pages/planck/contacto_page.dart';
import 'pages/planck/contrasenia_page.dart';
import 'pages/planck/direcciones_page.dart';
import 'pages/planck/facturas_page.dart';
import 'pages/planck/notificacion_page.dart';
import 'pages/planck/perfil_page.dart';
import 'pages/planck/preregistro_page.dart';
import 'pages/planck/puntos_page.dart';
import 'pages/planck/registrar_page.dart';
import 'pages/planck/sessiones_page.dart';
import 'preference/intent_share.dart';
import 'preference/push_provider.dart';
import 'preference/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activar App Check en toda la aplicación
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,

  );
  await PreferenciasUsuario().init();
  final prefs = PreferenciasUsuario();
  await utils.getDeviceDetails();
  IntentShare().initIntentShare();


  // // Instancia y ejecuta AppCheckService
  // AppCheckService(); // <-- Instancia directamente sin asignar a ninguna variable

  // Inicializa PushProvider y pásalo a MyApp
  final pushProvider = PushProvider();

  if (prefs.idCliente == '' || prefs.idCliente == Sistema.ID_CLIENTE) {
    await permisos.ingresar();
  }

  // Solicitar permisos
  await solicitarPermisos();

  try {
    prefs.simCountryCode = (await FlutterSimCountryCode.simCountryCode)!;
  } catch (exception) {
    print('page: main.dart catch $exception');
    prefs.simCountryCode = 'BO';
  }

  runApp(MyApp(pushProvider));
}

Future<void> solicitarPermisos() async {
  // Solicitar permiso para notificaciones
  PermissionStatus notificacionesStatus = await Permission.notification.request();
  if (notificacionesStatus.isGranted) {
    print('Permiso para notificaciones concedido');
  } else {
    print('Permiso para notificaciones denegado');
  }

  // Nota: `permission_handler` no gestiona permisos de mensajes SMS directamente.
  // Si necesitas permisos para SMS, tendrás que usar otra biblioteca o manejarlo de manera personalizada.
}

class MyApp extends StatefulWidget {
  final PushProvider pushProvider;

  MyApp(this.pushProvider); // Recibir PushProvider como parámetro

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    // Aquí puedes usar widget.pushProvider si necesitas realizar alguna operación inicial
    widget.pushProvider.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    String ruta = 'catalogo';
    if (_prefs.auth == '') {
      ruta = 'principal';
    } else if (_prefs.clienteModel.perfil == '0') {
      ruta = 'catalogo';
    } else if (_prefs.clienteModel.perfil == '1') {
      ruta = 'compras_cajero';
    } else if (_prefs.clienteModel.perfil == '2') {
      ruta = 'compras_despacho';
    } else {
      ruta = 'catalogo';
    }
    print(Sistema.DOMINIO_GLOBAL);

    return MaterialApp(
      title: Sistema.aplicativoTitle,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('es', 'ES')],
      locale: Locale('es', 'ES'),
      initialRoute: ruta,
      debugShowCheckedModeBanner: Sistema.isTestMode,
      routes: {
        '': (BuildContext context) => CatalogoPage(),
        'principal': (BuildContext context) => RegistrarPage(),
        'registrar': (BuildContext context) => RegistrarPage(),
        'compras_cliente': (BuildContext context) => ComprasClientePage(),
        'direcciones_cliente': (BuildContext context) => DireccionesPage(),
        'facturas_cliente': (BuildContext context) => FacturasPage(),
        'carrito': (BuildContext context) => CarritoPage(),
        'compras_cajero': (BuildContext context) => ComprasCajeroPage(),
        'compras_despacho': (BuildContext context) => ComprasDespachoPage(),
        'contrasenia': (BuildContext context) => ContraseniaPage(),
        'perfil': (BuildContext context) => PerfilPage(),
        'contacto': (BuildContext context) => ContactoPage(),
        'puntos': (BuildContext context) => PuntosPage(),
        'sessiones': (BuildContext context) => SessionesPage(),
        'about': (BuildContext context) => AboutPage(),
        'sucursales': (BuildContext context) => SucursalesPage(),
        'catalogo': (BuildContext context) => CatalogoPage(isDeeplink: true),
        'preregistro': (BuildContext context) => PreRegistroPage(),
        'ventas': (BuildContext context) => VentasPage(),
        'agencia': (BuildContext context) => AngenciaPage(),
        'notificacion': (BuildContext context) => NotificacionPage(),
      },
      theme: ThemeData(
        primaryColor: prs.colorAppBar,
        appBarTheme: AppBarTheme(
          elevation: 0.7,
          centerTitle: true,
          color: prs.colorAppBar,
        ),
      ),
    );
  }
}
