import 'package:flutter/material.dart';

class OrderTableHeader extends StatelessWidget {
  final double screenWidth;

  OrderTableHeader({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: screenWidth,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Código da Rota',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Placa do Caminhão',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Data Planejada da Rota',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Estado',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Nome do Motorista',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Telefone do Motorista',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Ações',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
          ],
          rows: [],
        ),
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

class OrderTable extends StatelessWidget {
  final double screenWidth;

  OrderTable({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: screenWidth,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Código da Rota',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Placa do Caminhão',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Data Planejada da Rota',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Estado',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Nome do Motorista',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Telefone do Motorista',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Ações',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
          ],
          rows: _getOrderRows(screenWidth),
        ),
      ),
    );
  }

  List<DataRow> _getOrderRows(double screenWidth) {
    return [
      DataRow(
        cells: [
          DataCell(Text(
            '#81927391',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Text(
            'BVC-123',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Text(
            '10/06/2023\n17:02',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFCCCB),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              'Entregas Falhas',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: _getFontSize(screenWidth, 12),
                color: Colors.red,
              ),
            ),
          )),
          DataCell(Text(
            'Juan Perez Sandoval',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Text(
            '(+51) 910000000',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.inventory, color: Color(0xFF301B64)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.location_on, color: Color(0xFF301B64)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.article, color: Color(0xFF301B64)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {},
              ),
            ],
          )),
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text(
            '#81927391',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Text(
            'BVC-123',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Text(
            '10/06/2023\n17:02',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFCCCB),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              'Entregas Falhas',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: _getFontSize(screenWidth, 12),
                color: Colors.red,
              ),
            ),
          )),
          DataCell(Text(
            'Juan Perez Sandoval',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Text(
            '(+51) 910000000',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.inventory, color: Color(0xFF301B64)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.location_on, color: Color(0xFF301B64)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.article, color: Color(0xFF301B64)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {},
              ),
            ],
          )),
        ],
      ),
      // Adicione mais DataRows conforme necessário
    ];
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
