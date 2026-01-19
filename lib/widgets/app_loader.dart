import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final String label;
  const AppLoader({super.key, this.label = 'Ładowanie...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
