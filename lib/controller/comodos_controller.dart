
import 'package:flutter/material.dart';

class ComodosController extends ChangeNotifier {
  final List<Map<String, dynamic>> comodos = [
    {
      'nome': 'Sala de estar',
      'icone': Icons.weekend_outlined,
      'dispositivos': <Map<String, dynamic>>[
        {'nome': 'Lâmpada principal', 'tipo': 'Luz', 'ligado': true},
        {'nome': 'Luminária', 'tipo': 'Luz', 'ligado': false},
        {'nome': 'Ventilador', 'tipo': 'Ventilação', 'ligado': true},
        {'nome': 'Televisão', 'tipo': 'Eletrônico', 'ligado': false},
        {'nome': 'Ar-condicionado', 'tipo': 'Climatização', 'ligado': false},
        {'nome': 'Luz ambiente', 'tipo': 'Luz', 'ligado': false},
      ],
    },
    {
      'nome': 'Cozinha',
      'icone': Icons.kitchen_outlined,
      'dispositivos': <Map<String, dynamic>>[
        {'nome': 'Luz principal', 'tipo': 'Luz', 'ligado': true},
        {'nome': 'Luz da bancada', 'tipo': 'Luz', 'ligado': false},
        {'nome': 'Geladeira', 'tipo': 'Eletrodoméstico', 'ligado': true},
        {'nome': 'Exaustor', 'tipo': 'Ventilação', 'ligado': false},
      ],
    },
    {
      'nome': 'Hall',
      'icone': Icons.door_front_door_outlined,
      'dispositivos': <Map<String, dynamic>>[
        {'nome': 'Luz do hall', 'tipo': 'Luz', 'ligado': true},
        {'nome': 'Sensor de presença', 'tipo': 'Sensor', 'ligado': false},
        {'nome': 'Luz auxiliar', 'tipo': 'Luz', 'ligado': false},
      ],
    },
    {
      'nome': 'Varanda',
      'icone': Icons.balcony,
      'dispositivos': <Map<String, dynamic>>[
        {'nome': 'Luz externa', 'tipo': 'Luz', 'ligado': false},
        {'nome': 'Ventilador', 'tipo': 'Ventilação', 'ligado': false},
      ],
    },
    {
      'nome': 'Quarto 1',
      'icone': Icons.bed_outlined,
      'dispositivos': <Map<String, dynamic>>[
        {'nome': 'Luz principal', 'tipo': 'Luz', 'ligado': true},
        {'nome': 'Abajur', 'tipo': 'Luz', 'ligado': true},
        {'nome': 'Ar-condicionado', 'tipo': 'Climatização', 'ligado': false},
      ],
    },
    {
      'nome': 'Escritório',
      'icone': Icons.computer_outlined,
      'dispositivos': <Map<String, dynamic>>[
        {'nome': 'Luz principal', 'tipo': 'Luz', 'ligado': false},
        {'nome': 'Computador', 'tipo': 'Eletrônico', 'ligado': false},
        {'nome': 'Monitor', 'tipo': 'Eletrônico', 'ligado': false},
        {'nome': 'Ventilador', 'tipo': 'Ventilação', 'ligado': false},
      ],
    },
  ];

  final List<Map<String, dynamic>> iconesDisponiveis = [
    {'nome': 'Sala', 'icone': Icons.weekend_outlined},
    {'nome': 'Cozinha', 'icone': Icons.kitchen_outlined},
    {'nome': 'Quarto', 'icone': Icons.bed_outlined},
    {'nome': 'Escritório', 'icone': Icons.computer_outlined},
    {'nome': 'Banheiro', 'icone': Icons.bathroom_outlined},
    {'nome': 'Varanda', 'icone': Icons.balcony},
    {'nome': 'Porta', 'icone': Icons.door_front_door_outlined},
    {'nome': 'Outro', 'icone': Icons.meeting_room_outlined},
  ];

  List<Map<String, dynamic>> _dispositivosDoComodo(int index) {
    return comodos[index]['dispositivos'] as List<Map<String, dynamic>>;
  }

  int quantidadeLigados(int index) {
    if (index < 0 || index >= comodos.length) return 0;

    final dispositivos = _dispositivosDoComodo(index);

    return dispositivos.where((d) => d['ligado'] == true).length;
  }

  bool adicionarComodo(String nome, IconData icone) {
    final nomeLimpo = nome.trim();

    if (nomeLimpo.isEmpty || nomeExiste(nomeLimpo)) {
      return false;
    }

    comodos.add({
      'nome': nomeLimpo,
      'icone': icone,
      'dispositivos': <Map<String, dynamic>>[],
    });

    notifyListeners();
    return true;
  }

  bool editarComodo(int index, String nome, IconData icone) {
    final nomeLimpo = nome.trim();

    if (index < 0 ||
        index >= comodos.length ||
        nomeLimpo.isEmpty ||
        nomeExiste(nomeLimpo, ignorarIndex: index)) {
      return false;
    }

    comodos[index]['nome'] = nomeLimpo;
    comodos[index]['icone'] = icone;

    notifyListeners();
    return true;
  }

  bool nomeExiste(String nome, {int? ignorarIndex}) {
    for (int i = 0; i < comodos.length; i++) {
      if (i == ignorarIndex) continue;

      if ((comodos[i]['nome'] as String).toLowerCase() ==
          nome.trim().toLowerCase()) {
        return true;
      }
    }

    return false;
  }

  void excluirComodo(int index) {
    if (index < 0 || index >= comodos.length) return;

    comodos.removeAt(index);
    notifyListeners();
  }

  void alternarDispositivo(int comodoIndex, int dispositivoIndex) {
    if (comodoIndex < 0 || comodoIndex >= comodos.length) return;

    final dispositivos = _dispositivosDoComodo(comodoIndex);

    if (dispositivoIndex < 0 || dispositivoIndex >= dispositivos.length) {
      return;
    }

    dispositivos[dispositivoIndex]['ligado'] =
        !(dispositivos[dispositivoIndex]['ligado'] as bool);

    notifyListeners();
  }

  bool adicionarDispositivo(int index, String nome, String tipo) {
    if (index < 0 || index >= comodos.length || nome.trim().isEmpty) {
      return false;
    }

    final dispositivos = _dispositivosDoComodo(index);
    final nomeLimpo = nome.trim().toLowerCase();

    final existe = dispositivos.any(
      (d) => (d['nome'] as String).trim().toLowerCase() == nomeLimpo,
    );

    if (existe) return false;

    dispositivos.add(<String, dynamic>{
      'nome': nome.trim(),
      'tipo': tipo,
      'ligado': false,
    });

    notifyListeners();
    return true;
  }

  void excluirDispositivo(int comodoIndex, int dispositivoIndex) {
    if (comodoIndex < 0 || comodoIndex >= comodos.length) return;

    final dispositivos = _dispositivosDoComodo(comodoIndex);

    if (dispositivoIndex < 0 || dispositivoIndex >= dispositivos.length) {
      return;
    }

    dispositivos.removeAt(dispositivoIndex);
    notifyListeners();
  }

  IconData iconeDispositivo(String tipo) {
    switch (tipo) {
      case 'Luz':
        return Icons.lightbulb_outline;
      case 'Ventilação':
        return Icons.air;
      case 'Climatização':
        return Icons.ac_unit;
      case 'Eletrônico':
        return Icons.devices_outlined;
      case 'Sensor':
        return Icons.sensors;
      case 'Eletrodoméstico':
        return Icons.kitchen_outlined;
      default:
        return Icons.power_outlined;
    }
  }
}
