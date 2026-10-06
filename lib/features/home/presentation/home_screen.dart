import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "../../../core/config/supabase_config.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await SupabaseConfig.client.auth.signOut();
    } on AuthException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beranda"),
        actions: [
          IconButton(
            tooltip: "Keluar",
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Deadline Terdekat"),
              SizedBox(height: 8),
              Card(child: ListTile(title: Text("Tidak ada deadline dekat 🎉"))),
              SizedBox(height: 16),
              Text("Mata Kuliah Saya"),
              SizedBox(height: 12),
              Text("Lanjut Belajar"),
              SizedBox(height: 12),
              Text("Tugas Mendatang"),
            ],
          ),
        ),
      ),
    );
  }
}
