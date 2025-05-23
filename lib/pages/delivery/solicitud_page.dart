import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../bloc/card_bloc.dart';
import '../../dialog/carrito_dialog.dart';
import '../../dialog/mapa_dialog.dart';
import '../../model/cajero_model.dart';
import '../../model/card_model.dart';
import '../../model/catalogo_model.dart';
import '../../model/direccion_model.dart';
import '../../model/promocion_model.dart';
import '../../preference/shared_preferences.dart';
import '../../providers/cajero_provider.dart';
import '../../providers/compra_provider.dart';
import '../../providers/mapa_provider.dart';
import '../../sistema.dart';
import '../../utils/button.dart' as btn;
import '../../utils/conf.dart' as conf;
import '../../utils/conf.dart' as config;
import '../../utils/decode.dart' as decode;
import '../../utils/dialog.dart' as dlg;
import '../../utils/marker.dart' as marker;
import '../../utils/permisos.dart' as permisos;
import '../../utils/personalizacion.dart' as prs;
import '../../utils/utils.dart' as utils;
import '../delivery/catalogo_page.dart';

class SolicitudPage extends StatefulWidget {
  final CatalogoModel catalogoModel;
  final double lt, lg;
  final int pagina;

  SolicitudPage(this.lt, this.lg,
      {Key key, this.catalogoModel, this.pagina = 0})
      : super(key: key);

  @override
  State<SolicitudPage> createState() => SolicitudPageState(
      catalogoModel: catalogoModel, latitud: lt, longitud: lg, pagina: pagina);
}

class SolicitudPageState extends State<SolicitudPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final PreferenciasUsuario _prefs = PreferenciasUsuario();
  final MapaProvider _mapaProvider = MapaProvider();
  final TextEditingController _typeAheadController = TextEditingController();

  DireccionModel direccionModel = DireccionModel();
  final CatalogoModel catalogoModel;

  double latitud;
  double longitud;
  int pagina;

  SolicitudPageState(
      {this.catalogoModel, this.latitud, this.longitud, this.pagina});

  final Set<Marker> _markers = Set<Marker>();

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-17.403783, -66.040074), zoom: 20);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _initUbicar();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isLocalizado = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      default:
        break;
    }
  }

  Marker markerDesde;
  Marker markerHasta;

  _initUbicar() async {
    if (direccionModel.idDireccion != null) {
      markerDesde =
          Marker(position: LatLng(latitud, longitud), markerId: MarkerId('A'));
      _markers.add(markerDesde);

      markerHasta =
          Marker(position: LatLng(latitud, longitud), markerId: MarkerId('B'));
      _markers.add(markerHasta);

      _cameraPosition = CameraPosition(
          target: LatLng(latitud, longitud),
          zoom: latitud == Sistema.lt && longitud == Sistema.lg ? 7 : 15);
    } else {
      _moverCamaraMapa(latitud, longitud);
    }
    direccionModel.lt = latitud;
    direccionModel.lg = longitud;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // leading: utils.leading(context),
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          '${catalogoModel.agencia}',
          overflow: TextOverflow.clip,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: _contenido(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _localizar,
            child: prs.iconoLocationCentro,
            shape: CircleBorder(),
            elevation: 10.0,
            fillColor: prs.colorButtonBackground,
            padding: const EdgeInsets.all(10.0),
          ),
          SizedBox(height: 100.0),
        ],
      ),
    );
  }

  bool _isLineProgress = false;

  Container _contenido() {
    return Container(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            minMaxZoomPreference: MinMaxZoomPreference(1, 20),
            mapType: MapType.normal,
            initialCameraPosition: _cameraPosition,
            compassEnabled: true,
            myLocationEnabled: true,
            indoorViewEnabled: true,
            tiltGesturesEnabled: true,
            myLocationButtonEnabled: true,
            onCameraMove: (CameraPosition cameraPosition) {
              _typeAheadController.text = '';
              direccionModel.lt = cameraPosition.target.latitude;
              direccionModel.lg = cameraPosition.target.longitude;
              _prefs.direccionModel = direccionModel;
            },
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Center(child: prs.iconoLocationCentro),
          Visibility(
              visible: _isLineProgress,
              child: LinearProgressIndicator(
                  backgroundColor: prs.colorLinearProgress)),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(1.0),
              color: Colors.white,
              child: createExpanPanel(context),
            ),
          ),
          direccionRecogida == null
              ? Positioned(
                  bottom: 10.0,
                  child: btn.confirmar(
                      'ESTABLECER PUNTO de RECOGIDA', _confirmarPuntoRecogida,
                      color: Colors.green))
              : Positioned(
                  bottom: 10.0,
                  child: SpinPerfect(
                      child: btn.confirmar(
                          'UBICA y CONFIRMA tu DESTINO', _confirmarDireccion)),
                ),
          direccionRecogida == null
              ? Container()
              : Positioned(
                  right: 10.0,
                  top: 80.0,
                  child: FadeInDown(
                    delay: Duration(seconds: 2),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(10.0))),
                        child: Icon(Icons.arrow_back),
                        onPressed: _limpiar),
                  )),
        ],
      ),
    );
  }

  DireccionModel direccionRecogida;
  DireccionModel direccionDestino;

  _limpiar() async {
    direccionRecogida = null;
    direccionDestino = null;
    _markers.remove(markerHasta);
    _markers.remove(markerDesde);
    if (mounted) setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        'Por favor ubica en el mapa tu punto de recogida',
        style: TextStyle(color: Colors.white),
      ),
    ));
  }

  _confirmarPuntoRecogida() async {
    if (_prefs.isExplorar) return utils.registrarse(context, _scaffoldKey);

    direccionDestino = null;

    direccionRecogida =
        DireccionModel(lt: direccionModel.lt, lg: direccionModel.lg);

    _markers.remove(markerDesde);

    final Uint8List ingreso = await marker.getBytesFromCanvas(
        "assets/pool/ingreso_0.png", _prefs.clienteModel.acronimo);
    var imagIngreso = BitmapDescriptor.fromBytes(ingreso);

    markerDesde = Marker(
        infoWindow: InfoWindow(title: '${_prefs.clienteModel.nombres}'),
        markerId: MarkerId('A'),
        icon: imagIngreso,
        position: LatLng(direccionModel.lt, direccionModel.lg));

    _markers.add(markerDesde);

    if (mounted) setState(() {});
  }

  Widget createExpanPanel(BuildContext context) {
    return InkWell(
      onTap: _mostrarDirecciones,
      child: TextFormField(
        enabled: false,
        controller: this._typeAheadController,
        decoration:
            prs.decoration('Buscar un lugar cerca de ⤵️', prs.iconoBuscar),
      ),
    );
  }

  _mostrarDirecciones() async {
    showDialog(
        context: context,
        builder: (context) {
          return MapaDialog(
              _onSelectMapa, direccionModel.lt, direccionModel.lg);
        });
  }

  _onSelectMapa(suggestion) {
    Navigator.pop(context);
    this._typeAheadController.text = suggestion['main'];
    _consultarPosision(
        suggestion['place_id'], suggestion['main'], suggestion['secondary']);
  }

  _consultarPosision(String placeId, String main, String secondary) async {
    FocusScope.of(context).requestFocus(FocusNode());

    utils.mostrarRadar(context);
    var local = await _mapaProvider.localizar(placeId, main, secondary);
    if (local.length > 0) {
      double lt = local['lat'];
      double lg = local['lng'];
      _moverCamaraMapa(lt, lg);
    } else {
      utils.mostrarSnackBar(context, 'Lugar $main no localizada',
          milliseconds: 3000);
    }
    Navigator.pop(context);
  }

  bool _saving = false;

  _localizar() async {
    if (_saving) return;
    isLocalizado = await permisos.localizar(context, _moverCamaraMapa);
  }

  _update(mensaje) {
    _saving = true;
    if (mounted) setState(() {});
  }

  _complet() {
    _saving = false;
    if (mounted) if (mounted) setState(() {});
  }

  List<CajeroModel> cajeros = [];
  final CajeroProvider _cajeroProvider = CajeroProvider();


///////////////////////////////////////////////////////////////////////////////////////////

void _confirmarDireccion() async {
  // Remueve el marcador de destino si ya existe
  _markers.remove(markerHasta);
  
  // Verifica si está en modo exploración
  if (_prefs.isExplorar) {
    return utils.registrarse(context, _scaffoldKey);
  }
  
  // Asigna las coordenadas de la dirección de destino
  direccionDestino = DireccionModel(lt: direccionModel.lt, lg: direccionModel.lg);

  

  // Actualiza el marcador en la posición de destino
  final Uint8List ingreso = await marker.getBytesFromCanvas("assets/pool/salida_0.png", _prefs.clienteModel.acronimo);
  var imagIngreso = BitmapDescriptor.fromBytes(ingreso);
  markerHasta = Marker(
    infoWindow: InfoWindow(title: '${_prefs.clienteModel.nombres}'),
    markerId: MarkerId('B'),
    icon: imagIngreso,
    position: LatLng(direccionModel.lt, direccionModel.lg)
  );
  _markers.add(markerHasta);

  // Muestra un mensaje de progreso
  _update('Consultando costo');
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Recupera el idAgencia
  final idAgencia = catalogoModel.idAgencia;

  // Si idAgencia es una lista, conviértelo a lista de Strings
  List<String> agencias;
  if (idAgencia is List) {
    agencias = LinkedHashSet<String>.from(idAgencia.map((id) => id.toString())).toList();
  } else {
    // Si idAgencia es un solo valor, conviértelo a una lista con un solo elemento
    agencias = [idAgencia.toString()];
  }

  // Convierte la lista en una cadena CSV
  String agenciasCSV = agencias.join(',');

  // Llama al método verCostoPromocion
  cajeros = await _cajeroProvider.verCostoPromocion(
    conf.COMPRA_TIPO_ENCOMIENDA,
    direccionRecogida,
    agenciasCSV,
    '1',
    direccionCliente: direccionDestino,
  );

  // Completa la acción y oculta el indicador de progreso
  _complet();

  // Verifica si no hay cajeros disponibles
  if (cajeros.length <= 0) {
    _fAceptar() {
      _complet();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => CatalogoPage()), 
        (Route<dynamic> route) => false,
      );
    }
    dlg.mostrar(context, config.MENSAJE_FUERA_DE_HORARIO, fIzquierda: _fAceptar);
    return;
  }

  // Inicializa el costo total
  double costoTotal = 0.0;

  // Declara las variables fuera del setState
double distanciaAgencia = 0.0;
double distanciaSucursal = 0.0;

setState(() {
  for (var cajero in cajeros) {
    if (cajero.ltAgencia == null || cajero.lgAgencia == null || cajero.ltSucursal == null || cajero.lgSucursal == null) {
      print('Coordenadas faltantes para el cajero. Saltando este cajero.');
      continue; // Salta al siguiente cajero en la lista
    }

    final ltAgencia = cajero.ltAgencia;
    final lgAgencia = cajero.lgAgencia;
    final ltSucursal = cajero.ltSucursal;
    final lgSucursal = cajero.lgSucursal;

    if (direccionRecogida.lt == null || direccionRecogida.lg == null) {
      print('Coordenadas de la dirección de recogida faltantes.');
      return dlg.mostrar(context, 'No se puede calcular la distancia debido a datos incompletos.');
    }

    // Calcula las distancias y asigna a las variables declaradas afuera
    distanciaAgencia = decode.getKilometrosagen(
      ltAgencia.toDouble(),
      lgAgencia.toDouble(),
      direccionRecogida.lt.toDouble(),
      direccionRecogida.lg.toDouble(),
    );

    distanciaSucursal = decode.getKilometrosagen(
      ltSucursal.toDouble(),
      lgSucursal.toDouble(),
      direccionRecogida.lt.toDouble(),
      direccionRecogida.lg.toDouble(),
    );

    print('Distancia a la agencia: $distanciaAgencia km');
    print('Distancia a la sucursal: $distanciaSucursal km');

    // Suma el costo del envío de cada cajero
    costoTotal += cajero.costoEnvio;
  }
});

// Después del setState puedes usar las variables
if (distanciaAgencia > 10 || distanciaSucursal > 10) {
  return dlg.mostrar(context, 'Lo sentimos, no cubrimos esa zona');
} else if (direccionDestino.lt == direccionRecogida.lt && direccionDestino.lg == direccionRecogida.lg) {
  return dlg.mostrar(context, 'La direccion de recogida no puede ser la misma que tu destino, por favor ubica en el mapa tu lugar de destino');
} else if (decode.getKilometros(direccionDestino.lt, direccionDestino.lg, direccionRecogida.lt, direccionRecogida.lg) < 50) {
  return dlg.mostrar(context, 'Los viajes deben ser mayores a 50 metros');
}
  // Actualiza el estado del pago
  _cardBloc.actualizar(CardModel(
    modo: Sistema.EFECTIVO,
    number: Sistema.EFECTIVO,
    type: Sistema.EFECTIVO,
    holderName: 'Pagar en efectivo'
  ));

  // Muestra el diálogo del carrito
  direccionDestino.alias = 'Ubicación en mapa';
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return CarritoDialog(
        conf.COMPRA_TIPO_ENCOMIENDA,
        promocion: PromocionModel(producto: ''),
        cajeros: cajeros,
        costoTotal: costoTotal,
        direccionSeleccionadaCliente: direccionRecogida,
        direccionSeleccionadaEntrega: direccionDestino,
        compraProvider: _compraProvider,
      );
    },
  );
}


  indexEnProcesoLimpiarMapa() {
    direccionRecogida = null;
    direccionDestino = null;
    _markers.remove(markerHasta);
    _markers.remove(markerDesde);
    if (mounted) setState(() {});
  }

  final CompraProvider _compraProvider = CompraProvider();
  final _cardBloc = CardBloc();

  Future<void> _moverCamaraMapa(double lt, double lg) async {
    final GoogleMapController controller = await _controller.future;
    _cameraPosition = CameraPosition(target: LatLng(lt, lg), zoom: 17.2);
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }
}
