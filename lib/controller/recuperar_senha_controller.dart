
import 'package:flutter/material.dart';

class RecuperarSenhaController extends ChangeNotifier {
  String email = '';
  String? erroEmail;
  String? mensagemSucesso;

  bool _emailValido(String valor) {
    final regex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    return regex.hasMatch(valor.trim());
  }

  void atualizarEmail(String valor) {
    email = valor;
  }

  bool solicitarRecuperacao() {
    erroEmail = null;
    mensagemSucesso = null;

    if (email.trim().isEmpty) {
      erroEmail = 'Informe seu e-mail.';
      notifyListeners();
      return false;
    }

    if (!_emailValido(email.trim())) {
      erroEmail = 'Informe um e-mail válido.';
      notifyListeners();
      return false;
    }

    // Simulação: sem backend, não é possível verificar
    // se o e-mail está cadastrado nem enviar uma mensagem real.
    mensagemSucesso =
        'Se este e-mail estiver cadastrado, você receberá '
        'instruções para recuperar sua senha.';

    notifyListeners();
    return true;
  }
}
