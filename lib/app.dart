import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/journal_store.dart';
import 'screens/home_screen.dart';

class GeoMemoirApp extends StatelessWidget {
  const GeoMemoirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JournalStore()..bootstrap()),
      ],
      child: Consumer<JournalStore>(
        builder: (context, store, _) {
          return MaterialApp(
            title: 'Geo Memoir',
            debugShowCheckedModeBanner: false,
            themeMode: store.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.teal,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.teal,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
