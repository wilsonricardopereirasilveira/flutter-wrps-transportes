import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final double screenWidth;

  SideMenu({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 40.0, horizontal: screenWidth * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'WRPS Transportes',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: _getFontSize(screenWidth, 24),
                letterSpacing: -1,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF301B64),
              ),
            ),
          ),
          const Divider(color: Colors.white),
          _buildMenuItem(Icons.home, 'Início', screenWidth, () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }),
          _buildMenuItem(
              Icons.track_changes, 'Rastreamento', screenWidth, () {}),
          _buildMenuItem(Icons.list, 'Número de Pedidos', screenWidth, () {
            Navigator.pushReplacementNamed(context, '/numero-de-pedido');
          }),
          _buildMenuItem(Icons.report, 'Relatórios', screenWidth, () {}),
          const SizedBox(height: 20),
          _buildActionButton('+ Criar Solicitação', screenWidth, () {}),
          _buildActionButton('+ Criar Oferta', screenWidth, () {
            Navigator.pushReplacementNamed(context, '/criar-oferta');
          }),
          const SizedBox(height: 20),
          _buildBalanceCard(screenWidth),
        ],
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

  Widget _buildMenuItem(
      IconData icon, String title, double screenWidth, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF301B64), size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 16),
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF301B64),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, double screenWidth, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF301B64),
              onPrimary: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: onTap,
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.currency_exchange,
                  color: Color(0xFF301B64), size: 48),
              const SizedBox(height: 10),
              Text(
                'R\$ 50.000',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 21),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: const Color(0xFF301B64),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Saldo Contábil',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getFontSize(screenWidth, 14),
                  color: const Color(0xFF301B64),
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
