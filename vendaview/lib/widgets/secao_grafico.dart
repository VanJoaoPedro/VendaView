import 'package:flutter/material.dart';

class SecaoGrafico extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final Widget child;

  const SecaoGrafico({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: cores.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: texto.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            subtitulo,
            style: texto.bodySmall?.copyWith(color: cores.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
