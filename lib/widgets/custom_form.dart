import 'package:flutter/material.dart';
import 'package:website_transwrps/screens/home_page_dashboard_screen.dart';

class CustomForm extends StatelessWidget {
  final bool isVisible;

  CustomForm({required this.isVisible});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Largura do formulário reduzida
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: Duration(milliseconds: 600),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, isVisible ? 0 : 20, 0),
              child: const Text(
                'WRPS Transportes',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24, // Tamanho do texto reduzido
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF301B64),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: Duration(milliseconds: 800),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, isVisible ? 0 : 20, 0),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuário (DNI ou E-mail)',
                  hintText: 'Dica: admin',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(fontSize: 14), // Tamanho do texto reduzido
              ),
            ),
          ),
          SizedBox(height: 20),
          AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: Duration(milliseconds: 1000),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, isVisible ? 0 : 20, 0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Dica: admin',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(fontSize: 14), // Tamanho do texto reduzido
              ),
            ),
          ),
          SizedBox(height: 20),
          AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: Duration(milliseconds: 1200),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1200),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, isVisible ? 0 : 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      Text(
                        'Lembrar-me',
                        style: TextStyle(
                            fontSize: 12), // Tamanho do texto reduzido
                      ),
                    ],
                  ),
                  Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      color: Color(0xFF301B64),
                      fontSize: 12, // Tamanho do texto reduzido
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: Duration(milliseconds: 1400),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1400),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, isVisible ? 0 : 20, 0),
              child: ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                child: Text(
                  'Iniciar sessão',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 14, // Tamanho do texto reduzido
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(double.infinity, 40), // Altura do botão reduzida
                  primary: Color(0xFF301B64),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login(BuildContext context) {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'admin' && password == 'admin') {
      // Navegar para a próxima tela se o usuário for admin e a senha for admin
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePageDashboardScreen(), // Insira a próxima tela aqui
        ),
      );
    } else {
      // Mostrar erro de senha inválida
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuário ou senha inválidos'),
        ),
      );
    }
  }
}
