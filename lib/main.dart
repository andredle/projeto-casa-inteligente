
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';

import 'controller/usuario_controller.dart';
import 'view/cadastro_usuario_view.dart';
import 'view/login_view.dart';
import 'view/perfil_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/sobre_view.dart';
import 'view/home_view.dart';
import 'view/comodos_view.dart';
import 'view/familias_view.dart';
import 'view/gestao_permissoes_view.dart';
import 'view/rotinas_view.dart';

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

      theme: ThemeData(
        fontFamily: 'Roboto',
      ),

      routes: {
        'login': (context) => const LoginView(),
        'cadastro_usuario': (context) =>
            const CadastroUsuarioView(),

        // Proteção da tela Perfil.
        'perfil': (context) => const PerfilRouteGuard(),

        'recuperar_senha': (context) =>
            const RecuperarSenhaView(),
        'sobre': (context) => const SobreView(),
        'home': (context) => const HomeView(),
        'comodos': (context) => const ComodosView(),
        'familias': (context) => const FamiliasView(),
        'gestao_permissoes': (context) =>
            GestaoPermissoesView(),
        'rotinas': (context) => const RotinasView(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );
      },
    );
  }
}

class PerfilRouteGuard extends StatefulWidget {
  const PerfilRouteGuard({super.key});

  @override
  State<PerfilRouteGuard> createState() =>
      _PerfilRouteGuardState();
}

class _PerfilRouteGuardState extends State<PerfilRouteGuard> {
  bool get autenticado =>
      UsuarioController.instance.autenticado;

  @override
  void initState() {
    super.initState();

    if (!UsuarioController.instance.autenticado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          'login',
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!autenticado) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const PerfilView();
  }
}
