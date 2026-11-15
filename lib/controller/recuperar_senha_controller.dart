
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecuperarSenhaController extends ChangeNotifier {
  String email = '';
  String? erroEmail;
  String? mensagemSucesso;
  String? erroGeral;

  bool carregando = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _emailValido(String valor) {
    final regex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    return regex.hasMatch(valor.trim());
  }

  void atualizarEmail(String valor) {
    email = valor;
    erroEmail = null;
    mensagemSucesso = null;
    erroGeral = null;
    notifyListeners();
  }

  Future<bool> solicitarRecuperacao() async {
    erroEmail = null;
    mensagemSucesso = null;
    erroGeral = null;

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

    carregando = true;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );

      mensagemSucesso =
          'Se este e-mail estiver cadastrado, você receberá '
          'instruções para recuperar sua senha.';

      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          erroGeral = 'O e-mail informado é inválido.';
          break;
        case 'user-not-found':
          erroGeral =
              'Não foi possível localizar uma conta com esse e-mail.';
          break;
        case 'too-many-requests':
          erroGeral =
              'Muitas tentativas. Tente novamente mais tarde.';
          break;
        case 'network-request-failed':
          erroGeral =
              'Verifique sua conexão com a internet.';
          break;
        default:
          erroGeral =
              'Não foi possível solicitar a recuperação da senha.';
      }

      return false;
    } catch (e) {
      erroGeral =
          'Ocorreu um erro inesperado. Tente novamente.';
      return false;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
