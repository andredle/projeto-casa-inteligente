import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

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
          'SOBRE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logotipo da Aplicação
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4C6EF5),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.home_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Smart Home',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 20),

            // Card: Objetivo do Aplicativo
            _buildInfoCard(
              title: 'OBJETIVO DO APLICATIVO',
              content:
                  'Essa aplicação é uma solução inteligente para monitoramento e controle simplificado de dispositivos domésticos inteligentes em tempo real.\nProjeto de desenvolvimento apresentado à Faculdade de Tecnologia de Ribeirão Preto-SP, como parte dos requisitos para aprovação na disciplina Programação para Dispositivos Móveis, sob a orientação do Profº Rodrigo de Oliveira Plotze.',
              alignment: TextAlign.center
            ),
            const SizedBox(height: 14),

            // Card: Equipe de Desenvolvimento
            _buildTeamCard(
              title: 'EQUIPE DE DESENVOLVIMENTO',
              members: [
                'André Disposito Lé',
                'Julia Correa',
              ],
            ),
            const SizedBox(height: 14),

            // Card: Versão
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VERSÃO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.system_update_rounded,
                    color: Color(0xFF1E3A8A),
                    size: 28,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: const Color(0xFF4C6EF5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.add, color: Colors.white),
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

Widget _buildInfoCard({
  required String title, 
  required String content, 
  TextAlign alignment = TextAlign.center, // Permite escolher o alinhamento (centro por defeito)
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFE5E7EB),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFD1D5DB)),
    ),
    child: Column(
      // Alinha os elementos horizontalmente com base no alinhamento escolhido
      crossAxisAlignment: alignment == TextAlign.center 
          ? CrossAxisAlignment.center 
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B7280),
          ),
          textAlign: alignment,
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1F2937),
            height: 1.4,
          ),
          textAlign: alignment, // Centraliza ou alinha o texto do conteúdo
        ),
      ],
    ),
  );
}

  Widget _buildTeamCard({required String title, required List<String> members}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 4.5,
            ),
            itemCount: members.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFF1F2937),
                    child: Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      members[index],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
