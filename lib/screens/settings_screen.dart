import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/journal_store.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<JournalStore>();

    return ListView(
      children: [
        const SizedBox(height: 8),
        _ThemeTile(
          value: store.themeMode,
          onChanged: (m) => store.setThemeMode(m),
        ),
        const Divider(height: 1),
        ListTile(
          title: const Text('Pobierz przykładowe wpisy (API GET)'),
          subtitle: const Text('Dodaje kilka wpisów z JSONPlaceholder'),
          leading: const Icon(Icons.cloud_download_outlined),
          onTap: store.isFetchingRemote
              ? null
              : () async {
                  await store.refreshFromApi();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(store.error == null
                            ? 'Pobrano wpisy z API ✅'
                            : 'Błąd pobierania z API'),
                      ),
                    );
                  }
                },
        ),
        const Divider(height: 1),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('O aplikacji'),
          subtitle: Text('Geo Memoir • v1.0.0'),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Aplikacja demonstracyjna do zajęć: GPS + zdjęcie + API + 3 widoki (oś czasu, mapa, ustawienia).\n\n'
            'Dostępność: przyciski mają min. ~48px wysokości, a ważne elementy mają etykiety semantyczne.',
          ),
        ),
      ],
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: const Text('Motyw'),
      subtitle: Text(_label(value)),
      trailing: DropdownButton<ThemeMode>(
        value: value,
        onChanged: (m) {
          if (m != null) onChanged(m);
        },
        items: const [
          DropdownMenuItem(value: ThemeMode.system, child: Text('Systemowy')),
          DropdownMenuItem(value: ThemeMode.light, child: Text('Jasny')),
          DropdownMenuItem(value: ThemeMode.dark, child: Text('Ciemny')),
        ],
      ),
    );
  }

  String _label(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'Jasny',
      ThemeMode.dark => 'Ciemny',
      _ => 'Systemowy',
    };
  }
}
