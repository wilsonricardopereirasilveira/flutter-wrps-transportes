import 'package:flutter/material.dart';
import 'package:website_transwrps/models/oferta.dart';

class OrderTable extends StatelessWidget {
  final double screenWidth;
  final List<Oferta> orders;

  OrderTable({required this.screenWidth, required this.orders});

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
    return orders.map((order) {
      return DataRow(
        cells: [
          DataCell(Text(
            '#${order.codigoRota}',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Text(
            order.placaCaminhao,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Text(
            '${order.data}\n${order.hora}',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: order.estadoEntrega == EstadoEntrega.EntregasEmCurso
                  ? const Color(0xFFB3E5FC)
                  : const Color(0xFFFFF9C4),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              order.estadoEntrega.toString().split('.').last,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: _getFontSize(screenWidth, 12),
                color: order.estadoEntrega == EstadoEntrega.EntregasEmCurso
                    ? Colors.blue
                    : Colors.orange,
              ),
            ),
          )),
          DataCell(Text(
            order.nomeMotorista,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getFontSize(screenWidth, 14),
              color: const Color(0xFF301B64),
            ),
          )),
          DataCell(Text(
            order.telefoneMotorista,
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
      );
    }).toList();
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
