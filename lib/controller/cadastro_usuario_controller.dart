
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    if (senha.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
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

  Future<String?> cadastrarUsuario({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    try {
      final credencial = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      final usuario = credencial.user!;

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.uid)
          .set({
        'nome': nome.trim(),
        'email': email.trim(),
        'telefone': telefone.trim(),
        'tipoConta': 'usuario',
        'criadoEm': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Este e-mail já está cadastrado.';
        case 'invalid-email':
          return 'O e-mail informado é inválido.';
        case 'weak-password':
          return 'A senha é muito fraca.';
        case 'network-request-failed':
          return 'Verifique sua conexão com a internet.';
        default:
          return 'Não foi possível criar a conta: ${e.message}';
      }
    } on FirebaseException catch (e) {
      return 'A conta foi criada, mas houve um erro ao salvar os dados: ${e.message}';
    } catch (e) {
      return 'Ocorreu um erro inesperado ao criar a conta.';
    }
  }
}
