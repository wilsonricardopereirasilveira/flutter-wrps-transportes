import 'dart:math';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

enum EstadoEntrega {
  EntregasRealizadas,
  EntregasFalhas,
  EntregasEmCurso,
  EntregaParcial
}

class Oferta {
  String data;
  String hora;
  LatLng origem;
  LatLng destino;
  double toneladas;
  double metrosCubicos;
  int container;
  String descricao;
  String tipoEmbalagem;
  String tipoCarga;
  String tipoVeiculo;
  String codigoRota;
  String placaCaminhao;
  EstadoEntrega estadoEntrega;
  String nomeMotorista;
  String telefoneMotorista;

  Oferta({
    required this.data,
    required this.hora,
    required this.origem,
    required this.destino,
    required this.toneladas,
    required this.metrosCubicos,
    required this.container,
    required this.descricao,
    required this.tipoEmbalagem,
    required this.tipoCarga,
    required this.tipoVeiculo,
    required this.codigoRota,
    required this.placaCaminhao,
    required this.estadoEntrega,
    required this.nomeMotorista,
    required this.telefoneMotorista,
  });

  @override
  String toString() {
    return 'Oferta(data: $data, hora: $hora, origem: $origem, destino: $destino, toneladas: $toneladas, metrosCubicos: $metrosCubicos, container: $container, descricao: $descricao, tipoEmbalagem: $tipoEmbalagem, tipoCarga: $tipoCarga, tipoVeiculo: $tipoVeiculo, codigoRota: $codigoRota, placaCaminhao: $placaCaminhao, estadoEntrega: $estadoEntrega, nomeMotorista: $nomeMotorista, telefoneMotorista: $telefoneMotorista)';
  }

  static List<Oferta> generateFakeData() {
    Random random = Random();
    int count = random.nextInt(21) + 30; // Número aleatório entre 30 e 50
    List<Oferta> ofertas = [];

    for (int i = 0; i < count; i++) {
      DateTime now = DateTime.now();
      DateTime randomDate = now.subtract(Duration(days: random.nextInt(16)));
      String data = DateFormat('dd/MM/yyyy').format(randomDate);

      String hora =
          '${random.nextInt(24).toString().padLeft(2, '0')}:${random.nextInt(60).toString().padLeft(2, '0')}';

      // Gerar coordenadas de latitude e longitude aleatórias para o Brasil
      LatLng origem = LatLng(
        -34.0 + random.nextDouble() * 14.0, // Latitude entre -34 e -20
        -74.0 + random.nextDouble() * 28.0, // Longitude entre -74 e -46
      );
      LatLng destino = LatLng(
        -34.0 + random.nextDouble() * 14.0,
        -74.0 + random.nextDouble() * 28.0,
      );

      double toneladas = random.nextDouble() * 29 + 1; // Valor entre 1 e 30
      double metrosCubicos =
          random.nextDouble() * 20 + 10; // Valor entre 10 e 30
      int container = random.nextInt(50) + 1; // Valor entre 1 e 50

      List<String> embalagens = ['Caixa', 'Palete', 'Container'];
      String tipoEmbalagem = embalagens[random.nextInt(embalagens.length)];

      List<String> cargas = ['Alimentos', 'Eletrônicos', 'Móveis'];
      String tipoCarga = cargas[random.nextInt(cargas.length)];

      List<String> veiculos = ['Caminhão', 'Van', 'Carreta'];
      String tipoVeiculo = veiculos[random.nextInt(veiculos.length)];

      String codigoRota = (random.nextInt(90000000) + 10000000).toString();

      List<EstadoEntrega> estados = EstadoEntrega.values;
      EstadoEntrega estadoEntrega = estados[random.nextInt(estados.length)];

      ofertas.add(
        Oferta(
          data: data,
          hora: hora,
          origem: origem,
          destino: destino,
          toneladas: toneladas,
          metrosCubicos: metrosCubicos,
          container: container,
          descricao: 'Entrega de Carga',
          tipoEmbalagem: tipoEmbalagem,
          tipoCarga: tipoCarga,
          tipoVeiculo: tipoVeiculo,
          codigoRota: codigoRota,
          placaCaminhao: 'ABC-1234',
          estadoEntrega: estadoEntrega,
          nomeMotorista: 'José da Silva Santos',
          telefoneMotorista: '+55 (11) 12345-6789',
        ),
      );
    }

    return ofertas;
  }

  static List<Oferta> _cachedFakeData = [];

  static List<Oferta> get cachedFakeData {
    if (_cachedFakeData.isEmpty) {
      _cachedFakeData = generateFakeData();
    }
    return _cachedFakeData;
  }
}
