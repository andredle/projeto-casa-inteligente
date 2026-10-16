import 'package:flutter/material.dart';

class PerfilController extends ChangeNotifier {
  // Dados do perfil geridos pelo controller
  String _nomeUsuario = 'User 1';
  final String _emailUsuario = 'user1@teste.com';

  String get nomeUsuario => _nomeUsuario;
  String get emailUsuario => _emailUsuario;

  String? atualizarPerfil(String novoNome) {
    String nomeTrimado = novoNome.trim();

    if (nomeTrimado.isEmpty) {
      return 'Erro: O campo Nome não pode estar vazio!';
    }

    if (nomeTrimado.length < 4) {
      return 'Erro: O nome deve ter no mínimo 4 caracteres!';
    }

    _nomeUsuario = nomeTrimado;
    notifyListeners(); 
    
    return null; 
  }
}
