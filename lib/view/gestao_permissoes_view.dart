import 'package:flutter/material.dart';
import '../controller/gestao_permissoes_controller.dart'; // Ajuste o caminho se necessário

class GestaoPermissoesView extends StatefulWidget {
  const GestaoPermissoesView({super.key});

  @override
  State<GestaoPermissoesView> createState() => _GestaoPermissoesViewState();
}

class _GestaoPermissoesViewState extends State<GestaoPermissoesView> {
  // Instância do Controller
  final GestaoPermissoesController _controller = GestaoPermissoesController();

  @override
  void initState() {
    super.initState();
    // Ouve as alterações do controller para redesenhar a tela reativamente
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _mostrarSeletorFuncao(String membroNome, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alterar Função de $membroNome',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.child_care, color: Color(0xFF4C6EF5)),
                title: const Text('Criança / Restrito'),
                onTap: () {
                  _controller.setFuncao(index, 'Criança / Restrito');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Color(0xFF4C6EF5)),
                title: const Text('Membro Comum'),
                onTap: () {
                  _controller.setFuncao(index, 'Membro Comum');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.star, color: Color(0xFF4C6EF5)),
                title: const Text('Membro Sênior'),
                onTap: () {
                  _controller.setFuncao(index, 'Membro Sênior');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Membro 2 e Membro 3 obtidos diretamente do controller
    final user2 = _controller.membros[0];
    final user3 = _controller.membros[1];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C6EF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'GESTÃO DE PERMISSÕES',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAdminCard(
              nome: 'User 1 (você)',
              papel: 'Administrador Principal',
              funcaoTexto: _controller.user1Funcao,
            ),
            const SizedBox(height: 16),

            _buildMembroCard(
              nome: user2.nome,
              papel: user2.isEditando ? 'Editando Permissões...' : 'Membro da Família',
              isAdm: false,
              isEditando: user2.isEditando,
              controleGeral: user2.controleGeral,
              onControleGeralChanged: user2.isEditando ? (v) => _controller.setControleGeral(0, v) : null,
              seguranca: user2.seguranca,
              onSegurancaChanged: user2.isEditando ? (v) => _controller.setSeguranca(0, v) : null,
              gerenciamento: user2.gerenciamento,
              onGerenciamentoChanged: user2.isEditando ? (v) => _controller.setGerenciamento(0, v) : null,
              funcaoTexto: user2.funcao,
              onTapFuncao: user2.isEditando ? () => _mostrarSeletorFuncao(user2.nome, 0) : null,
              onPressedEditarSalvar: () {
                _controller.alternarModoEdicao(0);
                if (!user2.isEditando) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Alterações de ${user2.nome} salvas com sucesso!'), backgroundColor: Colors.green),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            _buildMembroCard(
              nome: user3.nome,
              papel: user3.isEditando ? 'Editando Permissões...' : 'Membro da Família',
              isAdm: false,
              isEditando: user3.isEditando,
              controleGeral: user3.controleGeral,
              onControleGeralChanged: user3.isEditando ? (v) => _controller.setControleGeral(1, v) : null,
              seguranca: user3.seguranca,
              onSegurancaChanged: user3.isEditando ? (v) => _controller.setSeguranca(1, v) : null,
              gerenciamento: user3.gerenciamento,
              onGerenciamentoChanged: user3.isEditando ? (v) => _controller.setGerenciamento(1, v) : null,
              funcaoTexto: user3.funcao,
              onTapFuncao: user3.isEditando ? () => _mostrarSeletorFuncao(user3.nome, 1) : null,
              onPressedEditarSalvar: () {
                _controller.alternarModoEdicao(1);
                if (!user3.isEditando) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Alterações de ${user3.nome} salvas com sucesso!'), backgroundColor: Colors.green),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFF1E3A8A),
                child: Icon(Icons.person, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, color: Color(0xFF4C6EF5), size: 16),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      papel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD1D5DB)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FUNÇÃO: $funcaoTexto',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const Icon(Icons.lock, size: 14, color: Color(0xFF6B7280)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembroCard({
    required String nome,
    required String papel,
    required bool isAdm,
    required bool isEditando,
    required bool controleGeral,
    required ValueChanged<bool>? onControleGeralChanged,
    required bool seguranca,
    required ValueChanged<bool>? onSegurancaChanged,
    required bool gerenciamento,
    required ValueChanged<bool>? onGerenciamentoChanged,
    required String funcaoTexto,
    required VoidCallback? onTapFuncao,
    required VoidCallback? onPressedEditarSalvar,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isEditando ? Border.all(color: const Color(0xFF4C6EF5), width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: isAdm ? const Color(0xFF1E3A8A) : const Color(0xFF1F2937),
                child: const Icon(Icons.person, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        if (isAdm) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, color: Color(0xFF4C6EF5), size: 16),
                        ]
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      papel,
                      style: TextStyle(
                        fontSize: 12,
                        color: isEditando ? const Color(0xFF4C6EF5) : const Color(0xFF6B7280),
                        fontWeight: isEditando ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (onPressedEditarSalvar != null)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditando ? Colors.green : const Color(0xFF4C6EF5),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: onPressedEditarSalvar,
                  icon: Icon(isEditando ? Icons.check : Icons.edit, size: 14, color: Colors.white),
                  label: Text(
                    isEditando ? 'Salvar' : 'Editar',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 18, color: Color(0xFF4C6EF5)),
                  SizedBox(width: 8),
                  Text(
                    'CONTROLE GERAL\n(Luzes, Clima)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
                  ),
                ],
              ),
              Switch(
                value: controleGeral,
                activeThumbColor: const Color(0xFF4C6EF5),
                onChanged: onControleGeralChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.lock_outline, size: 18, color: Color(0xFF4C6EF5)),
                  SizedBox(width: 8),
                  Text(
                    'SEGURANÇA\n(Fechaduras, Câmeras)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
                  ),
                ],
              ),
              Switch(
                value: seguranca,
                activeThumbColor: const Color(0xFF4C6EF5),
                onChanged: onSegurancaChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.group_outlined, size: 18, color: Color(0xFF4C6EF5)),
                  SizedBox(width: 8),
                  Text(
                    'GERENCIAMENTO\n(Convidar, Remover)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
                  ),
                ],
              ),
              Switch(
                value: gerenciamento,
                activeThumbColor: const Color(0xFF4C6EF5),
                onChanged: onGerenciamentoChanged,
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onTapFuncao,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isAdm || !isEditando ? const Color(0xFFF3F4F6) : const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isEditando ? const Color(0xFF4C6EF5) : const Color(0xFFD1D5DB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'FUNÇÃO: $funcaoTexto',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isAdm ? const Color(0xFF6B7280) : const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isAdm || !isEditando ? Icons.lock : Icons.arrow_forward_ios,
                    size: 14,
                    color: const Color(0xFF6B7280),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
