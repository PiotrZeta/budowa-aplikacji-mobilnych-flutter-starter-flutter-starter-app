import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../state/journal_store.dart';
import '../widgets/app_loader.dart';
import '../widgets/empty_state.dart';
import 'entry_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<JournalStore>();

    if (store.isBootstrapping) {
      return const AppLoader(label: 'Wczytywanie mapy...');
    }

    final located = store.entries.where((e) => e.hasLocation).toList();

    if (located.isEmpty) {
      return const EmptyState(
        title: 'Brak lokalizacji',
        subtitle: 'Dodaj wpis z GPS, aby zobaczyć go na mapie.',
        icon: Icons.place_outlined,
      );
    }

    final first = located.first;
    final initial = CameraPosition(
      target: LatLng(first.latitude!, first.longitude!),
      zoom: 12,
    );

    final markers = located
        .map(
          (e) => Marker(
            markerId: MarkerId(e.id),
            position: LatLng(e.latitude!, e.longitude!),
            infoWindow: InfoWindow(
              title: e.title,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EntryDetailScreen(entryId: e.id)),
              ),
            ),
          ),
        )
        .toSet();

    return GoogleMap(
      initialCameraPosition: initial,
      markers: markers,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (c) => setState(() => _controller = c),
    );
  }
}
