import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:website_transwrps/screens/calcular_tempo_distancia_screen.dart';
import 'package:website_transwrps/screens/criar_oferta_screen.dart';
import 'screens/login_page.dart';
import 'screens/home_page_dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WRPS Transportes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Montserrat',
            ),
      ),
      // Adicione estas configurações de localização
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Português do Brasil
      ],
      locale: const Locale('pt', 'BR'), // Define o idioma padrão
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPageScreen(),
        '/dashboard': (context) => HomePageDashboardScreen(),
        '/criar-oferta': (context) => CriarOfertaScreen(),
      },
    );
  }
}
