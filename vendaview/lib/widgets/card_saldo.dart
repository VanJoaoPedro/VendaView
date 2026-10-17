import 'package:flutter/material.dart';

import '../utils/formatadores.dart';

class CardSaldo extends StatelessWidget {
  final double saldo;
  final double margem;
  final String periodo;

  const CardSaldo({
    super.key,
    required this.saldo,
    required this.margem,
    required this.periodo,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;
    final lucro = saldo >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cores.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo de $periodo',
            style: texto.bodyMedium?.copyWith(
              color: cores.onPrimary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              Formatadores.moeda(saldo),
              style: texto.headlineMedium?.copyWith(
                color: cores.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cores.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  lucro ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: cores.onPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  lucro
                      ? 'Margem de ${Formatadores.porcentagem(margem)}'
                      : 'Prejuízo no período',
                  style: texto.labelMedium?.copyWith(color: cores.onPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
