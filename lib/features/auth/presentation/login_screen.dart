import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "../../../core/config/supabase_config.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final auth = SupabaseConfig.client.auth;
      if (_isSignUp) {
        final email = _emailController.text.trim();
        final response = await auth.signUp(
          email: email,
          password: _passwordController.text,
          data: {"full_name": _nameController.text.trim()},
        );
        if (response.session == null && mounted) {
          setState(() => _isSignUp = false);
          _showMessage("Periksa email untuk konfirmasi akun sebelum masuk.");
        }
      } else {
        await auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on AuthException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendConfirmation() async {
    final email = _emailController.text.trim();
    if (_isLoading) return;
    if (email.isEmpty || !email.contains("@")) {
      _showMessage("Masukkan email yang valid terlebih dahulu.", isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await SupabaseConfig.client.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      if (mounted) _showMessage("Email konfirmasi dikirim ulang ke $email.");
    } on AuthException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "GAKUSEI",
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSignUp
                          ? "Buat akun Gakusei"
                          : "Selamat Datang Kembali",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSignUp
                          ? "Daftar untuk mulai mengatur materi kuliahmu."
                          : "Masuk dan lanjutkan aktivitas perkuliahanmu.",
                    ),
                    const SizedBox(height: 24),
                    if (_isSignUp) ...[
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(labelText: "Nama"),
                        validator: (value) {
                          if (_isSignUp &&
                              (value == null || value.trim().isEmpty)) {
                            return "Nama wajib diisi";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "nama@email.com",
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? "";
                        if (email.isEmpty || !email.contains("@")) {
                          return "Masukkan alamat email yang valid";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      autofillHints: [
                        _isSignUp
                            ? AutofillHints.newPassword
                            : AutofillHints.password,
                      ],
                      decoration: const InputDecoration(
                        labelText: "Kata Sandi",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Kata sandi wajib diisi";
                        }
                        if (_isSignUp && value.length < 6) {
                          return "Kata sandi minimal 6 karakter";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_isSignUp ? "Daftar" : "Masuk"),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => setState(() => _isSignUp = !_isSignUp),
                      child: Text(
                        _isSignUp
                            ? "Sudah punya akun? Masuk"
                            : "Belum punya akun? Daftar",
                      ),
                    ),
                    if (!_isSignUp)
                      TextButton(
                        onPressed: _isLoading ? null : _resendConfirmation,
                        child: const Text("Kirim ulang email konfirmasi"),
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
