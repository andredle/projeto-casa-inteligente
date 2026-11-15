
import 'package:flutter/material.dart';
import '../controller/cadastro_usuario_controller.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() =>
      _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState
    extends State<CadastroUsuarioView> {
  final CadastroUsuarioController controller =
      CadastroUsuarioController();

  final nome = TextEditingController();
  final email = TextEditingController();
  final telefone = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();

  String? erroNome;
  String? erroEmail;
  String? erroTelefone;
  String? erroSenha;
  String? erroConfirmarSenha;

  bool carregando = false;

  @override
  void dispose() {
    nome.dispose();
    email.dispose();
    telefone.dispose();
    senha.dispose();
    confirmarSenha.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> cadastrar() async {
    if (carregando) return;

    final erros = controller.validarCadastro(
      nome: nome.text,
      email: email.text,
      telefone: telefone.text,
      senha: senha.text,
      confirmarSenha: confirmarSenha.text,
    );

    setState(() {
      erroNome = erros['nome'];
      erroEmail = erros['email'];
      erroTelefone = erros['telefone'];
      erroSenha = erros['senha'];
      erroConfirmarSenha = erros['confirmarSenha'];
    });

    if (erros.values.any((erro) => erro != null)) {
      return;
    }

    setState(() {
      carregando = true;
    });

    final resultado = await controller.cadastrarUsuario(
      nome: nome.text,
      email: email.text,
      telefone: telefone.text,
      senha: senha.text,
    );

    if (!mounted) return;

    setState(() {
      carregando = false;
    });

    if (resultado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conta criada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

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
      appBar: AppBar(
        title: const Text('Criar conta'),
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Criar uma nova conta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Preencha seus dados para continuar.',
              ),
              const SizedBox(height: 28),

              const Text('NOME COMPLETO'),
              const SizedBox(height: 8),
              TextField(
                controller: nome,
                decoration: InputDecoration(
                  hintText: 'Digite seu nome',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: const OutlineInputBorder(),
                  errorText: erroNome,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 18),

              const Text('EMAIL'),
              const SizedBox(height: 8),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Digite seu e-mail',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: const OutlineInputBorder(),
                  errorText: erroEmail,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 18),

              const Text('TELEFONE'),
              const SizedBox(height: 8),
              TextField(
                controller: telefone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '(00) 000000000',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: const OutlineInputBorder(),
                  errorText: erroTelefone,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 18),

              const Text('SENHA'),
              const SizedBox(height: 8),
              TextField(
                controller: senha,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Crie uma senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  errorText: erroSenha,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 18),

              const Text('CONFIRME A SENHA'),
              const SizedBox(height: 8),
              TextField(
                controller: confirmarSenha,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirme sua senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  errorText: erroConfirmarSenha,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: carregando ? null : cadastrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrincipal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
                child: carregando
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Criar conta'),
              ),

              TextButton(
                onPressed: carregando
                    ? null
                    : () => Navigator.pop(context),
                child: const Text(
                  'Já possui cadastro? Entre',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
