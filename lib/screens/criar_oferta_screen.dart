import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:website_transwrps/screens/calcular_tempo_distancia_screen.dart';
import 'package:website_transwrps/widgets/side_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class CriarOfertaScreen extends StatefulWidget {
  @override
  _CriarOfertaScreenState createState() => _CriarOfertaScreenState();
}

class _CriarOfertaScreenState extends State<CriarOfertaScreen> {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _origemController = TextEditingController();
  final TextEditingController _destinoController = TextEditingController();
  final TextEditingController _toneladasController = TextEditingController();
  final TextEditingController _metrosCubicosController =
      TextEditingController();
  final TextEditingController _containerController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  bool _shouldAutoUpdateMap = true;

  MapController mapController = MapController();
  LatLng? origemLatLng;
  LatLng? destinoLatLng;
  List<LatLng> routePoints = [];

  String? _tipoEmbalagem;
  String? _tipoCarga;
  String? _tipoVeiculo;

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _dataController.addListener(_validateForm);
    _horaController.addListener(_validateForm);
    _origemController.addListener(_validateForm);
    _destinoController.addListener(_validateForm);
    _toneladasController.addListener(_validateForm);
    _metrosCubicosController.addListener(_validateForm);
    _containerController.addListener(_validateForm);
    _descricaoController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _dataController.text.isNotEmpty &&
          _horaController.text.isNotEmpty &&
          _origemController.text.isNotEmpty &&
          _destinoController.text.isNotEmpty &&
          _toneladasController.text.isNotEmpty &&
          _metrosCubicosController.text.isNotEmpty &&
          _containerController.text.isNotEmpty &&
          _descricaoController.text.isNotEmpty &&
          _tipoEmbalagem != null &&
          _tipoCarga != null &&
          _tipoVeiculo != null;
    });

    LatLng pracaDaSe = LatLng(-23.5505, -46.6333);
    mapController = MapController();

    // Não mova o mapa aqui, apenas defina o centro inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapController.move(pracaDaSe, 15);
    });
  }

  Future<LatLng?> getLatLngFromAddress(String address) async {
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$address'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return LatLng(
          double.parse(data[0]['lat']),
          double.parse(data[0]['lon']),
        );
      }
    }
    return null;
  }

  void updateMap() async {
    bool shouldUpdateView = false;

    if (_origemController.text.isNotEmpty && origemLatLng == null) {
      origemLatLng = await getLatLngFromAddress(_origemController.text);
      shouldUpdateView = true;
    }

    if (_destinoController.text.isNotEmpty && destinoLatLng == null) {
      destinoLatLng = await getLatLngFromAddress(_destinoController.text);
      shouldUpdateView = true;
    }

    if (origemLatLng != null && destinoLatLng != null) {
      routePoints = await getRoute(origemLatLng!, destinoLatLng!);
      shouldUpdateView = true;
    }

    if (shouldUpdateView && _shouldAutoUpdateMap) {
      _updateMapView();
    }

    setState(() {
      _shouldAutoUpdateMap = false; // Disable auto-update after initial setup
    });
  }

  void _updateMapView() {
    if (_shouldAutoUpdateMap) {
      if (origemLatLng != null && destinoLatLng != null) {
        final centerLat =
            (origemLatLng!.latitude + destinoLatLng!.latitude) / 2;
        final centerLng =
            (origemLatLng!.longitude + destinoLatLng!.longitude) / 2;
        final center = LatLng(centerLat, centerLng);

        final zoom = _calculateZoomLevel(origemLatLng!, destinoLatLng!);
        mapController.move(center, zoom);
      } else if (origemLatLng != null) {
        mapController.move(origemLatLng!, 15);
      } else if (destinoLatLng != null) {
        mapController.move(destinoLatLng!, 15);
      }
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

  double lat2rad(double lat) {
    return lat * math.pi / 180;
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
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> _getSuggestions(String query) async {
    if (query.length < 3) return [];

    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$query&countrycodes=br&limit=5'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((place) {
        final address = place['address'] as Map<String, dynamic>? ?? {};
        return {
          'display_name': place['display_name'] as String,
          'street': address['road'] ?? '',
          'number': address['house_number'] ?? '',
          'neighborhood': address['suburb'] ?? address['neighbourhood'] ?? '',
          'city':
              address['city'] ?? address['town'] ?? address['village'] ?? '',
          'state': address['state'] ?? '',
          'postcode': address['postcode'] ?? '',
        };
      }).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
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
                            if (origemLatLng != null)
                              Marker(
                                width: 40,
                                height: 40,
                                point: origemLatLng!,
                                builder: (ctx) =>
                                    Icon(Icons.location_on, color: Colors.red),
                              ),
                            if (destinoLatLng != null)
                              Marker(
                                width: 40,
                                height: 40,
                                point: destinoLatLng!,
                                builder: (ctx) =>
                                    Icon(Icons.flag, color: Colors.green),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: contentWidth * 0.6,
                        height: screenHeight,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Criar oferta',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize:
                                              _getFontSize(screenWidth, 18),
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF301B64),
                                        ),
                                      ),
                                      Text(
                                        '(* Campos obrigatórios)',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize:
                                              _getFontSize(screenWidth, 12),
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Endereço de origem *',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:
                                                _getFontSize(screenWidth, 14),
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.3,
                                            color: const Color(0xFF301B64),
                                          ),
                                        ),
                                        TypeAheadFormField<
                                            Map<String, dynamic>>(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            controller: _origemController,
                                            decoration: InputDecoration(
                                              hintText: 'Ex: Local de entrega',
                                              hintStyle: const TextStyle(
                                                letterSpacing: -0.3,
                                                fontFamily: 'Montserrat',
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 16.0),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) async {
                                            return await _getSuggestions(
                                                pattern);
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title: Text(
                                                  suggestion['display_name'] ??
                                                      ''),
                                            );
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            _origemController.text =
                                                suggestion['display_name'] ??
                                                    '';
                                            origemLatLng =
                                                null; // Reset para forçar uma nova atualização
                                            _shouldAutoUpdateMap =
                                                true; // Enable auto-update
                                            updateMap();
                                            _validateForm();
                                          },
                                          noItemsFoundBuilder: (context) =>
                                              const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                'Nenhum endereço encontrado'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Data de carga *',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: _getFontSize(
                                                      screenWidth, 14),
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF301B64),
                                                ),
                                              ),
                                              TextField(
                                                controller: _dataController,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      8),
                                                  DateInputFormatter(),
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: 'dd/mm/aaaa',
                                                  hintStyle: const TextStyle(
                                                      letterSpacing: -0.3),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                        Icons.calendar_today),
                                                    onPressed: () async {
                                                      DateTime? date =
                                                          await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2100),
                                                        locale: const Locale(
                                                            'pt', 'BR'),
                                                      );
                                                      if (date != null) {
                                                        _dataController
                                                            .text = DateFormat(
                                                                'dd/MM/yyyy',
                                                                'pt_BR')
                                                            .format(date);
                                                        _validateForm();
                                                      }
                                                    },
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16.0,
                                                          horizontal: 16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Hora de carga *',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: _getFontSize(
                                                      screenWidth, 14),
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF301B64),
                                                ),
                                              ),
                                              TextField(
                                                controller: _horaController,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      4),
                                                  TimeInputFormatter(),
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: '00:00',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                  suffixIcon:
                                                      Icon(Icons.access_time),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16.0,
                                                          horizontal: 16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Endereço de destino *',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:
                                                _getFontSize(screenWidth, 14),
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF301B64),
                                          ),
                                        ),
                                        TypeAheadFormField<
                                            Map<String, dynamic>>(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            controller: _destinoController,
                                            decoration: InputDecoration(
                                              hintText: 'Ex: Local de entrega',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 16.0),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) async {
                                            return await _getSuggestions(
                                                pattern);
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title: Text(
                                                  suggestion['display_name'] ??
                                                      ''),
                                            );
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            _destinoController.text =
                                                suggestion['display_name'] ??
                                                    '';
                                            destinoLatLng =
                                                null; // Reset para forçar uma nova atualização
                                            _shouldAutoUpdateMap =
                                                true; // Enable auto-update
                                            updateMap();
                                            _validateForm();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Toneladas *',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: _getFontSize(
                                                      screenWidth, 14),
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF301B64),
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    _toneladasController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                decoration: InputDecoration(
                                                  hintText: 'Ex: 10',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16.0,
                                                          horizontal: 16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'm³ *',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: _getFontSize(
                                                      screenWidth, 14),
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF301B64),
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    _metrosCubicosController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                decoration: InputDecoration(
                                                  hintText: 'Ex: 12',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16.0,
                                                          horizontal: 16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tipo de embalagem *',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: _getFontSize(
                                                      screenWidth, 14),
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF301B64),
                                                ),
                                              ),
                                              DropdownButtonFormField<String>(
                                                hint: Text(
                                                    'Selecione um tipo de embalagem'),
                                                items: [
                                                  DropdownMenuItem(
                                                    child: Text('Caixa'),
                                                    value: 'Caixa',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text('Palete'),
                                                    value: 'Palete',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text('Container'),
                                                    value: 'Container',
                                                  ),
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    _tipoEmbalagem = value;
                                                    _validateForm();
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16.0,
                                                          horizontal: 16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Contêiner (pés) *',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: _getFontSize(
                                                      screenWidth, 14),
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF301B64),
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    _containerController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                decoration: InputDecoration(
                                                  hintText: 'Ex: 40',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16.0,
                                                          horizontal: 16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tipo de carga *',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:
                                                _getFontSize(screenWidth, 14),
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF301B64),
                                          ),
                                        ),
                                        DropdownButtonFormField<String>(
                                          hint: Text(
                                              'Selecione um tipo de carga'),
                                          items: [
                                            DropdownMenuItem(
                                              child: Text('Alimentos'),
                                              value: 'Alimentos',
                                            ),
                                            DropdownMenuItem(
                                              child: Text('Eletrônicos'),
                                              value: 'Eletrônicos',
                                            ),
                                            DropdownMenuItem(
                                              child: Text('Móveis'),
                                              value: 'Móveis',
                                            ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _tipoCarga = value;
                                              _validateForm();
                                            });
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 16.0,
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tipo de veículo *',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:
                                                _getFontSize(screenWidth, 14),
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF301B64),
                                          ),
                                        ),
                                        DropdownButtonFormField<String>(
                                          hint: Text(
                                              'Selecione um tipo de veículo'),
                                          items: [
                                            DropdownMenuItem(
                                              child: Text('Caminhão'),
                                              value: 'Caminhão',
                                            ),
                                            DropdownMenuItem(
                                              child: Text('Van'),
                                              value: 'Van',
                                            ),
                                            DropdownMenuItem(
                                              child: Text('Carreta'),
                                              value: 'Carreta',
                                            ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _tipoVeiculo = value;
                                              _validateForm();
                                            });
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 16.0,
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Descrição da carga *',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:
                                                _getFontSize(screenWidth, 14),
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF301B64),
                                          ),
                                        ),
                                        TextField(
                                          controller: _descricaoController,
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Descreva a carga aqui...',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 16.0,
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.grey.withOpacity(0.3),
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _isButtonEnabled ? () {} : null,
                                    icon: Icon(Icons.check,
                                        color: _isButtonEnabled
                                            ? Colors.white
                                            : Colors.grey),
                                    label: Text(
                                      'Confirmar e continuar',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: _isButtonEnabled
                                          ? const Color(0xFF301B64)
                                          : Colors.grey,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 32.0),
                                      textStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  OutlinedButton.icon(
                                    onPressed: _isButtonEnabled &&
                                            origemLatLng != null &&
                                            destinoLatLng != null
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CalcularTempoDistanciaScreen(
                                                  origemLatLng: origemLatLng!,
                                                  destinoLatLng: destinoLatLng!,
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    icon: Icon(Icons.calculate,
                                        color: _isButtonEnabled
                                            ? const Color(0xFF301B64)
                                            : Colors.grey),
                                    label: Text(
                                      'Calcular tempo e distância',
                                      style: TextStyle(
                                          color: _isButtonEnabled
                                              ? const Color(0xFF301B64)
                                              : Colors.grey),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 32.0),
                                      textStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      side: BorderSide(
                                          color: _isButtonEnabled
                                              ? const Color(0xFF301B64)
                                              : Colors.grey),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
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
              ),
            ],
          );
        },
      ),
    );
  }

  double _getFontSize(double screenWidth, double defaultSize) {
    if (screenWidth >= 1024) {
      return defaultSize;
    } else if (screenWidth >= 600) {
      return defaultSize - 2;
    } else {
      return defaultSize - 4;
    }
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    if (newText.length > 8) {
      newText = newText.substring(0, 8);
    }
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i == 2 || i == 4) {
        formattedText += '/';
      }
      formattedText += newText[i];
    }
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    if (newText.length > 4) {
      newText = newText.substring(0, 4);
    }
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i == 2) {
        formattedText += ':';
      }
      formattedText += newText[i];
    }
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
