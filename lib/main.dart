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
      title: 'Pemograman Lintas Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(
        title: 'Pemograman Lintas Platform',
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
  int _counter = 0; // Menghitung total klik
  int _click = -1;  // Menandai tombol aktif (-1 artinya belum ada yang diklik)

  final AudioPlayer _player = AudioPlayer();

  // Link gambar ikon di dalam tombol
  final String _imageUrl = 'https://i.imgur.com/Yf4NKrK.png';

  // Daftar nama file suara sesuai dengan yang ada di folder assets/sounds/ Anda
  final List<String> _soundFiles = [
    'Kick.wav',   // Tombol 0 (Merah)
    'Ride.wav',   // Tombol 1 (Biru)
    'Snare.wav',  // Tombol 2 (Hijau)
    'Tom.wav',    // Tombol 3 (Kuning)
  ];

  // Daftar warna untuk 4 tombol [Merah, Biru, Hijau, Kuning]
  final List<Color> _buttonColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.amber, // Kuning
  ];

  // Fungsi saat tombol diklik untuk memutar suara dan menambah hitungan
  void _playAudio(int index) async {
    await _player.stop();
    // Menggunakan AssetSource agar membaca file lokal dari folder assets/sounds/
    await _player.play(AssetSource('sounds/${_soundFiles[index]}'));

    setState(() {
      _counter++;
      _click = index; // Menandai tombol yang sedang diklik agar berubah jadi abu-abu
    });
  }

  // Fungsi untuk mereset counter & warna tombol
  void _resetCounter() {
    setState(() {
      _counter = 0;
      _click = -1;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // Widget bantuan untuk membuat tombol lingkaran
  Widget _buildCircularButton({
    required int index,
    required Color defaultColor,
  }) {
    bool isClicked = (index == _click);
    // Jika tombol diklik, warnanya jadi abu-abu. Jika tidak, pakai warna aslinya.
    Color currentColor = isClicked ? Colors.grey : defaultColor;

    return GestureDetector(
      onTap: () => _playAudio(index),
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: currentColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Image.network(
            _imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 40,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFFF7F5DC), // Warna latar belakang krem
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Baris 1: Tombol Merah & Biru
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircularButton(index: 0, defaultColor: _buttonColors[0]),
                const SizedBox(width: 20),
                _buildCircularButton(index: 1, defaultColor: _buttonColors[1]),
              ],
            ),
            const SizedBox(height: 20),

            // Baris 2: Tombol Hijau & Kuning
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircularButton(index: 2, defaultColor: _buttonColors[2]),
                const SizedBox(width: 20),
                _buildCircularButton(index: 3, defaultColor: _buttonColors[3]),
              ],
            ),
            const SizedBox(height: 40),

            // Teks Jumlah Klik
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_counter',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // Tombol Reset di Kanan Bawah
      floatingActionButton: FloatingActionButton(
        onPressed: _resetCounter,
        backgroundColor: Colors.redAccent,
        tooltip: 'Reset',
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}