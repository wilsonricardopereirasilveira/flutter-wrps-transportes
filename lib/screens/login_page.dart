import 'package:flutter/material.dart';
import '../controllers/video_controller.dart';
import '../widgets/custom_form.dart';

class LoginPageScreen extends StatefulWidget {
  @override
  _LoginPageScreenState createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    registerVideoElement();

    // Iniciar a animação após um pequeno atraso
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Fundo dividido em duas cores
          Row(
            children: <Widget>[
              // Metade esquerda - cor amarela
              Expanded(
                child: Container(
                  color: Color(0xFFFFCC00),
                  child: Center(
                    child: CustomForm(isVisible: _isVisible),
                  ),
                ),
              ),
              // Metade direita - cor branca
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: HtmlElementView(viewType: 'videoElement'),
                ),
              ),
            ],
          ),
          // Imagem centralizada ocupando 100% da altura
          Center(
            child: Image.asset(
              'assets/images/cristo-redentor.png',
              fit: BoxFit.cover,
              height: double.infinity,
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
