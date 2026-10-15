
import 'package:flutter/material.dart';

class FamiliasController extends ChangeNotifier {
  final String nomeUsuario;

  FamiliasController({required this.nomeUsuario});

  late final List<Map<String, dynamic>> familias = [
    {
      'nome': 'Família Oceano',
      'admin': true,
      'resumo': '$nomeUsuario (você), Sara e outros 2',
      'membros': [
        '$nomeUsuario (você)',
        'Sara',
        'Vinícius',
        'Renata',
      ],
      'expandida': true,
    },
    {
      'nome': 'Boteco Beira-Rio',
      'admin': false,
      'resumo': '$nomeUsuario (você), Renata e outros 6',
      'membros': [
        '$nomeUsuario (você)',
        'Renata',
        'Sérgio',
        'Raul',
        'Laura',
        'Nathan',
        'Sofia',
        'Heloisa',
      ],
      'expandida': false,
    },
    {
      'nome': 'Família Reis',
      'admin': false,
      'resumo': '$nomeUsuario (você) e Giorgian',
      'membros': [
        '$nomeUsuario (você)',
        'Giorgian',
      ],
      'expandida': false,
    },
  ];

  void alternarFamilia(int index, bool expandida) {
    familias[index]['expandida'] = expandida;
    notifyListeners();
  }

  bool adicionarFamilia(String nome) {
    final nomeLimpo = nome.trim();

    if (nomeLimpo.isEmpty || _nomeJaExiste(nomeLimpo)) {
      return false;
    }

    familias.add({
      'nome': nomeLimpo,
      'admin': true,
      'resumo': '$nomeUsuario (você)',
      'membros': ['$nomeUsuario (você)'],
      'expandida': true,
    });

    notifyListeners();
    return true;
  }

  bool editarNomeFamilia(int index, String novoNome) {
    final nomeLimpo = novoNome.trim();

    if (!_indiceValido(index) ||
        nomeLimpo.isEmpty ||
        _nomeJaExiste(nomeLimpo, ignorarIndex: index)) {
      return false;
    }

    if (familias[index]['admin'] != true) {
      return false;
    }

    familias[index]['nome'] = nomeLimpo;

    notifyListeners();
    return true;
  }

  bool adicionarMembro(int index, String nome) {
    final nomeLimpo = nome.trim();

    if (!_indiceValido(index) || nomeLimpo.isEmpty) {
      return false;
    }

    if (familias[index]['admin'] != true) {
      return false;
    }

    final membros = List<String>.from(familias[index]['membros']);

    final jaExiste = membros.any(
      (membro) => membro.toLowerCase() == nomeLimpo.toLowerCase(),
    );

    if (jaExiste) {
      return false;
    }

    membros.add(nomeLimpo);
    familias[index]['membros'] = membros;

    _atualizarResumo(index);
    notifyListeners();
    return true;
  }

  bool removerMembro(int index, String nome) {
    if (!_indiceValido(index) ||
        familias[index]['admin'] != true) {
      return false;
    }

    final membros = List<String>.from(familias[index]['membros']);

    // Impede a remoção do próprio administrador.
    if (nome == '$nomeUsuario (você)') {
      return false;
    }

    membros.remove(nome);
    familias[index]['membros'] = membros;

    _atualizarResumo(index);
    notifyListeners();
    return true;
  }

  bool excluirFamilia(int index) {
    if (!_indiceValido(index) ||
        familias[index]['admin'] != true) {
      return false;
    }

    familias.removeAt(index);
    notifyListeners();
    return true;
  }

  bool _indiceValido(int index) {
    return index >= 0 && index < familias.length;
  }

  bool _nomeJaExiste(
    String nome, {
    int? ignorarIndex,
  }) {
    for (int i = 0; i < familias.length; i++) {
      if (i == ignorarIndex) continue;

      if (familias[i]['nome'].toString().toLowerCase() ==
          nome.toLowerCase()) {
        return true;
      }
    }

    return false;
  }

  void _atualizarResumo(int index) {
    final membros = List<String>.from(familias[index]['membros']);

    if (membros.length <= 3) {
      familias[index]['resumo'] = membros.join(', ');
    } else {
      familias[index]['resumo'] =
          '${membros.take(2).join(', ')} e outros ${membros.length - 2}';
    }
  }
}
