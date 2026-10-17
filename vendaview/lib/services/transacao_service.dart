import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/transacao.dart';

class TransacaoService {
  static List<Transacao>? _cache;

  Future<List<Transacao>> carregar() async {
    if (_cache != null) return _cache!;

    final conteudo = await rootBundle.loadString('assets/transacoes.json');
    final lista = jsonDecode(conteudo) as List<dynamic>;

    _cache = lista
        .map((item) => Transacao.fromJson(item as Map<String, dynamic>))
        .toList();
    return _cache!;
  }
}
