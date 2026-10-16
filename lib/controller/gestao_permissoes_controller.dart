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
    required this.papelOriginal,
    required this.isEditando,
    required this.controleGeral,
    required this.seguranca,
    required this.gerenciamento,
    required this.funcao,
  });
}

class GestaoPermissoesController extends ChangeNotifier {
  // Informação do Administrador Principal
  final String user1Funcao = 'Administrador - Acesso Total';

  // Lista gerida de membros editáveis (User 2 e User 3)
  final List<MembroPermissaoModel> _membros = [
    MembroPermissaoModel(
      nome: 'User 2',
      papelOriginal: 'Membro da Família',
      isEditando: false,
      controleGeral: true,
      seguranca: true,
      gerenciamento: false,
      funcao: 'Membro Sênior',
    ),
    MembroPermissaoModel(
      nome: 'User 3',
      papelOriginal: 'Membro da Família',
      isEditando: false,
      controleGeral: true,
      seguranca: false,
      gerenciamento: false,
      funcao: 'Criança / Restrito',
    ),
  ];

  List<MembroPermissaoModel> get membros => _membros;

  void alternarModoEdicao(int index) {
    _membros[index].isEditando = !_membros[index].isEditando;
    notifyListeners();
  }

  void setControleGeral(int index, bool valor) {
    if (_membros[index].isEditando) {
      _membros[index].controleGeral = valor;
      notifyListeners();
    }
  }

  void setSeguranca(int index, bool valor) {
    if (_membros[index].isEditando) {
      _membros[index].seguranca = valor;
      notifyListeners();
    }
  }

  void setGerenciamento(int index, bool valor) {
    if (_membros[index].isEditando) {
      _membros[index].gerenciamento = valor;
      notifyListeners();
    }
  }

  void setFuncao(int index, String novaFuncao) {
    if (_membros[index].isEditando) {
      _membros[index].funcao = novaFuncao;
      notifyListeners();
    }
  }
}
