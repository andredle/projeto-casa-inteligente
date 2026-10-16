
import 'package:flutter/material.dart';
import '../controller/rotinas_controller.dart';

class RotinasView extends StatefulWidget {
  const RotinasView({super.key});

  @override
  State<RotinasView> createState() => _RotinasViewState();
}

class _RotinasViewState extends State<RotinasView> {
  static const Color _azul = Color(0xFF4C6EF5);
  static const Color _fundo = Color(0xFFF5F5F7);

  late final RotinasController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RotinasController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _abrirFormulario() async {
    final resultado = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => const _FormularioRotinaDialog(),
    );

    if (!mounted || resultado == null) return;

    final titulo = resultado['titulo'] as String;
    final dispositivo = resultado['dispositivo'] as String;
    final acao = resultado['acao'] as String;
    final manual = resultado['manual'] as bool;
    final horario = resultado['horario'] as TimeOfDay?;

    final subtitulo = manual
        ? 'Ativação Manual'
        : 'Aciona às ${horario!.format(context)}';

    final detalhes = '$dispositivo: ${acao.toLowerCase()}';

    final adicionada = _controller.adicionarRotina(
      titulo,
      subtitulo,
      detalhes,
      icone: _iconeDoDispositivo(dispositivo),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            adicionada
                ? 'Rotina criada com sucesso!'
                : 'Já existe uma rotina com esse nome.',
          ),
        ),
      );
  }

  IconData _iconeDoDispositivo(String dispositivo) {
    switch (dispositivo) {
      case 'Luzes da Sala':
      case 'Lâmpada':
        return Icons.lightbulb_outline;
      case 'Ar-condicionado':
        return Icons.ac_unit;
      case 'Porta da Frente':
        return Icons.door_front_door_outlined;
      case 'Persianas':
        return Icons.blinds_outlined;
      case 'Cafeteira':
        return Icons.coffee_outlined;
      default:
        return Icons.devices_outlined;
    }
  }

  Future<bool> _confirmarExclusao(String titulo) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir rotina?'),
        content: Text('Deseja excluir a rotina "$titulo"?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    return confirmado ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      appBar: AppBar(
        title: const Text('Rotinas e Automações'),
        backgroundColor: _azul,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final rotinas = _controller.rotinas;

          if (rotinas.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_outlined,
                      size: 56,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Nenhuma rotina cadastrada',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Toque no botão + para criar sua primeira rotina.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rotinas.length,
            itemBuilder: (context, index) {
              final rotina = rotinas[index];

              return Padding(
                key: ValueKey(
                  '${rotina.titulo}_$index',
                ),
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildRotinaCard(
                  rotina: rotina,
                  index: index,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _azul,
        foregroundColor: Colors.white,
        tooltip: 'Criar rotina',
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRotinaCard({
    required RotinaModelItem rotina,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFEEF2FF),
            child: Icon(
              rotina.icone,
              color: _azul,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rotina.titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  rotina.subtitulo,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _azul,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  rotina.detalhes,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: rotina.ativo,
                activeThumbColor: _azul,
                onChanged: (valor) {
                  _controller.toggleRotina(index, valor);
                },
              ),
              IconButton(
                tooltip: 'Excluir rotina',
                visualDensity: VisualDensity.compact,
                iconSize: 20,
                onPressed: () async {
                  final titulo = rotina.titulo;
                  final confirmar =
                      await _confirmarExclusao(titulo);

                  if (!mounted || !confirmar) return;

                  _controller.excluirRotina(index);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormularioRotinaDialog extends StatefulWidget {
  const _FormularioRotinaDialog();

  @override
  State<_FormularioRotinaDialog> createState() =>
      _FormularioRotinaDialogState();
}

class _FormularioRotinaDialogState
    extends State<_FormularioRotinaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  String _dispositivo = 'Luzes da Sala';
  String _acao = 'Ligar';
  bool _manual = true;
  TimeOfDay _horario = const TimeOfDay(hour: 22, minute: 0);

  static const List<String> _dispositivos = [
    'Luzes da Sala',
    'Lâmpada',
    'Ar-condicionado',
    'Porta da Frente',
    'Persianas',
    'Cafeteira',
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _selecionarHorario() async {
    final horarioSelecionado = await showTimePicker(
      context: context,
      initialTime: _horario,
      helpText: 'Escolha o horário da rotina',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (horarioSelecionado != null && mounted) {
      setState(() {
        _horario = horarioSelecionado;
      });
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      <String, dynamic>{
        'titulo': _nomeController.text.trim(),
        'dispositivo': _dispositivo,
        'acao': _acao,
        'manual': _manual,
        'horario': _manual ? null : _horario,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova rotina'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nome da rotina',
                  hintText: 'Ex.: Cheguei em casa',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Digite um nome para a rotina.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _dispositivo,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Dispositivo',
                  border: OutlineInputBorder(),
                ),
                items: _dispositivos.map((dispositivo) {
                  return DropdownMenuItem<String>(
                    value: dispositivo,
                    child: Text(
                      dispositivo,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (valor) {
                  if (valor == null) return;
                  setState(() => _dispositivo = valor);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _acao,
                decoration: const InputDecoration(
                  labelText: 'Ação',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Ligar',
                    child: Text('Ligar'),
                  ),
                  DropdownMenuItem(
                    value: 'Desligar',
                    child: Text('Desligar'),
                  ),
                ],
                onChanged: (valor) {
                  if (valor == null) return;
                  setState(() => _acao = valor);
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Quando executar?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              RadioListTile<bool>(
                contentPadding: EdgeInsets.zero,
                title: const Text('Ativação manual'),
                value: true,
                groupValue: _manual,
                onChanged: (valor) {
                  if (valor == null) return;
                  setState(() => _manual = valor);
                },
              ),
              RadioListTile<bool>(
                contentPadding: EdgeInsets.zero,
                title: const Text('Em um horário'),
                value: false,
                groupValue: _manual,
                onChanged: (valor) {
                  if (valor == null) return;
                  setState(() => _manual = valor);
                },
              ),
              if (!_manual)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _selecionarHorario,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      'Horário: ${_horario.format(context)}',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _salvar,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF4C6EF5),
            foregroundColor: Colors.white,
          ),
          child: const Text('Criar rotina'),
        ),
      ],
    );
  }
}
