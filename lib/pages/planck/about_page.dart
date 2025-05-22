import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/button.dart' as btn;
import '../../utils/personalizacion.dart' as prs;
import '../../utils/utils.dart' as utils;

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  _AboutPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
        leading: utils.leading(context),
      ),
      body:
          Center(child: Container(child: _body(), width: prs.anchoFormulario)),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Expanded(child: SingleChildScrollView(child: _contenido())),
        btn.confirmar('HECHO EN BOLIVIA', () {
          _launchURL('https://sacaba.rantybolivia.com/instalar/');
        }),
      ],
    );
  }

  Column _contenido() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 35.0),
              GestureDetector(
                onTap: () {
                  _source();
                },
                child: Image.asset("assets/icon_.png", height: 270),
              ),
              const Text(
                "Este software se distribuye bajo licencia MIT. Está disponible en https://sacaba.rantybolivia.com/instalar/ ",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              btn.bootonIcon('Source code', Icon(Icons.download), _source),
              SizedBox(height: 20.0),
              btn.booton('Política de privacidad', _politicas),
              SizedBox(height: 20.0),
              btn.booton('Términos y condiciones', _terminos),
              SizedBox(height: 80.0),
            ],
          ),
        ),
      ],
    );
  }

  _source() {
    _launchURL('https://sacaba.rantybolivia.com/instalar/');
  }

  _politicas() {
    _launchURL('https://sacaba.rantybolivia.com/instalar/');
  }

  _terminos() {
    _launchURL('https://sacaba.rantybolivia.com/instalar/');
  }

  _launchURL(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication))
      throw 'Could not launch $_url';
  }
}
