
import 'package:flutter/material.dart';

import '../controller/familias_controller.dart';
import 'gestao_permissoes_view.dart';

class FamiliasView extends StatefulWidget {
  const FamiliasView({super.key});

  @override
  State<FamiliasView> createState() => _FamiliasViewState();
}

class _FamiliasViewState extends State<FamiliasView> {
  static const Color corPrincipal = Color(0xFF4C6EF5);
  static const Color corCartao = Color(0xFFB9C7FF);
  static const Color corExpandido = Color(0xFFD6D6D6);

  late FamiliasController controller;
  bool inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!inicializado) {
      final argumentos = ModalRoute.of(context)?.settings.arguments;
      final nomeUsuario = argumentos is String
          ? argumentos
          : 'Usuário teste';

      controller = FamiliasController(
        nomeUsuario: nomeUsuario,
      );

      inicializado = true;
    }
  }

  @override
  void dispose() {
    if (inicializado) {
      controller.dispose();
    }

    super.dispose();
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<String?> pedirNome({
    required String titulo,
    required String rotulo,
    String valorInicial = '',
  }) async {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        String nomeDigitado = valorInicial;

        return AlertDialog(
          title: Text(titulo),
          content: TextFormField(
            initialValue: valorInicial,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: rotulo,
              border: const OutlineInputBorder(),
            ),
            onChanged: (valor) {
              nomeDigitado = valor;
            },
            onFieldSubmitted: (valor) {
              Navigator.of(dialogContext).pop(valor);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(nomeDigitado);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> mostrarDialogAdicionarFamilia() async {
    final nome = await pedirNome(
      titulo: 'Adicionar família',
      rotulo: 'Nome da família',
    );

    if (!mounted || nome == null) return;

    final adicionou = controller.adicionarFamilia(nome);

    mostrarMensagem(
      adicionou
          ? 'Família adicionada com sucesso!'
          : 'Nome vazio ou família já existente.',
    );
  }

  Future<void> configurarFamilia(int index) async {
    if (controller.familias[index]['admin'] != true) {
      mostrarMensagem(
        'Somente o administrador pode alterar a família.',
      );
      return;
    }

    final nomeAtual = controller.familias[index]['nome'] as String;

    final novoNome = await pedirNome(
      titulo: 'Configurações da família',
      rotulo: 'Nome da família',
      valorInicial: nomeAtual,
    );

    if (!mounted || novoNome == null) return;

    if (novoNome.trim().toLowerCase() == nomeAtual.toLowerCase()) {
      mostrarMensagem('Nenhuma alteração realizada.');
      return;
    }

    final alterou = controller.editarNomeFamilia(index, novoNome);

    mostrarMensagem(
      alterou
          ? 'Nome da família atualizado!'
          : 'Nome vazio ou já utilizado por outra família.',
    );
  }

  Future<void> adicionarMembroDialog(int index) async {
    if (controller.familias[index]['admin'] != true) {
      mostrarMensagem(
        'Somente o administrador pode adicionar membros.',
      );
      return;
    }

    final nome = await pedirNome(
      titulo: 'Adicionar membro',
      rotulo: 'Nome do membro',
    );

    if (!mounted || nome == null) return;

    final adicionou = controller.adicionarMembro(index, nome);

    mostrarMensagem(
      adicionou
          ? 'Membro adicionado com sucesso!'
          : 'Nome vazio ou membro já cadastrado.',
    );
  }

  
  void abrirGestaoPermissoes(int index) {
    final familia = controller.familias[index];

    if (familia['admin'] != true) {
      mostrarMensagem(
        'Somente o administrador pode gerenciar permissões.',
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GestaoPermissoesView(),
        settings: RouteSettings(
          arguments: {
            'nome': familia['nome'],
            'membros': List<String>.from(familia['membros']),
          },
        ),
      ),
    );
  }


  Future<void> gerenciarFamilia(int index) async {
    if (controller.familias[index]['admin'] != true) {
      mostrarMensagem(
        'Você não é administrador desta família.',
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AnimatedBuilder(
          animation: controller,
          builder: (contextDialogo, child) {
            if (index >= controller.familias.length) {
              return const AlertDialog(
                content: Text(
                  'Esta família não está mais disponível.',
                ),
              );
            }

            final familia = controller.familias[index];
            final membros =
                List<String>.from(familia['membros']);

            return AlertDialog(
              title: Text('Gerenciar ${familia['nome']}'),
              content: SizedBox(
                width: double.maxFinite,
                child: membros.isEmpty
                    ? const Text('Nenhum membro cadastrado.')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: membros.length,
                        itemBuilder: (context, membroIndex) {
                          final membro = membros[membroIndex];

                          final administrador = membro ==
                              '${controller.nomeUsuario} (você)';

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.person),
                            title: Text(membro),
                            subtitle: administrador
                                ? const Text('Administrador')
                                : null,
                            trailing: administrador
                                ? const Icon(
                                    Icons.workspace_premium,
                                    color: Colors.orange,
                                  )
                                : IconButton(
                                    tooltip: 'Remover membro',
                                    icon: const Icon(
                                      Icons.person_remove_outlined,
                                    ),
                                    onPressed: () {
                                      controller.removerMembro(
                                        index,
                                        membro,
                                      );
                                    },
                                  ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Fechar'),
                ),
                TextButton(
                  onPressed: () async {
                    final confirmar = await showDialog<bool>(
                      context: dialogContext,
                      builder: (confirmContext) {
                        return AlertDialog(
                          title: const Text('Excluir família?'),
                          content: const Text(
                            'Deseja realmente excluir esta família?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(confirmContext).pop(false);
                              },
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(confirmContext).pop(true);
                              },
                              child: const Text('Excluir'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmar != true || !mounted) return;

                    final excluiu = controller.excluirFamilia(index);

                    if (!excluiu) return;

                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }

                    if (mounted) {
                      mostrarMensagem('Família excluída.');
                    }
                  },
                  child: const Text(
                    'Excluir família',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Famílias'),
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.familias.length,
            itemBuilder: (context, index) {
              final familia = controller.familias[index];
              final bool expandida = familia['expandida'] as bool;

              final List<String> membros =
                  List<String>.from(familia['membros']);

              final bool souAdministrador =
                  familia['admin'] == true;

              return Card(
                color: expandida ? corExpandido : corCartao,
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.alternarFamilia(
                          index,
                          !expandida,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.groups,
                                color: corPrincipal,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          familia['nome'] as String,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      if (souAdministrador)
                                        const Icon(
                                          Icons.workspace_premium,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    familia['resumo'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              expandida
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (expandida) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          children: membros.map((membro) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  color: corPrincipal,
                                ),
                              ),
                              title: Text(membro),
                              dense: true,
                            );
                          }).toList(),
                        ),
                      ),
                      const Divider(height: 1),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            tooltip: 'Configurações',
                            onPressed: souAdministrador
                                ? () => configurarFamilia(index)
                                : null,
                            icon: const Icon(
                              Icons.settings_outlined,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Adicionar membro',
                            onPressed: souAdministrador
                                ? () => adicionarMembroDialog(index)
                                : null,
                            icon: const Icon(
                              Icons.person_add_alt_1,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Gerenciar família',
                            onPressed: souAdministrador
                                ? () => gerenciarFamilia(index)
                                : null,
                            icon: const Icon(
                              Icons.manage_accounts_outlined,
                            ),
                          ),
                          if (souAdministrador)
                            IconButton(
                              tooltip: 'Gestão de permissões',
                              onPressed: () =>
                                  abrirGestaoPermissoes(index),
                              icon: const Icon(
                                Icons.admin_panel_settings_outlined,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color(0xFFE1E6E6),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Adicionar família',
                onPressed: mostrarDialogAdicionarFamilia,
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 28,
                  color: corPrincipal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
