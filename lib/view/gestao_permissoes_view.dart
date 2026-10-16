
import 'package:flutter/material.dart';
import '../controller/gestao_permissoes_controller.dart';

class GestaoPermissoesView extends StatefulWidget {
  const GestaoPermissoesView({super.key});

  @override
  State<GestaoPermissoesView> createState() =>
      _GestaoPermissoesViewState();
}

class _GestaoPermissoesViewState extends State<GestaoPermissoesView> {
  static const Color corPrincipal = Color(0xFF4C6EF5);
  static const Color corTexto = Color(0xFF1F2937);
  static const Color corSecundaria = Color(0xFF6B7280);

  GestaoPermissoesController? _controller;
  String _nomeAdministrador = 'Usuário teste';
  String _nomeFamilia = 'Família';
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_inicializado) return;

    final argumentos = ModalRoute.of(context)?.settings.arguments;

    List<String> membros = [];
    String nomeFamilia = 'Família';

    if (argumentos is Map) {
      nomeFamilia = argumentos['nome']?.toString() ?? 'Família';

      final lista = argumentos['membros'];
      if (lista is List) {
        membros = lista.map((item) => item.toString()).toList();
      }
    }

    // Identifica o administrador pelo membro marcado como "(você)".
    final administradorEncontrado = membros.cast<String?>().firstWhere(
      (nome) => nome != null && nome.endsWith(' (você)'),
      orElse: () => null,
    );

    if (administradorEncontrado != null) {
      _nomeAdministrador = administradorEncontrado
          .replaceFirst(RegExp(r' \(você\)$'), '');
    }

    _nomeFamilia = nomeFamilia;

    _controller = GestaoPermissoesController(
      membros: membros,
      nomeAdministrador: _nomeAdministrador,
    );

    _controller!.addListener(_atualizarTela);
    _inicializado = true;
  }

  void _atualizarTela() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.removeListener(_atualizarTela);
    _controller?.dispose();
    super.dispose();
  }

  void _mostrarSeletorFuncao(String membroNome, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alterar função de $membroNome',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: corTexto,
                ),
              ),
              const SizedBox(height: 16),
              _opcaoFuncao(
                icone: Icons.child_care,
                titulo: 'Criança / Restrito',
                aoSelecionar: () {
                  _controller!.setFuncao(index, 'Criança / Restrito');
                  Navigator.pop(context);
                },
              ),
              _opcaoFuncao(
                icone: Icons.person,
                titulo: 'Membro Comum',
                aoSelecionar: () {
                  _controller!.setFuncao(index, 'Membro Comum');
                  Navigator.pop(context);
                },
              ),
              _opcaoFuncao(
                icone: Icons.star,
                titulo: 'Membro Sênior',
                aoSelecionar: () {
                  _controller!.setFuncao(index, 'Membro Sênior');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _opcaoFuncao({
    required IconData icone,
    required String titulo,
    required VoidCallback aoSelecionar,
  }) {
    return ListTile(
      leading: Icon(icone, color: corPrincipal),
      title: Text(titulo),
      onTap: aoSelecionar,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_inicializado || _controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final controller = _controller!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Gestão de Permissões'),
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _nomeFamilia,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: corTexto,
            ),
          ),
          const SizedBox(height: 16),

          _buildAdminCard(
            nome: '$_nomeAdministrador (você)',
            papel: 'Administrador Principal',
            funcaoTexto: controller.user1Funcao,
          ),

          const SizedBox(height: 16),

          if (controller.membros.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Esta família ainda não possui outros membros.',
                textAlign: TextAlign.center,
                style: TextStyle(color: corSecundaria),
              ),
            ),

          ...List.generate(controller.membros.length, (index) {
            final membro = controller.membros[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildMembroCard(
                nome: membro.nome,
                papel: membro.isEditando
                    ? 'Editando permissões...'
                    : membro.papelOriginal,
                isEditando: membro.isEditando,
                controleGeral: membro.controleGeral,
                seguranca: membro.seguranca,
                gerenciamento: membro.gerenciamento,
                funcaoTexto: membro.funcao,
                onControleGeralChanged: membro.isEditando
                    ? (valor) =>
                        controller.setControleGeral(index, valor)
                    : null,
                onSegurancaChanged: membro.isEditando
                    ? (valor) => controller.setSeguranca(index, valor)
                    : null,
                onGerenciamentoChanged: membro.isEditando
                    ? (valor) =>
                        controller.setGerenciamento(index, valor)
                    : null,
                onTapFuncao: membro.isEditando
                    ? () => _mostrarSeletorFuncao(membro.nome, index)
                    : null,
                onPressedEditarSalvar: () {
                  final estavaEditando = membro.isEditando;
                  controller.alternarModoEdicao(index);

                  if (estavaEditando) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Alterações de ${membro.nome} salvas com sucesso!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAdminCard({
    required String nome,
    required String papel,
    required String funcaoTexto,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _decoracaoCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFF1E3A8A),
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            nome,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: corTexto,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          color: corPrincipal,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      papel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: corSecundaria,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _funcaoContainer(
            texto: 'FUNÇÃO: $funcaoTexto',
            bloqueado: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMembroCard({
    required String nome,
    required String papel,
    required bool isEditando,
    required bool controleGeral,
    required bool seguranca,
    required bool gerenciamento,
    required String funcaoTexto,
    required ValueChanged<bool>? onControleGeralChanged,
    required ValueChanged<bool>? onSegurancaChanged,
    required ValueChanged<bool>? onGerenciamentoChanged,
    required VoidCallback? onTapFuncao,
    required VoidCallback onPressedEditarSalvar,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _decoracaoCard(
        editando: isEditando,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: corTexto,
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      papel,
                      style: TextStyle(
                        fontSize: 12,
                        color: isEditando ? corPrincipal : corSecundaria,
                        fontWeight: isEditando
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isEditando ? Colors.green : corPrincipal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 36),
                ),
                onPressed: onPressedEditarSalvar,
                icon: Icon(
                  isEditando ? Icons.check : Icons.edit,
                  size: 14,
                ),
                label: Text(
                  isEditando ? 'Salvar' : 'Editar',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _linhaPermissao(
            icone: Icons.lightbulb_outline,
            titulo: 'CONTROLE GERAL',
            descricao: 'Luzes, Clima',
            valor: controleGeral,
            onChanged: onControleGeralChanged,
          ),
          const SizedBox(height: 8),
          _linhaPermissao(
            icone: Icons.lock_outline,
            titulo: 'SEGURANÇA',
            descricao: 'Fechaduras, Câmeras',
            valor: seguranca,
            onChanged: onSegurancaChanged,
          ),
          const SizedBox(height: 8),
          _linhaPermissao(
            icone: Icons.group_outlined,
            titulo: 'GERENCIAMENTO',
            descricao: 'Convidar, Remover',
            valor: gerenciamento,
            onChanged: onGerenciamentoChanged,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onTapFuncao,
            child: _funcaoContainer(
              texto: 'FUNÇÃO: $funcaoTexto',
              bloqueado: !isEditando,
            ),
          ),
        ],
      ),
    );
  }

  Widget _linhaPermissao({
    required IconData icone,
    required String titulo,
    required String descricao,
    required bool valor,
    required ValueChanged<bool>? onChanged,
  }) {
    return Row(
      children: [
        Icon(icone, size: 20, color: corPrincipal),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B5563),
                ),
              ),
              Text(
                '($descricao)',
                style: const TextStyle(
                  fontSize: 11,
                  color: corSecundaria,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: valor,
          activeThumbColor: corPrincipal,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _funcaoContainer({
    required String texto,
    required bool bloqueado,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: bloqueado
            ? const Color(0xFFF3F4F6)
            : const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: bloqueado
              ? const Color(0xFFD1D5DB)
              : corPrincipal,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: corTexto,
              ),
            ),
          ),
          Icon(
            bloqueado ? Icons.lock : Icons.arrow_forward_ios,
            size: 14,
            color: corSecundaria,
          ),
        ],
      ),
    );
  }

  BoxDecoration _decoracaoCard({bool editando = false}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: editando
          ? Border.all(color: corPrincipal, width: 2)
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
