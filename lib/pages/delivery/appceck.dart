// //chat gpt
// import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// import '../../model/cliente_model.dart';
// import '../../preference/shared_preferences.dart';
// import '../../providers/cliente_provider.dart';
// import '../../utils/dialog.dart' as dlg;
// import '../../utils/utils.dart' as utils;

// class VerificarCelularPage extends StatefulWidget {
//   final Function accionConfirmacion;

//   VerificarCelularPage(this.accionConfirmacion, {Key key}) : super(key: key);

//   @override
//   State<VerificarCelularPage> createState() => _VerificarCelularPageState(this.accionConfirmacion);
// }

// class _VerificarCelularPageState extends State<VerificarCelularPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final ClienteProvider _clienteProvider = ClienteProvider();
  
//   ClienteModel cliente = ClienteModel();
//   bool isCelularValido = true;
//   final TextEditingController _typeControllerCode = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _solicitarCodigo;
//   final prefs = PreferenciasUsuario();
//   Function accionConfirmacion;
//   bool _saving = false;
//   String _eventToken = 'Token aún no obtenido';

//   _VerificarCelularPageState(this.accionConfirmacion);

//   @override
//   void initState() {
//     _solicitarCodigo = prefs.sms == '';
//     cliente = prefs.clienteModel;
//     super.initState();

//     // Activa App Check y escucha los cambios en el token de forma automática
//     FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.playIntegrity);
//     FirebaseAppCheck.instance.onTokenChange.listen(setEventToken);
//   }

//   // Asigna el token de App Check cuando cambia
//   void setEventToken(String token) {
//     setState(() {
//       _eventToken = token ?? 'Token no disponible';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(title: Text('Verificar celular')),
//         key: _scaffoldKey,
//         body: ModalProgressHUD(
//           color: Colors.black,
//           opacity: 0.4,
//           progressIndicator: utils.progressIndicator('Verificando'),
//           inAsyncCall: _saving,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 //_contenido(),
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     children: [
//                       Text('Estado del token: $_eventToken'), // Estado del token actual
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _verifyPhoneNumber() async {
//     final User currentUser = _auth.currentUser;
//     if (currentUser?.phoneNumber == cliente.celular.toString()) {
//       print('verificationCompleted for current');
//       _clienteProvider.validadCelular(cliente.celular);
//       prefs.solicitados = 0;
//       accionConfirmacion();
//       return;
//     }

//     final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {
//       print('verificationCompleted');
//       _auth.signInWithCredential(phoneAuthCredential);
//       _clienteProvider.validadCelular(cliente.celular);
//       prefs.solicitados = 0;
//       accionConfirmacion();
//     };

//     final PhoneVerificationFailed verificationFailed = (authException) {
//       print('verificationFailed');
//       dlg.mostrar(context, 'Hemos bloqueado todas las solicitudes de este dispositivo debido a una actividad inusual. Intentá nuevamente más tarde.', mIzquierda: 'ACEPTAR');
//     };

//     final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
//       print('codeSent');
//       prefs.solicitados++;
//       prefs.sms = verificationId;
//       _solicitarCodigo = false;
//       _saving = false;
//       if (mounted) setState(() {});
//     };

//     final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
//       prefs.sms = verificationId;
//     };

//     await _auth.verifyPhoneNumber(
//       phoneNumber: cliente.celular.toString(),
//       timeout: const Duration(seconds: 35),
//       verificationCompleted: verificationCompleted,
//       verificationFailed: verificationFailed,
//       codeSent: codeSent,
//       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//     );
//   }

//   void _signInWithPhoneNumber() async {
//     if (_typeControllerCode.text.length < 6) return;

//     _saving = true;
//     if (mounted) setState(() {});

//     final AuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: prefs.sms,
//       smsCode: _typeControllerCode.text,
//     );

//     await _auth.signInWithCredential(credential).then((user) {
//       _saving = false;
//       _clienteProvider.validadCelular(cliente.celular);
//       prefs.solicitados = 0;
//       accionConfirmacion();
//     }).catchError((error) {
//       _saving = false;
//       if (mounted) setState(() {});
//       dlg.mostrar(context, 'Código incorrecto o caducado. Inténtalo de nuevo.', mIzquierda: 'CORREGIR');
//     });
//   }

//   // Widgets y contenido adicional...

// }
