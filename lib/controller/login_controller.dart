
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  String? validarEmail(String email) {
    if (email.trim().isEmpty) {
      return 'Informe seu e-mail.';
    }

    if (!email.trim().contains('@')) {
      return 'Digite um e-mail válido.';
    }

    return null;
  }

  String? validarSenha(String senha) {
    if (senha.isEmpty) {
      return 'Informe sua senha.';
    }

    return null;
  }

  Map<String, String?> validarLogin({
    required String email,
    required String senha,
  }) {
    return {
      'email': validarEmail(email),
      'senha': validarSenha(senha),
    };
  }
}
