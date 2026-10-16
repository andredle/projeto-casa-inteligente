
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
String? validarEmail(String email) {
  if (email.trim().isEmpty) {
    return 'Informe seu e-mail.';
  }

  final regex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  if (!regex.hasMatch(email.trim())) {
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
