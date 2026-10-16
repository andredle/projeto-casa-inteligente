
import 'package:flutter/material.dart';

class RotinaModelItem {
  final String titulo;
  final String subtitulo;
  final String detalhes;
  final IconData icone;
  bool ativo;

  RotinaModelItem({
    required this.titulo,
    required this.subtitulo,
    required this.detalhes,
    required this.icone,
    required this.ativo,
  });
}

class RotinasController extends ChangeNotifier {
  final List<RotinaModelItem> _rotinas = [
    RotinaModelItem(
      titulo: 'Modo Noite',
      subtitulo: 'Aciona às 22:00',
      detalhes: 'Luzes da Sala desligam\nAr do Quarto liga',
      icone: Icons.nightlight_round,
      ativo: true,
    ),
    RotinaModelItem(
      titulo: 'Modo Ausente',
      subtitulo: 'Ativação Manual',
      detalhes: 'Porta da Frente tranca\nLuzes de presença ativam',
      icone: Icons.home_filled,
      ativo: false,
    ),
    RotinaModelItem(
      titulo: 'Bom Dia',
      subtitulo: 'Aciona às 07:00',
      detalhes: 'Persianas abrem\nCafeteira liga',
      icone: Icons.wb_sunny_rounded,
      ativo: true,
    ),
    RotinaModelItem(
      titulo: 'Modo Dia',
      subtitulo: 'Ativação Manual',
      detalhes: 'Desliga aparelhos desnecessários\nModo econômico ativado',
      icone: Icons.light_mode_rounded,
      ativo: false,
    ),
  ];

  List<RotinaModelItem> get rotinas =>
      List.unmodifiable(_rotinas);

  void toggleRotina(int index, bool valor) {
    if (index < 0 || index >= _rotinas.length) return;

    _rotinas[index].ativo = valor;
    notifyListeners();
  }

  bool adicionarRotina(
    String titulo,
    String subtitulo,
    String detalhes, {
    IconData icone = Icons.schedule,
  }) {
    final nomeLimpo = titulo.trim();

    if (nomeLimpo.isEmpty) return false;

    final jaExiste = _rotinas.any(
      (rotina) =>
          rotina.titulo.toLowerCase() == nomeLimpo.toLowerCase(),
    );

    if (jaExiste) return false;

    _rotinas.add(
      RotinaModelItem(
        titulo: nomeLimpo,
        subtitulo: subtitulo,
        detalhes: detalhes,
        icone: icone,
        ativo: true,
      ),
    );

    notifyListeners();
    return true;
  }

  void excluirRotina(int index) {
    if (index < 0 || index >= _rotinas.length) return;

    _rotinas.removeAt(index);
    notifyListeners();
  }
}
