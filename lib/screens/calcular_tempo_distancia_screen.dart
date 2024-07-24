import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:website_transwrps/widgets/side_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

class CalcularTempoDistanciaScreen extends StatefulWidget {
  final LatLng origemLatLng;
  final LatLng destinoLatLng;

  CalcularTempoDistanciaScreen({
    required this.origemLatLng,
    required this.destinoLatLng,
  });

  @override
  _CalcularTempoDistanciaScreenState createState() =>
      _CalcularTempoDistanciaScreenState();
}

class _CalcularTempoDistanciaScreenState
    extends State<CalcularTempoDistanciaScreen> {
  MapController mapController = MapController();
  List<LatLng> routePoints = [];
  double routeDistance = 0.0;
  String origemEndereco = '';
  String origemCidadeEstado = '';
  String destinoEndereco = '';
  String destinoCidadeEstado = '';
  int routeTime = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setRoute();
    });
  }

  Future<void> _setRoute() async {
    routePoints = await getRoute(widget.origemLatLng, widget.destinoLatLng);
    routeDistance = calculateRouteDistance(routePoints);
    routeTime = calculateRouteTime(routeDistance);
    origemEndereco = await getAddress(widget.origemLatLng);
    destinoEndereco = await getAddress(widget.destinoLatLng);
    setState(() {});
    _updateMapView();
  }

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final response = await http.get(
      Uri.parse(
          'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['routes'][0]['geometry']['coordinates'];
      return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
    } else {
      throw Exception('Failed to load route');
    }
  }

  double calculateRouteDistance(List<LatLng> points) {
    double totalDistance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += _calculateDistance(points[i], points[i + 1]);
    }
    return totalDistance;
  }

  int calculateRouteTime(double distance) {
    const averageSpeed = 60; // Average speed in km/h
    return (distance / averageSpeed).ceil(); // Time in hours
  }

  Future<String> getAddress(LatLng point) async {
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&addressdetails=1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final address = data['address'];
      final endereco =
          '${address['road'] ?? ''}, ${address['house_number'] ?? ''}';
      final cidadeEstado =
          '${address['city'] ?? address['town'] ?? address['village'] ?? ''}, ${address['state'] ?? ''}';
      return '$endereco\n$cidadeEstado';
    } else {
      throw Exception('Failed to load address');
    }
  }

  void _updateMapView() {
    if (routePoints.isNotEmpty) {
      final centerLat =
          (widget.origemLatLng.latitude + widget.destinoLatLng.latitude) / 2;
      final centerLng =
          (widget.origemLatLng.longitude + widget.destinoLatLng.longitude) / 2;
      final center = LatLng(centerLat, centerLng);

      final zoom =
          _calculateZoomLevel(widget.origemLatLng, widget.destinoLatLng);
      mapController.move(center, zoom);
    }
  }

  double _calculateZoomLevel(LatLng point1, LatLng point2) {
    double distance = _calculateDistance(point1, point2);
    if (distance < 1) {
      return 16; // Zoom level for short distances
    } else if (distance < 5) {
      return 14;
    } else if (distance < 10) {
      return 12;
    } else if (distance < 50) {
      return 10;
    } else if (distance < 100) {
      return 8;
    } else {
      return 6; // Zoom level for long distances
    }
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const R = 6371e3; // Earth's radius in meters
    final lat1 = point1.latitude * math.pi / 180;
    final lat2 = point2.latitude * math.pi / 180;
    final deltaLat = (point2.latitude - point1.latitude) * math.pi / 180;
    final deltaLng = (point2.longitude - point1.longitude) * math.pi / 180;

    final a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    final distance = R * c;
    return distance / 1000; // Convert to kilometers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

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

          return Row(
            children: [
              Container(
                width: menuWidth,
                color: const Color(0xFFFFCC00),
                child: SideMenu(screenWidth: screenWidth),
              ),
              Container(
                width: contentWidth,
                height: screenHeight,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        center: LatLng(-23.5505, -46.6333), // Praça da Sé
                        zoom: 16,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              color: Colors.blue,
                              strokeWidth: 4,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40,
                              height: 40,
                              point: widget.origemLatLng,
                              builder: (ctx) =>
                                  Icon(Icons.location_on, color: Colors.red),
                            ),
                            Marker(
                              width: 40,
                              height: 40,
                              point: widget.destinoLatLng,
                              builder: (ctx) =>
                                  Icon(Icons.flag, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      width: contentWidth * 0.4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Criar oferta /',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Calcular tempo e distância',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF301B64),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        color: Colors.black),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        margin: EdgeInsets.all(16),
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Caminhão',
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Icon(Icons.local_shipping,
                                                      size: 40),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                '${routeDistance.toInt()}Km (${routeTime}h)',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Material de comida',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Divider(height: 20, thickness: 2),
                                              if (origemEndereco.isNotEmpty)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.location_on,
                                                            color:
                                                                Colors.green),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          origemEndereco
                                                              .split('\n')[0],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      origemEndereco
                                                          .split('\n')[1],
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: 8),
                                              if (destinoEndereco.isNotEmpty)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.flag,
                                                            color:
                                                                Colors.purple),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          destinoEndereco
                                                              .split('\n')[0],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      destinoEndereco
                                                          .split('\n')[1],
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              Divider(height: 20, thickness: 2),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        //backgroundImage: AssetImage('assets/gloria_logo.png'), // substitua pelo caminho do logo
                                                        radius: 20,
                                                        child: Text(
                                                          "G",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        backgroundColor:
                                                            Colors.blue,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Darrell Steward',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            'GLORIA, Asesor',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(Icons.copy,
                                                            color:
                                                                Colors.black),
                                                        onPressed: () {},
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.edit,
                                                            color:
                                                                Colors.black),
                                                        onPressed: () {},
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
