
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioController extends ChangeNotifier {
  UsuarioController._() {
    FirebaseAuth.instance.authStateChanges().listen((usuario) {
      if (usuario == null) {
        _nomeUsuario = 'Usuário';
        _emailUsuario = '';
        notifyListeners();
      } else {
        carregarDadosUsuario(usuario);
      }
    });
  }

  static final UsuarioController instance =
      UsuarioController._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String _nomeUsuario = 'Usuário';
  String _emailUsuario = '';

  String get nomeUsuario => _nomeUsuario;
  String get emailUsuario => _emailUsuario;

  bool get autenticado => _auth.currentUser != null;

  Future<void> carregarDadosUsuario([User? usuario]) async {
    final usuarioAtual = usuario ?? _auth.currentUser;

    if (usuarioAtual == null) {
      _nomeUsuario = 'Usuário';
      _emailUsuario = '';
      notifyListeners();
      return;
    }

    _emailUsuario = usuarioAtual.email ?? '';

    try {
      final documento = await _firestore
          .collection('usuarios')
          .doc(usuarioAtual.uid)
          .get();

      if (documento.exists) {
        final dados = documento.data();

        _nomeUsuario =
            dados?['nome'] ?? 'Usuário';
      } else {
        _nomeUsuario =
            usuarioAtual.displayName ?? 'Usuário';
      }
    } catch (e) {
      _nomeUsuario =
          usuarioAtual.displayName ?? 'Usuário';
    }

    notifyListeners();
  }

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

  Future<void> desautenticar() async {
    await _auth.signOut();
  }
}
