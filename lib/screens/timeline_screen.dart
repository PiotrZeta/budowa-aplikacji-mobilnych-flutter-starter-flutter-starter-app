import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/journal_store.dart';
import '../widgets/app_loader.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_banner.dart';
import 'entry_detail_screen.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<JournalStore>();

    if (store.isBootstrapping) {
      return const AppLoader(label: 'Wczytywanie danych...');
    }

    return Column(
      children: [
        if (store.error != null)
          ErrorBanner(
            message: store.error!,
            onRetry: store.isFetchingRemote ? null : () => store.refreshFromApi(),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => store.refreshFromApi(),
            child: store.entries.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      EmptyState(
                        title: 'Brak wpisów',
                        subtitle: 'Dodaj pierwszy wpis i pobierz lokalizację lub dodaj zdjęcie.',
                        icon: Icons.auto_stories_outlined,
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 96),
                    itemCount: store.entries.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final e = store.entries[index];
                      final date = DateFormat('dd.MM.yyyy HH:mm').format(e.createdAt);
                      final subtitle = e.hasLocation
                          ? '📍 ${e.latitude!.toStringAsFixed(4)}, ${e.longitude!.toStringAsFixed(4)}'
                          : '📌 bez lokalizacji';

                      return ListTile(
                        minVerticalPadding: 16,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('$date • $subtitle', maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Wrap(
                          spacing: 6,
                          children: [
                            if (e.imagePath != null)
                              const Icon(Icons.image_outlined, size: 18, semanticLabel: 'Ma zdjęcie'),
                            Icon(
                              e.isSynced ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
                              size: 18,
                              semanticLabel: e.isSynced ? 'Zsynchronizowano' : 'Nie zsynchronizowano',
                            ),
                          ],
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => EntryDetailScreen(entryId: e.id)),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
