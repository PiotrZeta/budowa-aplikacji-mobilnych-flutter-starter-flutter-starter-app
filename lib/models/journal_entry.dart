import 'dart:convert';

class JournalEntry {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;
  final String? imagePath;
  final bool isSynced; // whether we successfully sent it to the API

  const JournalEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.imagePath,
    this.isSynced = false,
  });

  bool get hasLocation => latitude != null && longitude != null;

  JournalEntry copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    String? imagePath,
    bool? isSynced,
    bool clearLocation = false,
    bool clearImage = false,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      latitude: clearLocation ? null : (latitude ?? this.latitude),
      longitude: clearLocation ? null : (longitude ?? this.longitude),
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'imagePath': imagePath,
      'isSynced': isSynced,
    };
  }

  static JournalEntry fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      createdAt: DateTime.tryParse((map['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      latitude: (map['latitude'] is num) ? (map['latitude'] as num).toDouble() : null,
      longitude:
          (map['longitude'] is num) ? (map['longitude'] as num).toDouble() : null,
      imagePath: map['imagePath']?.toString(),
      isSynced: map['isSynced'] == true,
    );
  }

  String toJson() => jsonEncode(toMap());

  static JournalEntry fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return fromMap(map);
  }
}
