
import 'package:flutter/material.dart';

class MembroPermissaoModel {
  final String nome;
  final String papelOriginal;

  bool isEditando;
  bool controleGeral;
  bool seguranca;
  bool gerenciamento;
  String funcao;

  MembroPermissaoModel({
    required this.nome,
    this.papelOriginal = 'Membro da Família',
    this.isEditando = false,
    this.controleGeral = true,
    this.seguranca = false,
    this.gerenciamento = false,
    this.funcao = 'Membro Comum',
  });
}

class GestaoPermissoesController extends ChangeNotifier {
  final String nomeAdministrador;
  final List<MembroPermissaoModel> _membros = [];

  GestaoPermissoesController({
    required List<String> membros,
    required this.nomeAdministrador,
  }) {
    for (final nome in membros) {
      // Não adiciona o administrador à lista editável.
      if (nome == '$nomeAdministrador (você)' ||
          nome == nomeAdministrador) {
        continue;
      }

      _membros.add(MembroPermissaoModel(nome: nome));
    }
  }

  String get user1Funcao => 'Administrador - Acesso Total';

  List<MembroPermissaoModel> get membros => _membros;

  void alternarModoEdicao(int index) {
    if (!_indiceValido(index)) return;

    _membros[index].isEditando = !_membros[index].isEditando;
    notifyListeners();
  }

  void setControleGeral(int index, bool valor) {
    if (!_podeEditar(index)) return;

    _membros[index].controleGeral = valor;
    notifyListeners();
  }

  void setSeguranca(int index, bool valor) {
    if (!_podeEditar(index)) return;

    _membros[index].seguranca = valor;
    notifyListeners();
  }

  void setGerenciamento(int index, bool valor) {
    if (!_podeEditar(index)) return;

    _membros[index].gerenciamento = valor;
    notifyListeners();
  }

  void setFuncao(int index, String novaFuncao) {
    if (!_podeEditar(index)) return;

    _membros[index].funcao = novaFuncao;
    notifyListeners();
  }

  bool _indiceValido(int index) {
    return index >= 0 && index < _membros.length;
  }

  bool _podeEditar(int index) {
    return _indiceValido(index) && _membros[index].isEditando;
  }
}
