
import 'package:flutter/material.dart';

class CadastroUsuarioController extends ChangeNotifier {
  String? validarNome(String nome) {
    if (nome.trim().isEmpty) {
      return 'Informe seu nome completo.';
    }

    if (RegExp(r'\d').hasMatch(nome)) {
      return 'O nome não pode conter números.';
    }

    return null;
  }

  
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


  String? validarTelefone(String telefone) {
    if (telefone.trim().isEmpty) {
      return 'Informe seu telefone.';
    }

    if (!RegExp(r'^[0-9()+\-\s]+$').hasMatch(telefone)) {
      return 'O telefone não pode conter letras.';
    }

    final numeros = telefone.replaceAll(RegExp(r'\D'), '');

    if (numeros.length < 10 || numeros.length > 13) {
      return 'Digite um telefone válido.';
    }

    return null;
}

  String? validarSenha(String senha) {
    if (senha.isEmpty) {
      return 'Informe uma senha.';
    }

    return null;
  }

  String? validarConfirmarSenha(
    String senha,
    String confirmarSenha,
  ) {
    if (confirmarSenha.isEmpty) {
      return 'Confirme sua senha.';
    }

    if (senha != confirmarSenha) {
      return 'As senhas devem ser iguais.';
    }

    return null;
  }

  Map<String, String?> validarCadastro({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
    required String confirmarSenha,
  }) {
    return {
      'nome': validarNome(nome),
      'email': validarEmail(email),
      'telefone': validarTelefone(telefone),
      'senha': validarSenha(senha),
      'confirmarSenha': validarConfirmarSenha(
        senha,
        confirmarSenha,
      ),
    };
  }
}
