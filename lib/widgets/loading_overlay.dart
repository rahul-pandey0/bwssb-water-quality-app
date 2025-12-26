import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool show;
  const LoadingOverlay({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();
    return Container(
      color: Colors.black26,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
