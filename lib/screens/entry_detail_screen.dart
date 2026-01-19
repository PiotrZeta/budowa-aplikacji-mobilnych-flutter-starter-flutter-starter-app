import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/journal_store.dart';
import '../widgets/empty_state.dart';
import 'entry_form_screen.dart';

class EntryDetailScreen extends StatelessWidget {
  final String entryId;
  const EntryDetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<JournalStore>();
    final entry = store.findById(entryId);

    if (entry == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Szczegóły')),
        body: const EmptyState(
          title: 'Nie znaleziono wpisu',
          subtitle: 'Ten wpis mógł zostać usunięty.',
          icon: Icons.search_off,
        ),
      );
    }

    final date = DateFormat('dd.MM.yyyy HH:mm').format(entry.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły wpisu'),
        actions: [
          IconButton(
            tooltip: 'Edytuj',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EntryFormScreen(editEntryId: entry.id)),
            ),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Usuń',
            onPressed: () async {
              final ok = await _confirmDelete(context);
              if (!ok) return;
              await store.deleteEntry(entry.id);
              if (context.mounted) Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(entry.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.schedule, size: 18),
              const SizedBox(width: 6),
              Text(date),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(entry.isSynced ? Icons.cloud_done_outlined : Icons.cloud_off_outlined, size: 18),
              const SizedBox(width: 6),
              Text(entry.isSynced ? 'Zsynchronizowano z API' : 'Nie zsynchronizowano (offline)'),
            ],
          ),
          const SizedBox(height: 16),
          Text(entry.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),

          if (entry.imagePath != null) ...[
            Text('Zdjęcie', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(entry.imagePath!),
            ),
            const SizedBox(height: 16),
          ],

          Text('Lokalizacja', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (!entry.hasLocation)
            const Text('Brak lokalizacji dla tego wpisu.')
          else ...[
            Text('Lat: ${entry.latitude!.toStringAsFixed(5)}  •  Lng: ${entry.longitude!.toStringAsFixed(5)}'),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(entry.latitude!, entry.longitude!),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(entry.id),
                      position: LatLng(entry.latitude!, entry.longitude!),
                      infoWindow: InfoWindow(title: entry.title),
                    )
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: entry.isSynced
                ? null
                : () async {
                    final ok = await store.syncEntry(entry.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ok
                              ? 'Wysłano do API (POST) ✅'
                              : 'Nie udało się wysłać do API (brak internetu?)'),
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.cloud_upload_outlined),
            label: const Text('Wyślij do API'),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (kIsWeb) {
      // Web builds often can’t access file paths the same way.
      return const SizedBox(
        height: 160,
        child: Center(child: Text('Podgląd zdjęcia działa najlepiej na Android/iOS.')),
      );
    }
    return Image.file(File(path), height: 220, fit: BoxFit.cover);
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usunąć wpis?'),
        content: const Text('Tej operacji nie można cofnąć.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Anuluj')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Usuń')),
        ],
      ),
    );
    return result ?? false;
  }
}
