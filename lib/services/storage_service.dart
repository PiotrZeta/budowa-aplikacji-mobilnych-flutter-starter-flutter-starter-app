import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/journal_entry.dart';

class StorageService {
  static const _kEntriesKey = 'geo_memoir_entries_v1';
  static const _kThemeModeKey = 'geo_memoir_theme_mode_v1'; // system/light/dark

  Future<List<JournalEntry>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kEntriesKey);
    if (raw == null || raw.trim().isEmpty) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(JournalEntry.fromMap)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveEntries(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final list = entries.map((e) => e.toMap()).toList();
    await prefs.setString(_kEntriesKey, jsonEncode(list));
  }

  Future<String> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kThemeModeKey) ?? 'system';
  }

  Future<void> saveThemeMode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeModeKey, value);
  }
}
