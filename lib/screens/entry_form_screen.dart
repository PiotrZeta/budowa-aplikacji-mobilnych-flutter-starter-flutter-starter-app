import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/journal_entry.dart';
import '../services/location_helper.dart';
import '../state/journal_store.dart';

class EntryFormScreen extends StatefulWidget {
  final String? editEntryId;
  const EntryFormScreen({super.key, this.editEntryId});

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final _location = LocationHelper();
  final _picker = ImagePicker();

  double? _lat;
  double? _lng;
  String? _imagePath;

  bool _saving = false;
  bool _gettingLocation = false;
  bool _pickingImage = false;

  bool get _isEdit => widget.editEntryId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final store = context.read<JournalStore>();
      final existing = store.findById(widget.editEntryId!);
      if (existing != null) {
        _titleCtrl.text = existing.title;
        _descCtrl.text = existing.description;
        _lat = existing.latitude;
        _lng = existing.longitude;
        _imagePath = existing.imagePath;
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edytuj wpis' : 'Dodaj wpis'),
      ),
      body: AbsorbPointer(
        absorbing: _saving,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tytuł',
                      hintText: 'np. Spacer w parku',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Podaj tytuł.';
                      if (v.trim().length < 3) return 'Tytuł jest za krótki.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Opis',
                      hintText: 'Co się wydarzyło?',
                    ),
                    maxLines: 4,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Podaj opis.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildLocationCard(context),
                  const SizedBox(height: 12),

                  _buildPhotoCard(context),
                  const SizedBox(height: 24),

                  FilledButton.icon(
                    onPressed: _saving ? null : () => _onSave(context),
                    icon: const Icon(Icons.save_outlined),
                    label: Text(_saving ? 'Zapisywanie...' : 'Zapisz'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tip: Po zapisaniu możesz wejść w szczegóły i wysłać wpis do API (POST).',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    final has = _lat != null && _lng != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.place_outlined),
                const SizedBox(width: 8),
                Text('Lokalizacja (GPS)', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              has
                  ? 'Lat: ${_lat!.toStringAsFixed(5)}, Lng: ${_lng!.toStringAsFixed(5)}'
                  : 'Brak lokalizacji — pobierz ją przyciskiem poniżej.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _gettingLocation ? null : _getLocation,
                    icon: _gettingLocation
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                    label: Text(_gettingLocation ? 'Pobieranie...' : 'Pobierz lokalizację'),
                  ),
                ),
                if (has)
                  SizedBox(
                    height: 48,
                    child: TextButton.icon(
                      onPressed: () => setState(() {
                        _lat = null;
                        _lng = null;
                      }),
                      icon: const Icon(Icons.clear),
                      label: const Text('Usuń'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context) {
    final has = _imagePath != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.image_outlined),
                const SizedBox(width: 8),
                Text('Zdjęcie', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            if (has) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImagePreview(_imagePath!),
              ),
              const SizedBox(height: 12),
            ] else
              const Text('Brak zdjęcia — możesz zrobić nowe lub wybrać z galerii.'),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _pickingImage ? null : () => _pickImage(ImageSource.camera),
                    icon: _pickingImage
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.photo_camera_outlined),
                    label: const Text('Zrób zdjęcie'),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _pickingImage ? null : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Z galerii'),
                  ),
                ),
                if (has)
                  SizedBox(
                    height: 48,
                    child: TextButton.icon(
                      onPressed: () => setState(() => _imagePath = null),
                      icon: const Icon(Icons.clear),
                      label: const Text('Usuń'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(String path) {
    if (kIsWeb) {
      return const SizedBox(height: 160, child: Center(child: Text('Podgląd zdjęcia najlepiej działa na Android/iOS.')));
    }
    return Image.file(File(path), height: 180, fit: BoxFit.cover);
  }

  Future<void> _getLocation() async {
    setState(() => _gettingLocation = true);
    try {
      final pos = await _location.getCurrentPosition();
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _gettingLocation = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _pickingImage = true);
    try {
      final xfile = await _picker.pickImage(source: source, maxWidth: 1600);
      if (xfile != null) {
        setState(() => _imagePath = xfile.path);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nie udało się pobrać zdjęcia: $e')),
      );
    } finally {
      if (mounted) setState(() => _pickingImage = false);
    }
  }

  Future<void> _onSave(BuildContext context) async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() => _saving = true);

    final store = context.read<JournalStore>();
    final now = DateTime.now();

    final entry = JournalEntry(
      id: widget.editEntryId ?? 'local_${now.millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      createdAt: _isEdit ? (store.findById(widget.editEntryId!)?.createdAt ?? now) : now,
      latitude: _lat,
      longitude: _lng,
      imagePath: _imagePath,
      isSynced: _isEdit ? (store.findById(widget.editEntryId!)?.isSynced ?? false) : false,
    );

    try {
      if (_isEdit) {
        await store.updateEntry(entry);
      } else {
        await store.addEntry(entry);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zapisano wpis ✅')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
