import 'package:flutter/material.dart';

import '../utils/validadores.dart';
import 'cadastro_screen.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();
  bool _senhaVisivel = false;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Digite o e-mail da sua loja';
    }
    final formatoEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!formatoEmail.hasMatch(value.trim())) {
      return 'Digite um e-mail válido, como nome@loja.com';
    }
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite a senha da sua loja';
    }
    return null;
  }

  void _limparErro(String _) {
    if (_erro != null) setState(() => _erro = null);
  }

  Future<void> _entrar() async {
    if (_carregando) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    bool sucesso;
    String? mensagemErro;
    try {
      sucesso = await _authService.entrar(
        _emailController.text.trim(),
        _senhaController.text,
      );
      if (!sucesso) mensagemErro = 'E-mail ou senha inválidos.';
    } catch (_) {
      sucesso = false;
      mensagemErro = 'Não foi possível conectar. Tente novamente.';
    }

    if (!mounted) return;

    if (sucesso) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      setState(() {
        _carregando = false;
        _erro = mensagemErro;
      });
    }
  }

  void _preencherDemonstracao() {
    _emailController.text = AuthService.emailDemo;
    _senhaController.text = AuthService.senhaDemo;
    setState(() => _erro = null);
  }

  Future<void> _abrirCadastro() async {
    final emailCadastrado = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const CadastroScreen()));
    if (emailCadastrado == null || !mounted) return;
    _emailController.text = emailCadastrado;
    _senhaController.clear();
    setState(() => _erro = null);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Conta criada. Digite sua senha para entrar."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Logo(),
                      const SizedBox(height: 20),
                      Text(
                        'VendaView',
                        style: texto.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cores.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Entre para ver as vendas e o caixa da sua loja.',
                        style: texto.bodyLarge?.copyWith(
                          color: cores.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 36),
                      TextFormField(
                        controller: _emailController,
                        enabled: !_carregando,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        onChanged: _limparErro,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: _validarEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _senhaController,
                        enabled: !_carregando,
                        obscureText: !_senhaVisivel,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        onChanged: _limparErro,
                        onFieldSubmitted: (_) => _entrar(),
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: _senhaVisivel
                                ? 'Ocultar senha'
                                : 'Mostrar senha',
                            icon: Icon(
                              _senhaVisivel
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () =>
                                setState(() => _senhaVisivel = !_senhaVisivel),
                          ),
                        ),
                        validator: _validarSenha,
                      ),
                      if (_erro != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cores.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: cores.onErrorContainer,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _erro!,
                                  style: TextStyle(
                                    color: cores.onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: _carregando ? null : _entrar,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          textStyle: texto.titleMedium,
                        ),
                        child: _carregando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text('Entrar'),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _carregando ? null : _preencherDemonstracao,
                        child: const Text('Usar acesso de demonstração'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ainda não tem conta?',
                            style: TextStyle(color: cores.onSurfaceVariant),
                          ),
                          TextButton(
                            onPressed: _carregando ? null : _abrirCadastro,
                            child: const Text('Criar conta'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cores.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final altura in [14.0, 24.0, 36.0])
              Container(
                width: 8,
                height: altura,
                decoration: BoxDecoration(
                  color: cores.onPrimary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
