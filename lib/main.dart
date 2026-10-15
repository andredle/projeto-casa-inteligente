
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';

import 'view/cadastro_usuario_view.dart';
import 'view/login_view.dart';
import 'view/perfil_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/sobre_view.dart';
import 'view/home_view.dart';
import 'view/comodos_view.dart';
import 'view/familias_view.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home',
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginView(),
        'cadastro_usuario': (context) =>
            const CadastroUsuarioView(),
        'perfil': (context) => const PerfilView(),
        'recuperar_senha': (context) =>
            const RecuperarSenhaView(),
        'sobre': (context) => const SobreView(),
        'home': (context) => const HomeView(),
        'comodos': (context) => const ComodosView(),
        'familias': (context) => const FamiliasView(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );
      },
    );
  }
}
