import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.note_alt_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64),
            const SizedBox(height: 12),
            Text(title, style: text.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: text.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
