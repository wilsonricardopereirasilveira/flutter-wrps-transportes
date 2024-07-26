import 'package:flutter/material.dart';
import 'package:website_transwrps/models/oferta.dart';
import 'package:website_transwrps/widgets/side_menu.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdemCompletaScreen extends StatefulWidget {
  final Oferta oferta;

  const OrdemCompletaScreen({super.key, required this.oferta});

  @override
  _OrdemCompletaScreenState createState() => _OrdemCompletaScreenState();
}

class _OrdemCompletaScreenState extends State<OrdemCompletaScreen> {
  List<LatLng> routePoints = [];
  double distance = 0.0;
  Duration travelTime = Duration.zero;
  String origemAddress = '';
  String destinoAddress = '';

  @override
  void initState() {
    super.initState();
    fetchRoute();
    fetchAddress(widget.oferta.origem, isOrigem: true);
    fetchAddress(widget.oferta.destino, isOrigem: false);
  }

  Future<void> fetchRoute() async {
    final url =
        'http://router.project-osrm.org/route/v1/driving/${widget.oferta.origem.longitude},${widget.oferta.origem.latitude};${widget.oferta.destino.longitude},${widget.oferta.destino.latitude}?geometries=geojson&overview=full';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final coordinates = json['routes'][0]['geometry']['coordinates'];
      final routeDistance =
          json['routes'][0]['distance'] / 1000; // distance in km
      final routeDuration = Duration(
          seconds:
              json['routes'][0]['duration'].toInt()); // duration in seconds

      setState(() {
        routePoints = coordinates
            .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
            .toList();
        distance = routeDistance;
        travelTime = routeDuration;
      });
    } else {
      // Handle the error appropriately in a real application
      throw Exception('Failed to fetch route');
    }
  }

  Future<void> fetchAddress(LatLng point, {required bool isOrigem}) async {
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&addressdetails=1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final address = data['address'];

      // Construir o endereço de forma mais robusta
      List<String> addressParts = [];

      // Adicionar rua e número, se disponíveis
      if (address['road'] != null) {
        String streetAddress = address['road'];
        if (address['house_number'] != null) {
          streetAddress += ", ${address['house_number']}";
        }
        addressParts.add(streetAddress);
      }

      // Adicionar bairro, se disponível
      if (address['suburb'] != null) {
        addressParts.add(address['suburb']);
      }

      // Adicionar cidade
      String city =
          address['city'] ?? address['town'] ?? address['village'] ?? '';
      if (city.isNotEmpty) {
        addressParts.add(city);
      }

      // Adicionar estado
      if (address['state'] != null) {
        addressParts.add(address['state']);
      }

      // Adicionar país
      if (address['country'] != null) {
        addressParts.add(address['country']);
      }

      // Juntar todas as partes do endereço
      setState(() {
        if (isOrigem) {
          origemAddress = addressParts.join(", ");
        } else {
          destinoAddress = addressParts.join(", ");
        }
      });
    } else {
      // Handle the error appropriately in a real application
      throw Exception('Failed to load address');
    }
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    return "${twoDigits(d.inHours)}h ${twoDigitMinutes}min";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double menuWidth;
    double contentWidth;

    if (screenWidth >= 1024) {
      menuWidth = screenWidth * 0.15;
      contentWidth = screenWidth * 0.85;
    } else if (screenWidth >= 600) {
      menuWidth = screenWidth * 0.25;
      contentWidth = screenWidth * 0.75;
    } else {
      menuWidth = screenWidth * 0.30;
      contentWidth = screenWidth * 0.70;
    }

    final totalEstimatedTime = travelTime + Duration(hours: 3);
    final freightValue = distance * 3.21;

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: menuWidth,
            color: const Color(0xFFFFCC00),
            child: SideMenu(screenWidth: screenWidth),
          ),
          Container(
            width: contentWidth,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.oferta.codigoRota}',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF301B64),
                                letterSpacing: -1.5),
                          ),
                          const SizedBox(width: 30),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 20),
                            decoration: BoxDecoration(
                              color: widget.oferta.estadoEntrega ==
                                      EstadoEntrega.EntregasEmCurso
                                  ? const Color(0xFFB3E5FC)
                                  : widget.oferta.estadoEntrega ==
                                          EstadoEntrega.EntregasRealizadas
                                      ? Color.fromARGB(255, 238, 222, 74)
                                      : widget.oferta.estadoEntrega ==
                                              EstadoEntrega.EntregasFalhas
                                          ? const Color(0xFFFFCDD2)
                                          : const Color(0xFFD1C4E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.oferta.estadoEntrega.name,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Solicitação criada por ',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              letterSpacing: -0.5,
                              wordSpacing: -1,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'WRPS Transportes',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              letterSpacing: -0.5,
                              wordSpacing: -1.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6, // 60% of the width
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: screenWidth * 0.2,
                                child: FlutterMap(
                                  options: MapOptions(
                                    center: LatLng(
                                      (widget.oferta.origem.latitude +
                                              widget.oferta.destino.latitude) /
                                          2,
                                      (widget.oferta.origem.longitude +
                                              widget.oferta.destino.longitude) /
                                          2,
                                    ),
                                    zoom: 10.0,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      subdomains: ['a', 'b', 'c'],
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: widget.oferta.origem,
                                          builder: (ctx) => const Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                            size: 40.0,
                                          ),
                                        ),
                                        Marker(
                                          point: widget.oferta.destino,
                                          builder: (ctx) => const Icon(
                                            Icons.location_on,
                                            color: Colors.green,
                                            size: 40.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (routePoints.isNotEmpty)
                                      PolylineLayer(
                                        polylines: [
                                          Polyline(
                                            points: routePoints,
                                            strokeWidth: 4.0,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildInfoCard(
                                    icon: Icons.gps_fixed,
                                    title: 'Rota Calculada',
                                    subtitle:
                                        '${distance.toStringAsFixed(2).replaceAll('.', ',')}Km',
                                  ),
                                  const SizedBox(width: 16),
                                  _buildInfoCard(
                                    icon: Icons.access_time,
                                    title: 'Tempo de viagem estimado',
                                    subtitle: formatDuration(travelTime),
                                  ),
                                  const SizedBox(width: 16),
                                  _buildInfoCard(
                                    icon: Icons.local_shipping,
                                    title: 'Tempo de carga/descarga',
                                    subtitle: '3h',
                                  ),
                                  const SizedBox(width: 16),
                                  _buildInfoCard(
                                    icon: Icons.hourglass_bottom,
                                    title: 'Tempo total estimado',
                                    subtitle:
                                        formatDuration(totalEstimatedTime),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 4, // 40% of the width
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                height: 200, // Altura aumentada
                                decoration: BoxDecoration(
                                  color: Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.edit_document,
                                            size: 60,
                                            color: Color(0xFF301B64),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Informações De Origem',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 24,
                                              letterSpacing: -1.5,
                                              wordSpacing: -2,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            'Início da viagem',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                                color: Colors.grey[400],
                                                letterSpacing: -0.5,
                                                wordSpacing: -1),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 200,
                                      child: VerticalDivider(
                                        color: Colors.grey[400],
                                        width: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${widget.oferta.data} ${widget.oferta.hora}',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                                letterSpacing: -0.3,
                                                wordSpacing: -1),
                                          ),
                                          // const SizedBox(height: 4),
                                          Text(
                                            origemAddress.isNotEmpty
                                                ? origemAddress
                                                : 'Carregando endereço...',
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 24,
                                              letterSpacing: -1,
                                              wordSpacing: -2,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                height: 200, // Altura aumentada
                                decoration: BoxDecoration(
                                  color: Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons
                                                .playlist_add_check_circle_rounded,
                                            size: 60,
                                            color: Color(0xFF301B64),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Informações de Destino',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 24,
                                              letterSpacing: -1.5,
                                              wordSpacing: -2,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Chegada prevista',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              color: Colors.grey[400],
                                              letterSpacing: -0.5,
                                              wordSpacing: -1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 180,
                                      child: VerticalDivider(
                                        color: Colors.grey[400],
                                        width: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "25/07/2024 23:00 ",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                                letterSpacing: -0.3,
                                                wordSpacing: -1),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            destinoAddress.isNotEmpty
                                                ? destinoAddress
                                                : 'Carregando endereço...',
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 24,
                                              letterSpacing: -1,
                                              wordSpacing: -2,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      height: 150, // Aumentar a altura do card
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.attach_money,
                                              size: 60,
                                              color: Colors.blue[900],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, // Centralizar verticalmente
                                              children: [
                                                Text(
                                                  'Valor do Frete',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 13,
                                                    letterSpacing: -0.5,
                                                    wordSpacing: -1,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${freightValue.toStringAsFixed(2).replaceAll('.', ',')}',
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: -1,
                                                        wordSpacing: -1.5,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      'em reais',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: -0.5,
                                                        wordSpacing: -1,
                                                        color:
                                                            Color(0xFF301B64),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      height: 150, // Aumentar a altura do card
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, // Centralizar verticalmente
                                        children: [
                                          Text(
                                            'Documentos adjuntos',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 13,
                                              letterSpacing: -0.3,
                                              wordSpacing: -1,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Previos: 00',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              letterSpacing: -0.3,
                                              wordSpacing: -1,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF301B64),
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Text(
                                            'Viagens: 00',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              letterSpacing: -0.3,
                                              wordSpacing: -1,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF301B64),
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Text(
                                            'Estandar Minerio: 00', // Tradução para Standard Mineral
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              letterSpacing: -0.3,
                                              wordSpacing: -1,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF301B64),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF301B64).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: Color(0xFF301B64),
            ), // Ícone menor
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14, // Tamanho de fonte reduzido
                      color: Colors.black87,
                      letterSpacing: -0.3,
                      wordSpacing: -1,
                    ),
                    maxLines: 2, // Permite até duas linhas
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      letterSpacing: -0.3,
                      wordSpacing: -1,
                      fontWeight:
                          FontWeight.bold, // Negrito apenas no subtítulo
                      color: Color(0xFF301B64),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
