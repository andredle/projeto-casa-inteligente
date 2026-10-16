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
  // Lista de rotinas gerenciadas pelo controller
  final List<RotinaModelItem> _rotinas = [
    RotinaModelItem(
      titulo: 'Modo Noite',
      subtitulo: 'Aciona às 22:00',
      detalhes: 'Luzes da Sala desliga\nAr do Quarto liga',
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

  List<RotinaModelItem> get rotinas => _rotinas;

  // Método para alternar o estado de uma rotina específica e notificar a tela
  void toggleRotina(int index, bool valor) {
    _rotinas[index].ativo = valor;
    notifyListeners(); // Atualiza a interface de forma reativa conforme exigido pelo projeto
  }

  // Método para adicionar uma nova rotina à lista
  void adicionarRotina(String titulo, String subtitulo, String detalhes) {
    _rotinas.add(
      RotinaModelItem(
        titulo: titulo,
        subtitulo: subtitulo,
        detalhes: detalhes,
        icone: Icons.schedule,
        ativo: true,
      ),
    );
    notifyListeners();
  }
}