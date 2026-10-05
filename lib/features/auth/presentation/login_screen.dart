import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text("GAKUSEI", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Selamat Datang Kembali 👋"),
              const Text("Masuk dan lanjutkan aktivitas perkuliahanmu."),
              const SizedBox(height: 24),
              const TextField(decoration: InputDecoration(labelText: "Email", hintText: "nama@email.com")),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(labelText: "Kata Sandi", suffixIcon: Icon(Icons.visibility_off))),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () {}, child: const Text("Lupa kata sandi?")),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go("/home"),
                  child: const Text("Masuk"),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: Text("atau")),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(onPressed: () {}, child: const Text("Lanjutkan dengan Google")),
              ),
              const Spacer(),
              Center(
                child: TextButton(onPressed: () {}, child: const Text("Belum punya akun? Daftar Sekarang")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

