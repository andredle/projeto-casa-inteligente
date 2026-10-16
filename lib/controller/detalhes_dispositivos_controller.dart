import 'package:flutter/material.dart';

class DetalhesDispositivosController extends ChangeNotifier {
  double _temperaturaAtual = 23.0;
  bool _isLigado = true;
  String _modoSelecionado = 'Resfriar';
  String _velocidadeFan = 'Média';

  double get temperaturaAtual => _temperaturaAtual;
  bool get isLigado => _isLigado;
  String get modoSelecionado => _modoSelecionado;
  String get velocidadeFan => _velocidadeFan;

  void incrementarTemperatura() {
    if (_isLigado && _temperaturaAtual < 28) {
      _temperaturaAtual += 1;
      notifyListeners();
    }
  }

  void decrementarTemperatura() {
    if (_isLigado && _temperaturaAtual > 18) {
      _temperaturaAtual -= 1;
      notifyListeners();
    }
  }

  void setTemperatura(double valor) {
    if (_isLigado) {
      _temperaturaAtual = valor;
      notifyListeners();
    }
  }

  void toggleLigado(bool valor) {
    _isLigado = valor;
    notifyListeners();
  }

  void setModo(String modo) {
    if (_isLigado) {
      _modoSelecionado = modo;
      notifyListeners();
    }
  }

  void setVelocidadeFan(String velocidade) {
    if (_isLigado) {
      _velocidadeFan = velocidade;
      notifyListeners();
    }
  }
}
