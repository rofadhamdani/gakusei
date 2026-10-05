import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: const [
                    _OnboardPage(
                      title: "Semua Materi, Satu Tempat",
                      desc:
                          "Simpan PPT, PDF, foto papan tulis, tautan, dan catatan kuliah tanpa takut tercecer lagi.",
                    ),
                    _OnboardPage(
                      title: "Belajar Lebih Mudah",
                      desc:
                          "Gakusei membantu menjelaskan materi kuliah per topik dan per pertemuan menggunakan AI.",
                    ),
                    _OnboardPage(
                      title: "Lebih Siap Saat Ujian",
                      desc:
                          "Gabungkan materi beberapa minggu menjadi rangkuman belajar UTS atau UAS.",
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  TextButton(onPressed: () => context.go("/login"), child: const Text("Lewati")),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_index == 2) {
                        context.go("/login");
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Text(_index == 2 ? "Mulai Menggunakan Gakusei" : "Lanjut"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({required this.title, required this.desc});

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Text(desc, textAlign: TextAlign.center),
      ],
    );
  }
}

