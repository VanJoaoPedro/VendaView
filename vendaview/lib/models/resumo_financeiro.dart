import 'dart:collection';

import 'transacao.dart';

class TotaisMes {
  double receitas = 0;
  double despesas = 0;

  double get saldo => receitas - despesas;
}

class ResumoFinanceiro {
  final List<Transacao> transacoes;
  ResumoFinanceiro(this.transacoes);

  Iterable<Transacao> get _concluidas => transacoes.where((t) => t.isConcluida);
  double get totalReceitas => _somar(_concluidas.where((t) => t.isReceita));
  double get totalDespesas => _somar(_concluidas.where((t) => !t.isReceita));
  double get saldo => totalReceitas - totalDespesas;
  double get margem => totalReceitas == 0 ? 0 : saldo / totalReceitas * 100;
  double get vendasPerdidas => _somar(
    transacoes.where(
      (t) => t.isReceita && t.status == StatusTransacao.cancelada,
    ),
  );
  double get vendasEmAndamento => _somar(
    transacoes.where(
      (t) => t.isReceita && t.status == StatusTransacao.pendente,
    ),
  );
  double get taxaCancelamento {
    final totalVendido = totalReceitas + vendasPerdidas + vendasEmAndamento;
    return totalVendido == 0 ? 0 : vendasPerdidas / totalVendido * 100;
  }

  Map<DateTime, TotaisMes> get porMes {
    final mapa = SplayTreeMap<DateTime, TotaisMes>();
    for (final t in _concluidas) {
      final mes = DateTime(t.data.year, t.data.month);
      final totais = mapa.putIfAbsent(mes, () => TotaisMes());
      if (t.isReceita) {
        totais.receitas += t.valor;
      } else {
        totais.despesas += t.valor;
      }
    }
    return mapa;
  }

  Map<String, double> get despesasPorCategoria =>
      _agrupar(_concluidas.where((t) => !t.isReceita), (t) => t.categoria);

  Map<String, double> get receitasPorFormaPagamento =>
      _agrupar(_concluidas.where((t) => t.isReceita), (t) => t.formaPagamento);

  static double _somar(Iterable<Transacao> lista) =>
      lista.fold(0.0, (soma, t) => soma + t.valor);

  static Map<String, double> _agrupar(
    Iterable<Transacao> lista,
    String Function(Transacao) chave,
  ) {
    final mapa = <String, double>{};
    for (final t in lista) {
      mapa.update(
        chave(t),
        (atual) => atual + t.valor,
        ifAbsent: () => t.valor,
      );
    }
    final ordenado = mapa.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(ordenado);
  }
}
