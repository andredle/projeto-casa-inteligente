
import 'package:flutter/material.dart';
import '../controller/comodos_controller.dart';

class ComodosView extends StatefulWidget {
  const ComodosView({super.key});

  @override
  State<ComodosView> createState() => _ComodosViewState();
}

class _ComodosViewState extends State<ComodosView> {
  static const Color corPrincipal = Color(0xFF4C6EF5);

  late final ComodosController controller;

  @override
  void initState() {
    super.initState();
    controller = ComodosController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> formularioComodo({int? index}) async {
    final nomeController = TextEditingController(
      text: index == null
          ? ''
          : controller.comodos[index]['nome'] as String,
    );

    IconData iconeSelecionado = index == null
        ? Icons.meeting_room_outlined
        : controller.comodos[index]['icone'] as IconData;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final resultado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, atualizarDialog) => AlertDialog(
          title: Text(index == null ? 'Novo cômodo' : 'Editar cômodo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Nome do cômodo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Ícone'),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: controller.iconesDisponiveis.map((item) {
                    final icone = item['icone'] as IconData;

                    return ChoiceChip(
                      label: Icon(icone),
                      selected: iconeSelecionado == icone,
                      onSelected: (_) {
                        atualizarDialog(() {
                          iconeSelecionado = icone;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: corPrincipal,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final sucesso = index == null
                    ? controller.adicionarComodo(
                        nomeController.text,
                        iconeSelecionado,
                      )
                    : controller.editarComodo(
                        index,
                        nomeController.text,
                        iconeSelecionado,
                      );

                if (!sucesso) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Informe um nome válido e não repetido.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext, true);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );

    nomeController.dispose();

    if (resultado == true && mounted) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Cômodo salvo com sucesso!')),
      );
    }
  }

  Future<void> excluirComodo(int index) async {
    final nome = controller.comodos[index]['nome'] as String;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir cômodo'),
        content: Text('Deseja excluir "$nome" e seus dispositivos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      controller.excluirComodo(index);
    }
  }

  void mostrarOpcoes(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar cômodo'),
              onTap: () {
                Navigator.pop(context);
                formularioComodo(index: index);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              title: const Text('Excluir cômodo'),
              onTap: () {
                Navigator.pop(context);
                excluirComodo(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  
  Future<void> formularioDispositivo(int comodoIndex) async {
    if (comodoIndex < 0 || comodoIndex >= controller.comodos.length) {
      return;
    }

    final nomeController = TextEditingController();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    String tipoSelecionado = 'Luz';

    const tipos = [
      'Luz',
      'Ventilação',
      'Climatização',
      'Eletrônico',
      'Sensor',
      'Eletrodoméstico',
      'Outro',
    ];

    final resultado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, atualizarDialog) => AlertDialog(
          title: const Text('Novo dispositivo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nome do dispositivo',
                    hintText: 'Ex.: Lâmpada da mesa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: tipoSelecionado,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                  ),
                  items: tipos.map((tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    if (valor != null) {
                      atualizarDialog(() {
                        tipoSelecionado = valor;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: corPrincipal,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final nome = nomeController.text.trim();

                if (nome.isEmpty) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Digite um nome para o dispositivo.',
                      ),
                    ),
                  );
                  return;
                }

                final sucesso = controller.adicionarDispositivo(
                  comodoIndex,
                  nome,
                  tipoSelecionado,
                );

                if (!sucesso) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Não foi possível adicionar. '
                        'Verifique se o nome já existe.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext, true);
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );

    nomeController.dispose();

    if (!mounted) return;

    if (resultado == true) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Dispositivo adicionado com sucesso!'),
        ),
      );
    }
  }


  Future<void> mostrarDispositivos(int index) async {
    if (index < 0 || index >= controller.comodos.length) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (index >= controller.comodos.length) {
            return const AlertDialog(
              content: Text('Este cômodo não está mais disponível.'),
            );
          }

          final comodo = controller.comodos[index];
          final dispositivos =
              comodo['dispositivos'] as List<Map<String, dynamic>>;
          final ligados = controller.quantidadeLigados(index);

          return AlertDialog(
            title: Text(comodo['nome'] as String),
            content: SizedBox(
              width: 400,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 450),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$ligados de ${dispositivos.length} dispositivos ligados',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (dispositivos.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nenhum dispositivo cadastrado.'),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dispositivos.length,
                          itemBuilder: (context, dispositivoIndex) {
                            final dispositivo =
                                dispositivos[dispositivoIndex];
                            final ligado =
                                dispositivo['ligado'] as bool;

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                controller.iconeDispositivo(
                                  dispositivo['tipo'] as String,
                                ),
                                color: ligado ? corPrincipal : Colors.grey,
                              ),
                              title: Text(
                                dispositivo['nome'] as String,
                              ),
                              subtitle: Text(
                                ligado ? 'Ligado' : 'Desligado',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: ligado,
                                    activeThumbColor: corPrincipal,
                                    onChanged: (_) {
                                      controller.alternarDispositivo(
                                        index,
                                        dispositivoIndex,
                                      );
                                    },
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (opcao) {
                                      if (opcao == 'excluir') {
                                        controller.excluirDispositivo(
                                          index,
                                          dispositivoIndex,
                                        );
                                      }
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                        value: 'excluir',
                                        child: Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  formularioDispositivo(index);
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar dispositivo'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FA),
      appBar: AppBar(
        title: const Text('Cômodos'),
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.comodos.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum cômodo cadastrado.\nToque em + para adicionar.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.comodos.length,
            itemBuilder: (context, index) {
              final comodo = controller.comodos[index];
              final dispositivos =
                  comodo['dispositivos'] as List<Map<String, dynamic>>;
              final total = dispositivos.length;
              final ligados = controller.quantidadeLigados(index);

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 14),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFFDDF1F0),
                    child: Icon(
                      comodo['icone'] as IconData,
                      color: corPrincipal,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    comodo['nome'] as String,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '$total ${total == 1 ? 'dispositivo' : 'dispositivos'}'
                      ' • $ligados ligados',
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Opções',
                        onPressed: () => mostrarOpcoes(index),
                        icon: const Icon(Icons.more_vert),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => mostrarDispositivos(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
        onPressed: () => formularioComodo(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
