class Validadores {
  static String? email(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o seu e-mail';
    }
    final formatoEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!formatoEmail.hasMatch(valor.trim())) {
      return 'Informe um e-mail válido, como exemplo@dominio.com';
    }
    return null;
  }

  static String? senha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe a sua senha';
    }
    if (valor.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  static String? Function(String?) obrigatorio(String mensagem) {
    return (valor) => (valor == null || valor.trim().isEmpty) ? mensagem : null;
  }
}
