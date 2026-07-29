import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/supabase_config.dart';
import '../../theme/portfolio_theme.dart';
import 'admin_projects_screen.dart';

class AdminGate extends StatefulWidget {
  const AdminGate({super.key});

  @override
  State<AdminGate> createState() => _AdminGateState();
}

class _AdminGateState extends State<AdminGate> {
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    if (SupabaseConfig.isConfigured) {
      _authSubscription = SupabaseConfig.client.auth.onAuthStateChange.listen((
        _,
      ) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!SupabaseConfig.isConfigured) {
      return const _MissingConfiguration();
    }

    if (SupabaseConfig.client.auth.currentSession == null) {
      return const _AdminLogin();
    }

    return const AdminProjectsScreen();
  }
}

class _MissingConfiguration extends StatelessWidget {
  const _MissingConfiguration();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 620),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: PortfolioColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white12),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.settings_suggest_outlined,
                color: PortfolioColors.primary,
                size: 54,
              ),
              SizedBox(height: 18),
              Text(
                'Supabase setup required',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Run the app with SUPABASE_URL and '
                'SUPABASE_PUBLISHABLE_KEY. The public portfolio continues to '
                'work with demo content until they are configured.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminLogin extends StatefulWidget {
  const _AdminLogin();

  @override
  State<_AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<_AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await SupabaseConfig.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on AuthException catch (error) {
      setState(() => _error = error.message);
    } catch (_) {
      setState(() => _error = 'Unable to sign in. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF08101D), Color(0xFF152640)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              padding: const EdgeInsets.all(34),
              decoration: BoxDecoration(
                color: const Color(0xF211182D),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 40,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.admin_panel_settings_outlined,
                      color: PortfolioColors.primary,
                      size: 52,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Portfolio Studio',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Private content management',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.alternate_email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || !value.contains('@')
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _signIn(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter your password'
                          : null,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ],
                    const SizedBox(height: 22),
                    FilledButton(
                      onPressed: _loading ? null : _signIn,
                      style: FilledButton.styleFrom(
                        backgroundColor: PortfolioColors.primary,
                        foregroundColor: PortfolioColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Sign in',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/'),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to portfolio'),
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
