
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

      theme: ThemeData(
        fontFamily: 'Roboto',
      ),

      home: const TelaInicial(),

      routes: {
        'login': (context) => const LoginView(),
        'cadastro_usuario': (context) =>
            const CadastroUsuarioView(),
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

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data != null) {
          return const HomeView();
        }

        return const LoginView();
      },
    );
  }
}

class PerfilRouteGuard extends StatelessWidget {
  const PerfilRouteGuard({super.key});

  @override
  Widget build(BuildContext context) {
    if (UsuarioController.instance.autenticado) {
      return const PerfilView();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'login',
        (route) => false,
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
