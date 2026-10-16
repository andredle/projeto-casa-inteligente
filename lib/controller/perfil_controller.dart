
import 'package:flutter/material.dart';
import 'usuario_controller.dart';

class PerfilController extends ChangeNotifier {
  final UsuarioController _usuarioController =
      UsuarioController.instance;

  String get nomeUsuario => _usuarioController.nomeUsuario;
  String get emailUsuario => _usuarioController.emailUsuario;

  String? atualizarPerfil(String novoNome) {
    final nomeTrimado = novoNome.trim();

    if (nomeTrimado.isEmpty) {
      return 'Erro: O campo Nome não pode estar vazio!';
    }

    if (nomeTrimado.length < 4) {
      return 'Erro: O nome deve ter no mínimo 4 caracteres!';
    }

    _usuarioController.atualizarNome(nomeTrimado);
    notifyListeners();

    return null;
  }
}
