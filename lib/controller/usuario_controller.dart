
import 'package:flutter/material.dart';

class UsuarioController extends ChangeNotifier {
  UsuarioController._();

  static final UsuarioController instance =
      UsuarioController._();

  String _nomeUsuario = 'Usuário teste';
  String _emailUsuario = 'user1@teste.com';
  bool _autenticado = false;

  String get nomeUsuario => _nomeUsuario;
  String get emailUsuario => _emailUsuario;
  bool get autenticado => _autenticado;

  void atualizarNome(String novoNome) {
    final nomeTrimado = novoNome.trim();

    if (nomeTrimado.isEmpty ||
        nomeTrimado == _nomeUsuario) {
      return;
    }

    _nomeUsuario = nomeTrimado;
    notifyListeners();
  }

  void atualizarEmail(String novoEmail) {
    final emailTrimado = novoEmail.trim();

    if (emailTrimado.isEmpty ||
        emailTrimado == _emailUsuario) {
      return;
    }

    _emailUsuario = emailTrimado;
    notifyListeners();
  }

  void autenticar() {
    if (_autenticado) return;

    _autenticado = true;
    notifyListeners();
  }

  void desautenticar() {
    if (!_autenticado) return;

    _autenticado = false;
    notifyListeners();
  }
}
