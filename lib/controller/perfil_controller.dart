
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'usuario_controller.dart';

class PerfilController extends ChangeNotifier {
  final UsuarioController _usuarioController =
      UsuarioController.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String get nomeUsuario => _usuarioController.nomeUsuario;
  String get emailUsuario => _usuarioController.emailUsuario;

  Stream<DocumentSnapshot<Map<String, dynamic>>> get usuarioStream {
    final usuario = _auth.currentUser;

    if (usuario == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('usuarios')
        .doc(usuario.uid)
        .snapshots();
  }

  Future<String?> atualizarPerfil(String novoNome) async {
    final nomeTrimado = novoNome.trim();

    if (nomeTrimado.isEmpty) {
      return 'Erro: O campo Nome não pode estar vazio!';
    }

    if (nomeTrimado.length < 4) {
      return 'Erro: O nome deve ter no mínimo 4 caracteres!';
    }

    final usuario = _auth.currentUser;

    if (usuario == null) {
      return 'Erro: Nenhum usuário está autenticado.';
    }

    try {
      await _firestore
          .collection('usuarios')
          .doc(usuario.uid)
          .update({
        'nome': nomeTrimado,
      });

      _usuarioController.atualizarNome(nomeTrimado);
      notifyListeners();

      return null;
    } catch (e) {
      return 'Erro ao atualizar o perfil. Tente novamente.';
    }
  }
}
