import 'package:flutter/foundation.dart';

enum TipoTransacao { receita, despesa }

enum StatusTransacao { concluida, cancelada, pendente }

class Transacao {
  final String id;
  final TipoTransacao tipo;
  final double valor;
  final DateTime data;
  final String categoria;
  final String formaPagamento;
  final StatusTransacao status;
  final String? descricao;

  const Transacao({
    required this.id,
    required this.tipo,
    required this.valor,
    required this.data,
    required this.categoria,
    required this.formaPagamento,
    required this.status,
    this.descricao,
  });

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      id: json['id'] as String,
      tipo: TipoTransacao.values.byName(json['tipo'] as String),
      valor: (json['valor'] as num).toDouble(),
      data: DateTime.parse(json['data'] as String),
      categoria: json['categoria'] as String,
      formaPagamento: json['formaPagamento'] as String,
      status: StatusTransacao.values.byName(json['status'] as String),
      descricao: json['descricao'] as String?,
    );
  }
  bool get isReceita => tipo == TipoTransacao.receita;
  bool get isConcluida => status == StatusTransacao.concluida;
}
