import 'package:flutter/material.dart';
import 'package:website_transwrps/widgets/combined_card.dart';
import 'package:website_transwrps/widgets/dashboard_card.dart';
import 'package:website_transwrps/widgets/donut_chart_painter.dart';
import 'package:website_transwrps/widgets/graph_card.dart';
import 'package:website_transwrps/widgets/order_table.dart';
import 'package:website_transwrps/widgets/truck_route_painter.dart';
import 'package:website_transwrps/widgets/side_menu.dart';

class HomePageDashboardScreen extends StatelessWidget {
  const HomePageDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

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
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopBar(screenWidth),
                        const SizedBox(height: 16),
                        Text(
                          'Bem-vindo, Administrador',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: _getFontSize(screenWidth, 18),
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            wordSpacing: -0.5,
                            color: const Color(0xFF301B64),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDashboardCards(screenWidth),
                        const SizedBox(height: 36),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                          height: 30,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ordens Criadas',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: _getFontSize(screenWidth, 18),
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            wordSpacing: -0.5,
                            color: const Color(0xFF301B64),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: screenWidth,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.white,
                                width: double.infinity,
                                child:
                                    OrderTableHeader(screenWidth: screenWidth),
                              ),
                              Container(
                                height: 400,
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: OrderTable(screenWidth: screenWidth),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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

  Widget _buildTopBar(double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: 'Último mês',
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (String? newValue) {},
                items: <String>[
                  'Último mês',
                  'Últimos 3 meses',
                  'Últimos 6 meses',
                  'Último ano'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: _getFontSize(screenWidth, 14),
                        color: const Color(0xFF301B64),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  const VerticalDivider(
                    color: Color(0xFF301B64),
                    thickness: 1,
                    width: 20,
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 16,
                    child: Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WRPS Transportes',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: _getFontSize(screenWidth, 16),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                          wordSpacing: -0.5,
                          color: const Color(0xFF301B64),
                        ),
                      ),
                      Text(
                        'WRPS Análise de Software',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: _getFontSize(screenWidth, 12),
                          color: Colors.grey,
                          letterSpacing: -0.5,
                          wordSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCards(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: screenWidth >= 1024
              ? 5
              : screenWidth >= 600
                  ? 3
                  : 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.5,
          children: [
            DashboardCard(
              count: '14',
              label: 'Pedidos Totais',
              icon: Icons.assignment,
              iconColor: const Color(0xFF301B64),
              backgroundColor: const Color(0xFFFFCC00),
              screenWidth: screenWidth,
            ),
            DashboardCard(
              count: '08',
              label: 'Pedidos Realizados',
              icon: Icons.flag,
              iconColor: const Color(0xFF301B64),
              backgroundColor: const Color(0xFFB5E4CA),
              screenWidth: screenWidth,
            ),
            DashboardCard(
              count: '01',
              label: 'Entregas Falhas',
              icon: Icons.error,
              iconColor: const Color(0xFF301B64),
              backgroundColor: const Color(0xFFFFCCCB),
              screenWidth: screenWidth,
            ),
            DashboardCard(
              count: '02',
              label: 'Entregas em Curso',
              icon: Icons.local_shipping,
              iconColor: const Color(0xFF301B64),
              backgroundColor: const Color(0xFFB3E5FC),
              screenWidth: screenWidth,
            ),
            DashboardCard(
              count: '01',
              label: 'Entrega Parcial',
              icon: Icons.hourglass_bottom,
              iconColor: const Color(0xFF301B64),
              backgroundColor: const Color(0xFFFFF9C4),
              screenWidth: screenWidth,
            ),
          ],
        ),
        const SizedBox(height: 36),
        SizedBox(
          height: 300,
          child: Row(
            children: [
              Expanded(
                flex: 40,
                child: CombinedCard(screenWidth: screenWidth),
              ),
              SizedBox(width: screenWidth * 0.015),
              Expanded(
                flex: 20,
                child: GraphCard(
                  title: 'Entrega Parcial',
                  painter: DonutChartPainter(),
                  height: 300,
                  legend: [
                    LegendItem(
                        label: 'Não tem espaço',
                        color: const Color(0xFF301B64)),
                    LegendItem(
                        label: 'Despacho Errado',
                        color: const Color(0xFFAA8EFF)),
                    LegendItem(label: 'Outros', color: const Color(0xFFDFD8FF)),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.015),
              Expanded(
                flex: 40,
                child: GraphCard(
                  title: 'Rota dos Caminhões',
                  painter: TruckRoutePainter(),
                  height: 300,
                  isTruckRoute: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
