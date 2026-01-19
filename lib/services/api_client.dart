import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/journal_entry.dart';

class ApiClient {
  static const _base = 'https://jsonplaceholder.typicode.com';

  /// GET: loads a few example "remote" entries.
  /// We convert JSONPlaceholder posts to journal entries.
  Future<List<JournalEntry>> fetchSeedEntries() async {
    final uri = Uri.parse('$_base/posts?_limit=7');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('API GET nie powiódł się (HTTP ${res.statusCode}).');
    }
    final list = (jsonDecode(res.body) as List<dynamic>);
    final now = DateTime.now();
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      final id = 'remote_${map['id']}';
      return JournalEntry(
        id: id,
        title: (map['title'] ?? 'Untitled').toString(),
        description: (map['body'] ?? '').toString(),
        createdAt: now,
        latitude: null,
        longitude: null,
        imagePath: null,
        isSynced: true,
      );
    }).toList();
  }

  /// POST: tries to sync a local entry to the API.
  Future<bool> createRemoteEntry(JournalEntry entry) async {
    final uri = Uri.parse('$_base/posts');
    final body = {
      'title': entry.title,
      'body': entry.description,
      'userId': 1,
    };
    final res = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    return res.statusCode == 201;
  }
}
