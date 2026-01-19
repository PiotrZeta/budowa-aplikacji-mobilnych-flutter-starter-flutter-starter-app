import 'package:flutter/material.dart';

import 'timeline_screen.dart';
import 'map_screen.dart';
import 'settings_screen.dart';
import 'entry_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final screens = const [
      TimelineScreen(),
      MapScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Memoir'),
      ),
      body: IndexedStack(index: _tab, children: screens),
      floatingActionButton: Semantics(
        button: true,
        label: 'Dodaj nowy wpis',
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EntryFormScreen()),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Dodaj'),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Oś czasu',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: 'Mapa',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Ustawienia',
          ),
        ],
      ),
    );
  }
}
