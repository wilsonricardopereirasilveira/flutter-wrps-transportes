import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:website_transwrps/models/oferta.dart';
import 'package:website_transwrps/screens/ordem_completa_screen.dart';
import 'package:website_transwrps/widgets/side_menu.dart';

class NumeroDePedidoScreen extends StatefulWidget {
  const NumeroDePedidoScreen({super.key});

  @override
  _NumeroDePedidoScreenState createState() => _NumeroDePedidoScreenState();
}

class _NumeroDePedidoScreenState extends State<NumeroDePedidoScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Oferta> _filteredData = [];
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredData = Oferta.cachedFakeData;
  }

  void _filterData() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        _filteredData = Oferta.cachedFakeData.where((oferta) {
          return oferta.codigoRota.contains(query);
        }).toList();
      });
    } else {
      setState(() {
        _filteredData = Oferta.cachedFakeData;
      });
    }
  }

  void _sortData(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }

      _filteredData.sort((a, b) {
        switch (columnIndex) {
          case 0:
            return _compare(a.codigoRota, b.codigoRota);
          case 1:
            return _compare("18082", "18082"); // Substitute with actual data
          case 2:
            return _compare("194051", "194051"); // Substitute with actual data
          case 3:
            return _compare("--", "--"); // Substitute with actual data
          case 4:
            return _compare("650393", "650393"); // Substitute with actual data
          case 5:
            return _compare("050383", "050383"); // Substitute with actual data
          case 6:
            return _compare(
                "20600546041", "20600546041"); // Substitute with actual data
          case 7:
            return _compare("COBEFAR S.A.C",
                "COBEFAR S.A.C"); // Substitute with actual data
          case 8:
            return _compare(a.telefoneMotorista, b.telefoneMotorista);
          case 9:
            return _compare(a.nomeMotorista, b.nomeMotorista);
          case 10:
            return _compare(a.placaCaminhao, b.placaCaminhao);
          case 11:
            return _compare('${a.data} ${a.hora}', '${a.data} ${a.hora}');
          default:
            return 0;
        }
      });
    });
  }

  int _compare(String a, String b) {
    if (_sortAscending) {
      return a.compareTo(b);
    } else {
      return b.compareTo(a);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPedidos = _filteredData.length;
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
                  Text.rich(
                    TextSpan(
                      text: 'Número de pedidos',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                        wordSpacing: -1,
                        color: Colors.black87,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' (Total de $totalPedidos pedidos)',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                            wordSpacing: -1,
                            color: Color(0xFF301B64),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: contentWidth * 0.30,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _filterData(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: 'Insira o número do seu pedido aqui',
                        hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          letterSpacing: -0.3,
                          wordSpacing: -1,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        suffixIcon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        child: Table(
                          border: TableBorder(
                            horizontalInside: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(2),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(2),
                            7: FlexColumnWidth(2),
                            8: FlexColumnWidth(1.5),
                            9: FlexColumnWidth(2.5),
                            10: FlexColumnWidth(),
                            11: FlexColumnWidth(2.5),
                            12: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                _buildTableHeader('Nº do Pedido', 0),
                                _buildTableHeader('Nº da Guia', 1),
                                _buildTableHeader('Nº da Fatura', 2),
                                _buildTableHeader('Descrição', 3),
                                _buildTableHeader('Código da Rota', 4),
                                _buildTableHeader('Código Destino', 5),
                                _buildTableHeader('RUC', 6),
                                _buildTableHeader('Cliente', 7),
                                _buildTableHeader('Celular', 8),
                                _buildTableHeader('Motorista', 9),
                                _buildTableHeader('Placa', 10),
                                _buildTableHeader(
                                    'Inicio de Carga / Fim de Carga', 11),
                                Container(), // Para alinhar com o botão nas linhas
                              ],
                            ),
                            for (var oferta in _filteredData)
                              TableRow(
                                children: [
                                  _buildTableCell(oferta.codigoRota),
                                  _buildTableCell("18082"),
                                  _buildTableCell("194051"),
                                  _buildTableCell("--"),
                                  _buildTableCell("650393"),
                                  _buildTableCell("050383"),
                                  _buildTableCell("20600546041"),
                                  _buildTableCell("COBEFAR S.A.C"),
                                  _buildTableCell(oferta.telefoneMotorista),
                                  _buildTableCell(oferta.nomeMotorista),
                                  _buildTableCell(oferta.placaCaminhao),
                                  _buildTableCell(
                                      '${oferta.data} ${oferta.hora} - 25/07/2024 19:00:00'),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit_document,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrdemCompletaScreen(
                                                    oferta: oferta),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
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
    );
  }

  Widget _buildTableHeader(String title, int columnIndex) {
    return GestureDetector(
      onTap: () => _sortData(columnIndex),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50, // Altura fixa para todas as células do cabeçalho
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    letterSpacing: -0.5,
                    wordSpacing: -1,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (_sortColumnIndex == columnIndex)
                Icon(
                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16,
          letterSpacing: -0.3,
          wordSpacing: -1,
          fontWeight: FontWeight.w300,
          color: Colors.black87,
        ),
      ),
    );
  }
}
