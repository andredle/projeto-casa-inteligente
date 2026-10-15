
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final List<Map<String, dynamic>> dispositivos = [
    {
      'nome': 'Abajur',
      'tipo': 'Lâmpada inteligente',
      'comodo': 'Sala de estar',
      'icone': Icons.lightbulb_outline,
      'ligado': true,
    },
    {
      'nome': 'Ar do Vini',
      'tipo': 'Ar-condicionado',
      'comodo': 'Quarto 1',
      'icone': Icons.ac_unit,
      'ligado': false,
    },
    {
      'nome': 'Roteador',
      'tipo': 'Rede Wi-Fi',
      'comodo': 'Escritório',
      'icone': Icons.wifi,
      'ligado': true,
    },
    {
      'nome': 'Porta da frente',
      'tipo': 'Fechadura inteligente',
      'comodo': 'Hall',
      'icone': Icons.door_front_door_outlined,
      'ligado': false,
    },
  ];

  void alterarEstado(int indice, bool ligado) {
    if (indice < 0 || indice >= dispositivos.length) {
      return;
    }

    dispositivos[indice]['ligado'] = ligado;
    notifyListeners();
  }
}
