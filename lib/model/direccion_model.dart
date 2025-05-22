import '../utils/cache.dart' as cache;

class DireccionModel {
  dynamic idDireccion;
  dynamic idCliente;
  dynamic fechaRegistro;
  dynamic alias;
  dynamic referencia;
  dynamic lt;
  dynamic lg;
  dynamic idUrbe;
  String img;
    // Nuevas propiedades
  dynamic ltSucursal;
  dynamic lgSucursal;
  dynamic ltAgencia;
  dynamic lgAgencia;

  DireccionModel({

    this.ltSucursal = 0.0,
    this.lgSucursal = 0.0,
    this.ltAgencia = 0.0,
    this.lgAgencia = 0.0,
    this.idDireccion = -1,
    this.idCliente,
    this.fechaRegistro = 'Ahora',
    this.alias,
    this.referencia,
    this.lt = 0.0,
    this.lg = 0.0,
    this.idUrbe = 0,
    this.img,
  });

  factory DireccionModel.fromJson(Map<String, dynamic> json) => DireccionModel(
        idDireccion: json["id_direccion"],
        idCliente: json["id_cliente"],
        fechaRegistro: json["fecha_registro"],
        alias: json["alias"],
        referencia: json["referencia"],
        lt: json["lt"] == null ? 0.0 : json["lt"].toDouble(),
        lg: json["lg"] == null ? 0.0 : json["lg"].toDouble(),
        idUrbe: json["id_urbe"],
        img: cache.img(json["img"]),




        ltSucursal: json['lt_sucursal'] == null ? 0.0 : json["lt_sucursal"].toDouble(),
        lgSucursal: json['lg_sucursal'] == null ? 0.0 : json["lg_sucursal"].toDouble(),
        ltAgencia:  json['lt_agencia']  == null ? 0.0 : json["lt_agencia"].toDouble(),
        lgAgencia:  json['lg_agencia']  == null ? 0.0 : json["lg_agencia"].toDouble(),
     
      );

  Map<String, dynamic> toJson() => {
        "id_direccion": idDireccion,
        "id_cliente": idCliente,
        "fecha_registro": fechaRegistro,
        "alias": alias,
        "referencia": referencia,
        "lt": lt,
        "lg": lg,
        "id_urbe": idUrbe,
        "img": img,
        
  "lt_sucursal": ltSucursal,
  "lg_sucursal": lgSucursal,
  "lt_agencia": ltAgencia,
  "lg_agencia": lgAgencia,
      };
}
