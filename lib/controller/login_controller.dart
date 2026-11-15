
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends ChangeNotifier {
  bool carregando = false;

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

  Future<String?> entrar({
    required String email,
    required String senha,
  }) async {
    carregando = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'invalid-credential':
          return 'E-mail ou senha incorretos.';
        case 'wrong-password':
          return 'Senha incorreta.';
        case 'invalid-email':
          return 'O e-mail informado é inválido.';
        case 'user-disabled':
          return 'Esta conta foi desativada.';
        case 'too-many-requests':
          return 'Muitas tentativas. Tente novamente mais tarde.';
        case 'network-request-failed':
          return 'Verifique sua conexão com a internet.';
        default:
          return 'Não foi possível entrar: ${e.message}';
      }
    } catch (e) {
      return 'Ocorreu um erro inesperado ao entrar.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
