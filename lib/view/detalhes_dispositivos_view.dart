import 'package:flutter/material.dart';

class DetalhesDispositivoView extends StatefulWidget {
  const DetalhesDispositivoView({super.key});

  @override
  State<DetalhesDispositivoView> createState() => _DetalhesDispositivoViewViewState();
}

class _DetalhesDispositivoViewViewState extends State<DetalhesDispositivoView> {
  double _temperaturaAtual = 23.0;
  
  bool _isLigado = true;

  String _modoSelecionado = 'Resfriar';

  String _velocidadeFan = 'Média';

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
          'AR DO VINI – DETALHES',
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
            const Icon(
              Icons.ac_unit,
              size: 56,
              color: Color(0xFF4C6EF5),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ar do Vini',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Quarto 1\nAr-condicionado',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),

            Container(
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
                children: [
                  const Text(
                    'TEMPERATURA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B7280),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 28, color: Color(0xFF4C6EF5)),
                        onPressed: _isLigado ? () {
                          setState(() {
                            if (_temperaturaAtual > 18) _temperaturaAtual -= 1;
                          });
                        } : null,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${_temperaturaAtual.toInt()}°C',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 28, color: Color(0xFF4C6EF5)),
                        onPressed: _isLigado ? () {
                          setState(() {
                            if (_temperaturaAtual < 28) _temperaturaAtual += 1;
                          });
                        } : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _temperaturaAtual,
                    min: 18,
                    max: 28,
                    divisions: 10,
                    activeColor: const Color(0xFF4C6EF5),
                    inactiveColor: const Color(0xFFE5E7EB),
                    onChanged: _isLigado ? (double value) {
                      setState(() {
                        _temperaturaAtual = value;
                      });
                    } : null,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('18°C', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                        Text('23°C', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                        Text('28°C', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4C6EF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text(
                  'LIGAR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                secondary: const Icon(Icons.power_settings_new, color: Colors.white),
                value: _isLigado,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF1E3A8A),
                onChanged: (bool value) {
                  setState(() {
                    _isLigado = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                // Card de Modo
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
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
                        const Text(
                          'MODO',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildModoOption('Resfriar', Icons.ac_unit),
                            _buildModoOption('Ventilar', Icons.air),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Card de Velocidade do Fan
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
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
                        const Text(
                          'VELOCIDADE FAN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFanOption('Baixa'),
                            _buildFanOption('Média'),
                            _buildFanOption('Alta'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget _buildModoOption(String titulo, IconData icone) {
    bool selecionado = _modoSelecionado == titulo;
    return GestureDetector(
      onTap: _isLigado ? () => setState(() => _modoSelecionado = titulo) : null,
      child: Column(
        children: [
          Icon(icone, color: selecionado ? const Color(0xFF4C6EF5) : Colors.grey),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
              color: selecionado ? const Color(0xFF4C6EF5) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFanOption(String nivel) {
    bool selecionado = _velocidadeFan == nivel;
    return GestureDetector(
      onTap: _isLigado ? () => setState(() => _velocidadeFan = nivel) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          nivel,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
            color: selecionado ? const Color(0xFF4C6EF5) : Colors.grey,
          ),
        ),
      ),
    );
  }
}