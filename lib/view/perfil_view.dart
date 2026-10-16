import 'package:flutter/material.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  // Controlador para o campo de nome que pode ser editado
  final TextEditingController _nomeController =
      TextEditingController(text: 'User Teste');

  // E-mail fixo institucional (apenas visualização conforme RF005)[cite: 4]
  final String _emailUsuario = 'userteste@teste.com';

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _salvarAlteracoes() {
    String novoNome = _nomeController.text.trim();

    // 1. Verificar se o campo Nome foi preenchido[cite: 4]
    if (novoNome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: O campo Nome não pode estar vazio!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. Verificar se o nome informado possui uma quantidade mínima de 4 caracteres
    if (novoNome.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: O nome deve ter no mínimo 4 caracteres!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 4. Caso as informações sejam válidas: atualizar dados e exibir confirmação[cite: 4]
    // 5. O novo nome informado passa a ser utilizado nas demais telas (simulado via setState/feedback)
    setState(() {
      // Atualiza o estado local da tela
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sucesso! Perfil atualizado para: $novoNome'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'PERFIL DO USUÁRIO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Avatar do Usuário
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF1E3A8A),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Nome Atualizado Dinamicamente
            Text(
              _nomeController.text,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 32),

            // Campo Editável: Nome do Usuário
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NOME DO USUÁRIO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  TextField(
                    controller: _nomeController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.edit, color: Color(0xFF4C6EF5), size: 20),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Campo Bloqueado: E-mail (Apenas Visualização - RF005)[cite: 4]
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'E-MAIL (NÃO EDITÁVEL)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _emailUsuario,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const Icon(Icons.lock, color: Color(0xFF6B7280), size: 18),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botão Salvar Alterações
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C6EF5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: _salvarAlteracoes,
                child: const Text(
                  'SALVAR ALTERAÇÕES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Opção Cancelar
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'CANCELAR',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C6EF5),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: const Color(0xFF4C6EF5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            CircleAvatar(
              backgroundColor: Color(0xFF1E3A8A),
              child: Icon(Icons.mic, color: Colors.white),
            ),
            Icon(Icons.settings, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
