
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComodosController extends ChangeNotifier {
  final List<Map<String, dynamic>> comodos = [];

  bool carregando = true;
  String? erroCarregamento;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _usuarioId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _colecaoComodos =>
      _firestore.collection('comodos');

  // Recupera os cômodos em tempo real.
  Stream<QuerySnapshot<Map<String, dynamic>>> get streamComodos {
    final usuarioId = _usuarioId;

    if (usuarioId == null) {
      return const Stream.empty();
    }

    return _colecaoComodos
        .where('usuarioId', isEqualTo: usuarioId)
        .snapshots();
  }

  ComodosController() {
    carregarComodos();
  }

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

  // Cômodos e dispositivos iniciais de cada usuário.
  List<Map<String, dynamic>> _comodosIniciais() {
    return [
      {
        'nome': 'Sala de estar',
        'icone': Icons.weekend_outlined,
        'dispositivos': [
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
        'dispositivos': [
          {'nome': 'Luz principal', 'tipo': 'Luz', 'ligado': true},
          {'nome': 'Luz da bancada', 'tipo': 'Luz', 'ligado': false},
          {'nome': 'Geladeira', 'tipo': 'Eletrodoméstico', 'ligado': true},
          {'nome': 'Exaustor', 'tipo': 'Ventilação', 'ligado': false},
        ],
      },
      {
        'nome': 'Hall',
        'icone': Icons.door_front_door_outlined,
        'dispositivos': [
          {'nome': 'Luz do hall', 'tipo': 'Luz', 'ligado': true},
          {'nome': 'Sensor de presença', 'tipo': 'Sensor', 'ligado': false},
          {'nome': 'Luz auxiliar', 'tipo': 'Luz', 'ligado': false},
        ],
      },
      {
        'nome': 'Varanda',
        'icone': Icons.balcony,
        'dispositivos': [
          {'nome': 'Luz externa', 'tipo': 'Luz', 'ligado': false},
          {'nome': 'Ventilador', 'tipo': 'Ventilação', 'ligado': false},
        ],
      },
      {
        'nome': 'Quarto 1',
        'icone': Icons.bed_outlined,
        'dispositivos': [
          {'nome': 'Luz principal', 'tipo': 'Luz', 'ligado': true},
          {'nome': 'Abajur', 'tipo': 'Luz', 'ligado': true},
          {'nome': 'Ar-condicionado', 'tipo': 'Climatização', 'ligado': false},
        ],
      },
      {
        'nome': 'Escritório',
        'icone': Icons.computer_outlined,
        'dispositivos': [
          {'nome': 'Luz principal', 'tipo': 'Luz', 'ligado': false},
          {'nome': 'Computador', 'tipo': 'Eletrônico', 'ligado': false},
          {'nome': 'Monitor', 'tipo': 'Eletrônico', 'ligado': false},
          {'nome': 'Ventilador', 'tipo': 'Ventilação', 'ligado': false},
        ],
      },
    ];
  }

  // Converte o ícone para um identificador que pode ser salvo no Firestore.
  String _iconeParaId(IconData icone) {
    if (icone == Icons.weekend_outlined) return 'sala';
    if (icone == Icons.kitchen_outlined) return 'cozinha';
    if (icone == Icons.bed_outlined) return 'quarto';
    if (icone == Icons.computer_outlined) return 'escritorio';
    if (icone == Icons.bathroom_outlined) return 'banheiro';
    if (icone == Icons.balcony) return 'varanda';
    if (icone == Icons.door_front_door_outlined) return 'porta';

    return 'outro';
  }

  // Recupera o ícone a partir do identificador salvo.
  IconData _idParaIcone(String? id) {
    switch (id) {
      case 'sala':
        return Icons.weekend_outlined;
      case 'cozinha':
        return Icons.kitchen_outlined;
      case 'quarto':
        return Icons.bed_outlined;
      case 'escritorio':
        return Icons.computer_outlined;
      case 'banheiro':
        return Icons.bathroom_outlined;
      case 'varanda':
        return Icons.balcony;
      case 'porta':
        return Icons.door_front_door_outlined;
      default:
        return Icons.meeting_room_outlined;
    }
  }

  // Atualiza a lista local com os documentos recebidos em tempo real.
  void atualizarComodos(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documentos,
  ) {
    comodos.clear();

    for (final documento in documentos) {
      final dados = documento.data();

      final dispositivos = (dados['dispositivos'] as List<dynamic>? ?? [])
          .map((dispositivo) =>
              Map<String, dynamic>.from(dispositivo as Map))
          .toList();

      comodos.add({
        'id': documento.id,
        'nome': dados['nome'] ?? '',
        'icone': _idParaIcone(dados['icone'] as String?),
        'dispositivos': dispositivos,
      });
    }
  }

  // Carrega os cômodos do usuário ou cria os dados iniciais.
  Future<void> carregarComodos() async {
    carregando = true;
    erroCarregamento = null;
    notifyListeners();

    try {
      final usuarioId = _usuarioId;

      if (usuarioId == null) {
        throw Exception('Nenhum usuário está conectado.');
      }

      var resultado = await _colecaoComodos
          .where('usuarioId', isEqualTo: usuarioId)
          .get();

      // Se o usuário ainda não possui cômodos, cria os seis iniciais.
      if (resultado.docs.isEmpty) {
        final batch = _firestore.batch();

        for (final comodo in _comodosIniciais()) {
          final documento = _colecaoComodos.doc();

          batch.set(documento, {
            'nome': comodo['nome'],
            'icone': _iconeParaId(comodo['icone'] as IconData),
            'dispositivos': comodo['dispositivos'],
            'usuarioId': usuarioId,
            'criadoEm': FieldValue.serverTimestamp(),
            'atualizadoEm': FieldValue.serverTimestamp(),
          });
        }

        await batch.commit();

        resultado = await _colecaoComodos
            .where('usuarioId', isEqualTo: usuarioId)
            .get();
      }

      atualizarComodos(resultado.docs);
    } catch (e) {
      erroCarregamento = 'Não foi possível carregar os cômodos: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _dispositivosDoComodo(int index) {
    return comodos[index]['dispositivos']
        as List<Map<String, dynamic>>;
  }

  int quantidadeLigados(int index) {
    if (index < 0 || index >= comodos.length) return 0;

    final dispositivos = _dispositivosDoComodo(index);

    return dispositivos.where((d) => d['ligado'] == true).length;
  }

  Future<bool> adicionarComodo(String nome, IconData icone) async {
    final nomeLimpo = nome.trim();

    if (nomeLimpo.isEmpty || nomeExiste(nomeLimpo)) {
      return false;
    }

    final usuarioId = _usuarioId;
    if (usuarioId == null) return false;

    try {
      final documento = await _colecaoComodos.add({
        'nome': nomeLimpo,
        'icone': _iconeParaId(icone),
        'dispositivos': [],
        'usuarioId': usuarioId,
        'criadoEm': FieldValue.serverTimestamp(),
        'atualizadoEm': FieldValue.serverTimestamp(),
      });

      comodos.add({
        'id': documento.id,
        'nome': nomeLimpo,
        'icone': icone,
        'dispositivos': <Map<String, dynamic>>[],
      });

      notifyListeners();
      return true;
    } catch (e) {
      erroCarregamento = 'Não foi possível adicionar o cômodo: $e';
      return false;
    }
  }

  Future<bool> editarComodo(int index, String nome, IconData icone) async {
    final nomeLimpo = nome.trim();

    if (index < 0 ||
        index >= comodos.length ||
        nomeLimpo.isEmpty ||
        nomeExiste(nomeLimpo, ignorarIndex: index)) {
      return false;
    }

    try {
      final id = comodos[index]['id'] as String;

      await _colecaoComodos.doc(id).update({
        'nome': nomeLimpo,
        'icone': _iconeParaId(icone),
        'atualizadoEm': FieldValue.serverTimestamp(),
      });

      comodos[index]['nome'] = nomeLimpo;
      comodos[index]['icone'] = icone;

      notifyListeners();
      return true;
    } catch (e) {
      erroCarregamento = 'Não foi possível editar o cômodo: $e';
      return false;
    }
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

  Future<void> excluirComodo(int index) async {
    if (index < 0 || index >= comodos.length) return;

    try {
      final id = comodos[index]['id'] as String;

      await _colecaoComodos.doc(id).delete();

      comodos.removeAt(index);
      notifyListeners();
    } catch (e) {
      erroCarregamento = 'Não foi possível excluir o cômodo: $e';
      notifyListeners();
    }
  }

  Future<void> alternarDispositivo(
    int comodoIndex,
    int dispositivoIndex,
  ) async {
    if (comodoIndex < 0 || comodoIndex >= comodos.length) return;

    final dispositivos = _dispositivosDoComodo(comodoIndex);

    if (dispositivoIndex < 0 || dispositivoIndex >= dispositivos.length) {
      return;
    }

    final valorAnterior = dispositivos[dispositivoIndex]['ligado'] as bool;

    dispositivos[dispositivoIndex]['ligado'] = !valorAnterior;
    notifyListeners();

    try {
      final id = comodos[comodoIndex]['id'] as String;

      await _colecaoComodos.doc(id).update({
        'dispositivos': dispositivos,
        'atualizadoEm': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      dispositivos[dispositivoIndex]['ligado'] = valorAnterior;
      erroCarregamento = 'Não foi possível atualizar o dispositivo: $e';
      notifyListeners();
    }
  }

  Future<bool> adicionarDispositivo(
    int index,
    String nome,
    String tipo,
  ) async {
    if (index < 0 || index >= comodos.length || nome.trim().isEmpty) {
      return false;
    }

    final dispositivos = _dispositivosDoComodo(index);
    final nomeLimpo = nome.trim().toLowerCase();

    final existe = dispositivos.any(
      (d) => (d['nome'] as String).trim().toLowerCase() == nomeLimpo,
    );

    if (existe) return false;

    final novoDispositivo = <String, dynamic>{
      'nome': nome.trim(),
      'tipo': tipo,
      'ligado': false,
    };

    dispositivos.add(novoDispositivo);

    try {
      final id = comodos[index]['id'] as String;

      await _colecaoComodos.doc(id).update({
        'dispositivos': dispositivos,
        'atualizadoEm': FieldValue.serverTimestamp(),
      });

      notifyListeners();
      return true;
    } catch (e) {
      dispositivos.removeLast();
      erroCarregamento = 'Não foi possível adicionar o dispositivo: $e';
      return false;
    }
  }

  Future<void> excluirDispositivo(
    int comodoIndex,
    int dispositivoIndex,
  ) async {
    if (comodoIndex < 0 || comodoIndex >= comodos.length) return;

    final dispositivos = _dispositivosDoComodo(comodoIndex);

    if (dispositivoIndex < 0 || dispositivoIndex >= dispositivos.length) {
      return;
    }

    final removido = dispositivos.removeAt(dispositivoIndex);

    try {
      final id = comodos[comodoIndex]['id'] as String;

      await _colecaoComodos.doc(id).update({
        'dispositivos': dispositivos,
        'atualizadoEm': FieldValue.serverTimestamp(),
      });

      notifyListeners();
    } catch (e) {
      dispositivos.insert(dispositivoIndex, removido);
      erroCarregamento = 'Não foi possível excluir o dispositivo: $e';
      notifyListeners();
    }
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
