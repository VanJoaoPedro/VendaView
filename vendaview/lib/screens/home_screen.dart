import 'package:flutter/material.dart';

import '../models/resumo_financeiro.dart';
import '../models/transacao.dart';
import '../services/transacao_service.dart';
import '../utils/formatadores.dart';
import '../widgets/card_indicador.dart';
import '../widgets/card_saldo.dart';
import 'login_screen.dart';
import '../widgets/graficos_despesas.dart';
import '../widgets/grafico_fluxo_caixa.dart';
import '../widgets/lista_formas_pagamento.dart';
import '../widgets/secao_grafico.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<Transacao>> _futuroTransacoes;

  @override
  void initState() {
    super.initState();
    _futuroTransacoes = TransacaoService().carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VendaView'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (rota) => false,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Transacao>>(
        future: _futuroTransacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Não foi possível carregar o relatório. '
                  'Feche e abra o app de novo.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return _Dashboard(resumo: ResumoFinanceiro(snapshot.data!));
        },
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  final ResumoFinanceiro resumo;
  const _Dashboard({required this.resumo});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final meses = resumo.porMes.keys;
    final periodo = meses.isEmpty
        ? 'o período'
        : Formatadores.periodo(meses.first, meses.last);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        CardSaldo(saldo: resumo.saldo, margem: resumo.margem, periodo: periodo),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CardIndicador(
                icone: Icons.arrow_upward,
                titulo: 'Despesas',
                valor: Formatadores.moeda(resumo.totalDespesas),
                detalhe: 'Fixas e variáveis',
                cor: cores.error,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            Expanded(
              child: CardIndicador(
                icone: Icons.remove_shopping_cart,
                titulo: 'Vendas Perdidas',
                valor: Formatadores.moeda(resumo.vendasEmAndamento),
                detalhe: 'Ainda não concluidads',
                cor: const Color(0xFF3B5BA9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SecaoGrafico(
          titulo: 'Fluxo de caixa',
          subtitulo: 'Receitas e despesas concluídas, mês a mês. Toque numa barra para ver o valor.',
          child: GraficoFluxoCaixa(porMes: resumo.porMes),
        ),
        const SizedBox(height: 16),
        SecaoGrafico(
          titulo: 'Para onde vai o dinheiro',
          subtitulo: 'Despesas por categoria. Toque numa fatia ou na legenda.',
          child: GraficoDespesas(porCategoria: resumo.despesasPorCategoria),
        ),
        const SizedBox(height: 16),
        SecaoGrafico(
          titulo: 'Como os clientes pagam',
          subtitulo: 'Receitas concluídas por forma de pagamento.',
          child: ListaFormasPagamento(
            porForma: resumo.receitasPorFormaPagamento,
          ),
        ),
      ],
    );
  }
}
