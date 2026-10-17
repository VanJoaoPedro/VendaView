import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/resumo_financeiro.dart';
import '../utils/formatadores.dart';

class GraficoFluxoCaixa extends StatelessWidget {
  final Map<DateTime, TotaisMes> porMes;

  const GraficoFluxoCaixa({super.key, required this.porMes});
  static const corReceita = Color(0xFF1B7F4B);

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;

    if (porMes.isEmpty) {
      return const Text('Ainda não há movimentações no período.');
    }

    final meses = porMes.keys.toList();
    final totais = porMes.values.toList();
    final maiorValor = totais.fold<double>(
      0,
      (maior, t) => max(maior, max(t.receitas, t.despesas)),
    );
    final estiloEixo = texto.labelSmall?.copyWith(
      color: cores.onSurfaceVariant,
    );
    const semTitulos = AxisTitles(sideTitles: SideTitles(showTitles: false));
    const pontaArrendodada = BorderRadius.vertical(top: Radius.circular(4));

    return Column(
      children: [
        Row(
          children: [
            const _ItemLegenda(cor: corReceita, texto: 'Receitas'),
            const SizedBox(width: 16),
            _ItemLegenda(cor: cores.error, texto: 'Despesas'),
          ],
        ),
        const SizedBox(height: 16),

        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              maxY: maiorValor * 1.15,
              alignment: BarChartAlignment.spaceAround,
              barGroups: [
                for (var i = 0; i < totais.length; i++)
                  BarChartGroupData(
                    x: i,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: totais[i].receitas,
                        color: corReceita,
                        width: 10,
                        borderRadius: pontaArrendodada,
                      ),
                      BarChartRodData(
                        toY: totais[i].despesas,
                        color: cores.error,
                        width: 10,
                        borderRadius: pontaArrendodada,
                      ),
                    ],
                  ),
              ],
              titlesData: FlTitlesData(
                topTitles: semTitulos,
                rightTitles: semTitulos,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: (valor, meta) {
                      if (valor == meta.max) return const SizedBox.shrink();
                      return Text(
                        Formatadores.compacto(valor),
                        style: estiloEixo,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (valor, meta) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        Formatadores.mes(meses[valor.toInt()]),
                        style: estiloEixo,
                      ),
                    ),
                  ),
                ),
              ),
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (valor) =>
                    FlLine(color: cores.outlineVariant, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (grupo) => cores.inverseSurface,
                  getTooltipItem: (grupo, indiceGrupo, barra, indiciBarra) {
                    final rotulo = indiciBarra == 0 ? 'Receitas' : 'Despesas';
                    return BarTooltipItem(
                      '$rotulo\n${Formatadores.moeda(barra.toY)}',
                      TextStyle(
                        color: cores.onInverseSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemLegenda extends StatelessWidget {
  final Color cor;
  final String texto;

  const _ItemLegenda({required this.cor, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(texto, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
