
import 'package:flutter/material.dart';
import '../controller/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const corPrincipal = Color(0xFF167D83);
  static const corLigado = Color(0xFFB9C7FF);
  static const corDesligado = Color(0xFFD6D6D6);

  final HomeController controller = HomeController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _confirmarLogout() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sair da conta'),
          content: const Text(
            'Tem certeza de que deseja sair?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: corPrincipal,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (confirmou == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nomeUsuario =
        ModalRoute.of(context)?.settings.arguments as String? ??
            'Usuário teste';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FA),
      appBar: AppBar(
        title: const Text('Smart Home'),
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Sobre',
            onPressed: () {
              Navigator.pushNamed(context, 'sobre');
            },
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            tooltip: 'Sair da conta',
            onPressed: _confirmarLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: corPrincipal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.home,
                    size: 45,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Smart Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Início'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.meeting_room_outlined),
              title: const Text('Cômodos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'comodos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('Famílias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  'familias',
                  arguments: nomeUsuario,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'perfil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'sobre');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Sair da conta',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmarLogout();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Bom dia,',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              nomeUsuario,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Acesso Rápido',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _atalho(
                  context,
                  'Perfil',
                  Icons.person_outline,
                  () => Navigator.pushNamed(
                    context,
                    'perfil',
                  ),
                ),
                _atalho(
                  context,
                  'Cômodos',
                  Icons.meeting_room_outlined,
                  () => Navigator.pushNamed(
                    context,
                    'comodos',
                  ),
                ),
                const SizedBox(width: 10),
                _atalho(
                  context,
                  'Famílias',
                  Icons.groups_outlined,
                  () => Navigator.pushNamed(
                    context,
                    'familias',
                    arguments: nomeUsuario,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'DISPOSITIVOS FREQUENTES',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.dispositivos.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 145,
                  ),
                  itemBuilder: (context, index) {
                    final dispositivo =
                        controller.dispositivos[index];

                    final bool ligado = dispositivo['ligado'];

                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ligado
                            ? corLigado
                            : corDesligado,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ligado
                              ? const Color(0xFFA6B7FF)
                              : Colors.grey.shade400,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  dispositivo['icone'] as IconData,
                                  color: ligado
                                      ? corPrincipal
                                      : Colors.grey.shade600,
                                  size: 21,
                                ),
                              ),
                              const Spacer(),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: ligado,
                                  activeThumbColor: Colors.white,
                                  activeTrackColor: corPrincipal,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor:
                                      Colors.grey.shade600,
                                  onChanged: (valor) {
                                    controller.alterarEstado(
                                      index,
                                      valor,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            dispositivo['nome'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dispositivo['tipo'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            dispositivo['comodo'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black.withValues(
                                alpha: 0.65,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _atalho(
    BuildContext context,
    String titulo,
    IconData icone,
    VoidCallback aoTocar,
  ) {
    return Expanded(
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE1E6E6),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icone,
                color: corPrincipal,
                size: 27,
              ),
              const SizedBox(height: 8),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
