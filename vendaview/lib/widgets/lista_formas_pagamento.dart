import 'package:flutter/material.dart';

import '../utils/formatadores.dart';

class ListaFormasPagamento extends StatelessWidget {
  final Map<String, double> porForma;

  const ListaFormasPagamento({super.key, required this.porForma});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;

    if (porForma.isEmpty) {
      return const Text('Nenhuma venda concluída no período.');
    }

    final total = porForma.values.fold<double>(0, (soma, v) => soma + v);
    final maior = porForma.values.first;

    return Column(
      children: [
        for (final forma in porForma.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(forma.key)),
                    Text(
                      Formatadores.moeda(forma.value),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: forma.value / maior,
                    minHeight: 8,
                    color: cores.primary,
                    backgroundColor: cores.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${Formatadores.porcentagem(forma.value / total * 100)} das receitas',
                  style: texto.bodySmall?.copyWith(
                    color: cores.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
