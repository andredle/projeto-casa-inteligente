
import 'package:flutter/material.dart';
import '../controller/login_controller.dart';
import '../controller/usuario_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = LoginController();

  final email = TextEditingController();
  final senha = TextEditingController();

  String? erroEmail;
  String? erroSenha;

  @override
  void dispose() {
    email.dispose();
    senha.dispose();
    controller.dispose();
    super.dispose();
  }

  void entrar() {
    final erros = controller.validarLogin(
      email: email.text,
      senha: senha.text,
    );

    setState(() {
      erroEmail = erros['email'];
      erroSenha = erros['senha'];
    });

    if (erroEmail != null || erroSenha != null) {
      return;
    }

    UsuarioController.instance
        .atualizarEmail(email.text.trim());

    UsuarioController.instance.autenticar();

    Navigator.pushNamedAndRemoveUntil(
      context,
      'home',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFF4C6EF5);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.home_outlined,
                  size: 80,
                  color: corPrincipal,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bem-vindo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entre na sua conta para continuar.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                const Text('EMAIL'),
                const SizedBox(height: 8),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Digite seu e-mail',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder:
                        const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: corPrincipal,
                        width: 2,
                      ),
                    ),
                    errorText: erroEmail,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                const Text('SENHA'),
                const SizedBox(height: 8),
                TextField(
                  controller: senha,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Digite sua senha',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder:
                        const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: corPrincipal,
                        width: 2,
                      ),
                    ),
                    errorText: erroSenha,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        'recuperar_senha',
                      );
                    },
                    child: const Text(
                      'Esqueci minha senha',
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: entrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corPrincipal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      'cadastro_usuario',
                    );
                  },
                  child: const Text('Criar uma conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
