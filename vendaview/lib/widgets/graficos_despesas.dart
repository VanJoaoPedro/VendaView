import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utils/formatadores.dart';

class GraficoDespesas extends StatefulWidget {
  final Map<String, double> porCategoria;

  const GraficoDespesas({super.key, required this.porCategoria});

  @override
  State<GraficoDespesas> createState() => _GraficoDespesasState();
}

class _GraficoDespesasState extends State<GraficoDespesas> {
  int _selecionada = -1;

  static const _paleta = [
    Color(0xFF0F5E59),
    Color(0xFF4FA89A),
    Color(0xFFE0A33A),
    Color(0xFFB45F06),
    Color(0xFF3B5BA9),
    Color(0xFF8E6BBF),
    Color(0xFF7A8B8A),
  ];
  Color _corData(int indice) => _paleta[indice % _paleta.length];

  void _selecionar(int indice) {
    setState(() => _selecionada = _selecionada == indice ? -1 : indice);
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;
    final itens = widget.porCategoria.entries.toList();
    if (itens.isEmpty) {
      return const Text('Nenhuma despesa no período.');
    }

    final total = itens.fold<double>(0, (soma, item) => soma + item.value);
    final destaque = _selecionada >= 0 ? itens[_selecionada] : null;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 62,
                  sections: [
                    for (var i = 0; i < itens.length; i++)
                      PieChartSectionData(
                        value: itens[i].value,
                        color: _corData(i),
                        radius: i == _selecionada ? 32 : 24,
                        showTitle: false,
                      ),
                  ],
                  pieTouchData: PieTouchData(
                    touchCallback: (evento, resposta) {
                      if (evento is! FlTapUpEvent) return;
                      final indice =
                          resposta?.touchedSection?.touchedSectionIndex ?? -1;
                      if (indice >= 0) {
                        _selecionar(indice);
                      } else {
                        setState(() => _selecionada = -1);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 110,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      destaque?.key ?? 'Total',
                      style: texto.labelMedium?.copyWith(
                        color: cores.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Formatadores.moeda(destaque?.value ?? total),
                        style: texto.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        for (var i = 0; i < itens.length; i++)
          InkWell(
            onTap: () => _selecionar(i),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: i == _selecionada
                    ? _corData(i).withValues(alpha: 0.10)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _corData(i),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(itens[i].key)),
                  Text(
                    Formatadores.porcentagem(itens[i].value / total * 100),
                    style: texto.bodySmall?.copyWith(
                      color: cores.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    Formatadores.moeda(itens[i].value),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
