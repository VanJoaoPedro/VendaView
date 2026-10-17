class AuthService {
  static const emailDemo = 'demo@vendaview.com';
  static const senhaDemo = 'loja123';

  static final Map<String, String> _usuarios = {emailDemo: senhaDemo};

  Future<bool> entrar(String email, String senha) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return _usuarios[email.toLowerCase()] == senha;
  }

  Future<bool> cadastrar({
    required String nome,
    required String loja,
    required String email,
    required String senha,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final chave = email.toLowerCase();
    if (_usuarios.containsKey(chave)) return false;
    _usuarios[chave] = senha;
    return true;
  }
}
