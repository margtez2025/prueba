import 'dart:io';

import 'package:universal_platform/universal_platform.dart';

class Sistema {
  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  //OJO esta IP http://10.0.2.2/ es util para quienes estan levantando el servidor de recursos en la misma maquina donde tambien
  //Estan corriendo el APP en el emulador dejo link para mas detalles https://stackoverflow.com/questions/6760585/accessing-localhostport-from-android-emulator
  //static const String DOMINIO_GLOBAL = 'http://192.168.1.12:8080/';
  static const String DOMINIO_GLOBAL = 'https://api.rantybolivia.com/';
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  static const int MINUMUN_VERSION = 0;

  static const String ID_CLIENTE = '100050';
  static String idUuid = '100050-GV@TXP5S&CI3RC020EWWTQYT7-2-1000001/JP';
  static const String AUTH_CLIENTE = '/LKHJGASLJKHG/97647/LKHGJH/LKGJLH';

  static const String SEARCH_MENSJAE = '¿Que te gustaría comer hoy?';



      static const String MESAJE_SHARE_LINK = '''\n
      Descarga gratis Ranty y encuentra promociones exclusivas.\n\
               *RANTY*
          ⭐⭐⭐⭐⭐\n\
       Únete a la revolución
                 Digital.\n\
         Solicita tu Registro al 
             ☎️WhatsApp
              591 70394937

''';


  static const String MESAJE_CATALOGO =
      'Registra la dirección donde \n\enviaremos tu compra.';

  static const bool ID_VERIFICAR_URBE = true;
  static const bool IS_BACKGROUND = true;
  static const String ID_URBE = '1';

  static const int TARGET_WIDTH_PERFIL = 400;
  static const int TARGET_WIDTH_CHAT = 600;
  static const int TARGET_WIDTH_PROMO = 800;

  static const int IS_ACREDITADO = 200;
  static const int IS_TOKEN = 300;

  static const String EFECTIVO = 'Efectivo';
  static const String TARJETA = 'Tarjeta';
  static const String ID_FOMRA_PAGO_TARJETA = '23';
  static const String CUPON = 'Cupón';

  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  static bool isTestMode = false;
  static const String MENSAJE_NUEVA_CAR = ''; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  static const String CLIENT_APP_CODE = ""; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  static const String CLIENTE_APP_KEY = ""; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  static const sloganCuriosity =
      'RANTY, para las personas que quieren más.';
  static const aplicativoCuriosity= 'RANTY';
  static const idAplicativoCuriosity = 1000001;
  static const aplicativoTitleCuriosity = 'Ranty';
  static const packageNameCuriosity = 'com.sacaba.rantyboliviaa';
  static const appStoreIdCuriosity = '1488624281';



  static const uriDynamicCuriosity = 'https://sacaba.rantybolivia.com/instalar';


  //https://sacaba.apk.rantybolivia.com/curiosity/6eZ4

  static const double lt = -17.403783;
  static const double lg = -66.040074;

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  static const _aplicativo = aplicativoCuriosity;
  static const _idAplicativo = idAplicativoCuriosity;
  static const _packageName = packageNameCuriosity;
  static const _appStoreId = appStoreIdCuriosity;
  static const _slogan = sloganCuriosity;
  static const _uriDynamic = uriDynamicCuriosity;
  static const aplicativoTitle = aplicativoTitleCuriosity;

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  static String get dominio => DOMINIO_GLOBAL;

  static String get slogan => _slogan;

  static String get aplicativo => _aplicativo;

  static int get idAplicativo => _idAplicativo;

  static get storage => 'https://firebasestorage.googleapis.com/v0/b/';

  static get uriPrefix =>

      'https://sacaba.apk.rantybolivia.com/instalar'; //La barra al final causa problemas en iOS
 
  static get uriDynamic => _uriDynamic;

  static get packageName => _packageName;

  static get appStoreId => _appStoreId; //bundleId

  static get isAndroid => UniversalPlatform.isAndroid;

  static get isIOS => UniversalPlatform.isIOS;

  static get isWeb => UniversalPlatform.isWeb;

  String operatingSystem() {
    return (Sistema.isAndroid
            ? Platform.operatingSystem
            : Sistema.isIOS
                ? Platform.operatingSystem
                : 'WEB')
        .toString();
  }
}
