import 'package:intl/intl.dart';

class Formatadores {
  static final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  static const _meses = [
    'jan',
    'fev',
    'mar',
    'abr',
    'mai',
    'jun',
    'jul',
    'ago',
    'set',
    'out',
    'nov',
    'dez',
  ];

  static String moeda(double valor) => _moeda.format(valor);
  static final _compacto = NumberFormat.compact(locale: 'pt_BR');

  static String compacto(double valor) => _compacto.format(valor);

  static String porcentagem(double valor) =>
      '${valor.toStringAsFixed(1).replaceAll('.', ',')}%';

  static String mes(DateTime data) => _meses[data.month - 1];

  static String periodo(DateTime inicio, DateTime fim) {
    if (inicio.year == fim.year) {
      return '${mes(inicio)} as ${mes(fim)}  de ${fim.year}';
    }
    return '${mes(inicio)}/${inicio.year} a ${mes(fim)}/${fim.year}';
  }
}
