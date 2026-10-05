import "package:flutter/material.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Beranda", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
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

