import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/validadores.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _lojaController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();
  final _authService = AuthService();

  bool _senhaVisivel = false;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _nomeController.dispose();
    _lojaController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  String? _validarConfirmacao(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Repita a senha';
    }
    if (valor != _senhaController.text) {
      return 'As senhas não são iguais';
    }
  }

  Future<void> _cadastrar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    final email = _emailController.text.trim();
    final sucesso = await _authService.cadastrar(
      nome: _nomeController.text.trim(),
      loja: _lojaController.text.trim(),
      email: email,
      senha: _senhaController.text,
    );
    if (!mounted) return;
    if (sucesso) {
      Navigator.of(context).pop(email);
    } else {
      setState(() {
        _carregando = false;
        _erro = 'Este e-mail já tem vadastro. Volte e entre com ele, ou use outro e-mail.';
      });
    }
  }

  Widget _botaoVerSenha() {
    return IconButton(
      tooltip: _senhaVisivel ? 'Ocultar senha' : 'Mostrar senha',
      icon: Icon(
        _senhaVisivel
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
      ),
      onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Cadastre sua Loja',
                      style: texto.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cores.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Com a conta criada, você acomapnha as vendas, despesas e o lucro do mês.',
                      style: texto.bodyLarge?.copyWith(
                        color: cores.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 29),

                    TextFormField(
                      controller: _nomeController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      decoration: const InputDecoration(
                        labelText: 'Seu nome',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: Validadores.obrigatorio('Informe seu nome'),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _lojaController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nome da loja',
                        prefixIcon: Icon(Icons.storefront_outlined),
                      ),
                      validator: Validadores.obrigatorio(
                        'Informe o nome da loja',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                      validator: Validadores.email,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _senhaController,
                      obscureText: !_senhaVisivel,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        helperText: 'Use pelo menos 6 caracteres',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: _botaoVerSenha(),
                      ),
                      validator: Validadores.senha,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _confirmarController,
                      obscureText: !_senhaVisivel,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _cadastrar(),
                      decoration: InputDecoration(
                        labelText: 'Confirme a senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: _botaoVerSenha(),
                      ),
                      validator: _validarConfirmacao,
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
                                style: TextStyle(color: cores.onErrorContainer),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),

                    FilledButton(
                      onPressed: _carregando ? null : _cadastrar,
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
                          : const Text('Criar conta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
