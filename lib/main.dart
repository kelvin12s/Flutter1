import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _click = -1; // Menyimpan indeks tombol yang sedang diklik

  final AudioPlayer _player = AudioPlayer();

  // Warna AppBar
  Color _topColor = Colors.red;

  // Daftar warna dasar
  final List<Color> _colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.yellow,
  ];

  // Link gambar
  final String _imageUrl = 'https://i.imgur.com/Yf4NKrK.png';

  // Fungsi saat salah satu tombol dari 28 tombol diklik
  void _playAudio(int index) async {
    await _player.stop();
    await _player.play(
      UrlSource('assets/assets/sounds/jokowi.mp3'),
    );

    setState(() {
      _click = index; // Menandai tombol yang sedang aktif diklik
      _topColor = (_colorList..shuffle()).first; // Mengubah warna AppBar
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _topColor,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Menghitung rasio lebar & tinggi otomatis agar 7 kolom x 4 baris pas 1 layar
              double itemWidth = (constraints.maxWidth - (6 * 8)) / 7;
              double itemHeight = (constraints.maxHeight - (3 * 8)) / 4;
              double aspectRatio = itemWidth / itemHeight;

              return GridView.count(
                physics: const NeverScrollableScrollPhysics(), // Mematikan scroll
                crossAxisCount: 7, // 7 kolom
                childAspectRatio: aspectRatio, // Rasio dinamis pas 1 layar
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: List.generate(
                  28,
                      (i) {
                    return GestureDetector(
                      onTap: () => _playAudio(i),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: RadialGradient(
                            colors: [
                              Colors.white,
                              (i == _click)
                                  ? Colors.black
                                  : ((i % 7 == 0)
                                  ? Colors.red
                                  : ((i % 7 == 1)
                                  ? Colors.orange
                                  : ((i % 7 == 2)
                                  ? Colors.yellow
                                  : Colors.blue))),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.network(
                              _imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}