import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class IntentShare {
  static IntentShare _instancia;

  StreamSubscription _intentDataStreamSubscription;
  String _intentShare = '';

  final intentStreamController = StreamController<String>.broadcast();

  Function(String) get intentSink => intentStreamController.sink.add;

  Stream<String> get intentStream => intentStreamController.stream;

  IntentShare._internal();

  factory IntentShare() {
    if (_instancia == null) {
      _instancia = IntentShare._internal();
    }
    return _instancia;
  }

  void initIntentShare() async {
    try {
      _intentDataStreamSubscription =
          ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> files) {
// Si estás interesado en el texto compartido, puedes procesarlo aquí
// Por ejemplo, filtrar archivos de texto de la transmisión
            var textFiles = files.where((file) => file.type == SharedMediaType.text);

            if (textFiles.isNotEmpty) {
// Procesar el primer archivo de texto (asumiendo que solo se comparte un archivo de texto)
              var textFile = textFiles.first;
              var textContent = textFile.path; // Suponiendo que la ruta contiene el contenido del texto

              intentSink('');
              _intentShare = textContent;
              intentSink(_intentShare);
            }
          }, onError: (err) {
            print("getMediaStream error: $err");
          });

// Manejar opcionalmente el texto inicial
      ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> files) {
        var textFiles = files.where((file) => file.type == SharedMediaType.text);

        if (textFiles.isNotEmpty) {
          var textFile = textFiles.first;
          var textContent = textFile.path;

          intentSink('');
          _intentShare = textContent;
          intentSink(_intentShare);
        }
      });
    } catch (err) {
      print("initIntentShare error: $err");
    }
  }

  String get intentShare => _intentShare;

  set intentShare(value) => _intentShare = value;

  void disposeStreams() {
    intentStreamController?.close();
    _intentDataStreamSubscription?.cancel();
  }
}
