import 'package:flutter/material.dart';

class RotinasView extends StatefulWidget {
  const RotinasView({super.key});

  @override
  State<RotinasView> createState() => _RotinasViewState();
}

class _RotinasViewState extends State<RotinasView> {
  bool _modoNoite = true;
  bool _modoAusente = false;
  bool _bomDia = true;
  bool _modoDia = false;

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
          'ROTINAS E AUTOMAÇÕES',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildRotinaCard(
            titulo: 'Modo Noite',
            subtitulo: 'Aciona às 22:00',
            detalhes: 'Todas as luzes desligam\nAr do Quarto liga',
            icone: Icons.nightlight_round,
            ativo: _modoNoite,
            onChanged: (v) => setState(() => _modoNoite = v),
          ),
          const SizedBox(height: 14),

          _buildRotinaCard(
            titulo: 'Modo Ausente',
            subtitulo: 'Ativação Manual',
            detalhes: 'Porta da Frente tranca\nLuzes de presença ativam',
            icone: Icons.home_filled,
            ativo: _modoAusente,
            onChanged: (v) => setState(() => _modoAusente = v),
          ),
          const SizedBox(height: 14),

          _buildRotinaCard(
            titulo: 'Bom Dia',
            subtitulo: 'Aciona às 07:00',
            detalhes: 'Persianas abrem\nCafeteira liga',
            icone: Icons.wb_sunny_rounded,
            ativo: _bomDia,
            onChanged: (v) => setState(() => _bomDia = v),
          ),
          const SizedBox(height: 14),

          _buildRotinaCard(
            titulo: 'Modo Dia',
            subtitulo: 'Ativação Manual',
            detalhes: 'Desliga luzes\nModo econômico ativado',
            icone: Icons.light_mode_rounded,
            ativo: _modoDia,
            onChanged: (v) => setState(() => _modoDia = v),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4C6EF5),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionalidade para criar nova rotina')),
          );
        },
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
          ],
        ),
      ),
    );
  }

  Widget _buildRotinaCard({
    required String titulo,
    required String subtitulo,
    required String detalhes,
    required IconData icone,
    required bool ativo,
    required ValueChanged<bool> onChanged,
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
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFEEF2FF),
            child: Icon(icone, color: const Color(0xFF4C6EF5), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4C6EF5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detalhes,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: ativo,
            activeThumbColor: const Color(0xFF4C6EF5),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}