import '../utils/cache.dart' as cache;

class CatalogoModel {
  String link = '';
  dynamic idAgencia;
  dynamic idUrbe;
  dynamic idPromocion; //Promocion que se agrego por link profundo
  bool isPay;
  String agencia;
  String direccion;
  String observacion;
  String img;
  String label;
  String contacto;
  int resta;
  int tipo;
  int like;
  String hasta;
  String abiero;
  double lt;
  double lg;
    // Nuevas propiedades
  dynamic ltSucursal;
  dynamic lgSucursal;
  dynamic ltAgencia;
  dynamic lgAgencia;

  CatalogoModel({
    this.isPay = false,
    this.label = '',
    this.idPromocion = '0',
    this.idAgencia = 0,
    this.idUrbe,
    this.agencia,
    this.direccion,
    this.observacion,
    this.img,
    this.contacto,
    this.resta,
    this.tipo = 1,
    this.like = 0,
    this.hasta,
    this.abiero = '1',
      this.lt = 0.0,
      this.lg = 0.0,


    this.ltSucursal = 0.0,
    this.lgSucursal = 0.0,
    this.ltAgencia = 0.0,
    this.lgAgencia = 0.0,
    
  });

  factory CatalogoModel.fromJson(Map<String, dynamic> json) => CatalogoModel(
        isPay: json["isPay"] == null
            ? false
            : int.parse(json["isPay"]?.toString()) == 1,
        label: json["label"],
        idAgencia: json["id_agencia"],
        idUrbe: json["id_urbe"],
        agencia: json["agencia"],
        direccion: json["direccion"],
        tipo: json["tipo"] == null ? 1 : int.parse(json["tipo"]?.toString()),
        like: json["like"] == null ? 0 : int.parse(json["like"]?.toString()),
        observacion: json["observacion"],
        img: cache.img(json["img"]),
        contacto: json["contacto"],
        resta: json["resta"],
        hasta: json["hasta"],
        abiero: json["abiero"].toString(),
        lt: json["lt"] == null ? 0.0 : json["lt"].toDouble(),
        lg: json["lg"] == null ? 0.0 : json["lg"].toDouble(),
        ltSucursal: json['lt_sucursal'] == null ? 0.0 : json["lt_sucursal"].toDouble(),
        lgSucursal: json['lg_sucursal'] == null ? 0.0 : json["lg_sucursal"].toDouble(),
        ltAgencia:  json['lt_agencia']  == null ? 0.0 : json["lt_agencia"].toDouble(),
        lgAgencia:  json['lg_agencia']  == null ? 0.0 : json["lg_agencia"].toDouble(),
     

      );

  Map<String, dynamic> toJson() => {
        "id_agencia": idAgencia,
        "id_urbe": idUrbe,
        "agencia": agencia,
        "direccion": direccion,
        "observacion": observacion,
        "img": img,
        "tipo": tipo,
        "like": like,
        "contacto": contacto,
        "resta": resta,
        "hasta": hasta,
        "abiero": abiero,
        "lt": lt,
        "lg": lg,
                    'lt_sucursal': ltSucursal,
            'lg_sucursal': lgSucursal,
            'lt_agencia': ltAgencia,
            'lg_agencia': lgAgencia,
      };
}
