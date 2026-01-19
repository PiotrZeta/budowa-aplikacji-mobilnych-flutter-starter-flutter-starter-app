import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import '../services/api_client.dart';
import '../services/storage_service.dart';

class JournalStore extends ChangeNotifier {
  final _storage = StorageService();
  final _api = ApiClient();

  final List<JournalEntry> _entries = [];
  bool _isBootstrapping = true;
  bool _isFetchingRemote = false;
  String? _error;
  ThemeMode _themeMode = ThemeMode.system;

  List<JournalEntry> get entries => List.unmodifiable(_entries);
  bool get isBootstrapping => _isBootstrapping;
  bool get isFetchingRemote => _isFetchingRemote;
  String? get error => _error;
  ThemeMode get themeMode => _themeMode;

  Future<void> bootstrap() async {
    try {
      final theme = await _storage.loadThemeMode();
      _themeMode = _parseTheme(theme);
      final local = await _storage.loadEntries();
      _entries
        ..clear()
        ..addAll(local);
      _sort();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isBootstrapping = false;
      notifyListeners();
    }
  }

  Future<void> refreshFromApi() async {
    _error = null;
    _isFetchingRemote = true;
    notifyListeners();

    try {
      final seed = await _api.fetchSeedEntries();
      // Keep local entries; add remote if not present.
      for (final remote in seed) {
        if (_entries.any((e) => e.id == remote.id)) continue;
        _entries.add(remote);
      }
      _sort();
      await _storage.saveEntries(_entries);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isFetchingRemote = false;
      notifyListeners();
    }
  }

  JournalEntry? findById(String id) {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addEntry(JournalEntry entry) async {
    _entries.add(entry);
    _sort();
    await _storage.saveEntries(_entries);
    notifyListeners();
  }

  Future<void> updateEntry(JournalEntry entry) async {
    final idx = _entries.indexWhere((e) => e.id == entry.id);
    if (idx == -1) return;
    _entries[idx] = entry;
    _sort();
    await _storage.saveEntries(_entries);
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _storage.saveEntries(_entries);
    notifyListeners();
  }

  Future<bool> syncEntry(String id) async {
    final entry = findById(id);
    if (entry == null) return false;

    try {
      final ok = await _api.createRemoteEntry(entry);
      if (ok) {
        await updateEntry(entry.copyWith(isSynced: true));
      }
      return ok;
    } catch (_) {
      return false;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await _storage.saveThemeMode(value);
  }

  ThemeMode _parseTheme(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void _sort() {
    _entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
