import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

void main() {
  runApp(const MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AlLuhaydanPlayer()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3D4A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                'assets/images/luhaydan.jpg',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 100, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "القارئ محمد اللحيدان",
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.cyanAccent),
          ],
        ),
      ),
    );
  }
}

class AlLuhaydanPlayer extends StatefulWidget {
  const AlLuhaydanPlayer({super.key});

  @override
  State<AlLuhaydanPlayer> createState() => _AlLuhaydanPlayerState();
}

class _AlLuhaydanPlayerState extends State<AlLuhaydanPlayer> {
  late AudioPlayer _audioPlayer;
  int? _currentIndex;
  String _currentTitle = "اختر سورة للاستماع";

  // هنا يا مستر نوش بسطنا الأسماء عشان التطبيق ما يهنق
  final List<Map<String, String>> playlist = [
    {"title": "سورة الحجر", "file": "hjr.mp3"},
    {"title": "سورة الكهف", "file": "khf.mp3"},
    {"title": "سورة المؤمنون", "file": "mnm.mp3"},
    {"title": "سورة المدثر", "file": "mdt.mp3"},
    {"title": "سورة لقمان", "file": "lqm.mp3"},
    {"title": "سورة يوسف", "file": "ysf.mp3"},
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSurah(int index) async {
    try {
      await _audioPlayer.setAsset('assets/audio/${playlist[index]['file']}');
      _audioPlayer.play();
      setState(() {
        _currentIndex = index;
        _currentTitle = playlist[index]['title']!;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ في تشغيل الملف: ${playlist[index]['file']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3D4A),
      appBar: AppBar(
        title: const Text("المصحف المرتل", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 65,
            backgroundImage: AssetImage('assets/images/luhaydan.jpg'),
          ),
          const SizedBox(height: 15),
          Text(_currentTitle, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const Text("محمد اللحيدان", style: TextStyle(color: Colors.cyanAccent)),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2C5364),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(15),
                itemCount: playlist.length,
                separatorBuilder: (context, index) => const Divider(color: Colors.white10),
                itemBuilder: (context, index) {
                  bool isPlaying = _currentIndex == index;
                  return ListTile(
                    leading: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.cyanAccent),
                    title: Text(playlist[index]['title']!, style: const TextStyle(color: Colors.white)),
                    onTap: () => _playSurah(index),
                  );
                },
              ),
            ),
          ),
          // التحكم في الصوت
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF162E38),
            child: StreamBuilder<Duration?>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final total = _audioPlayer.duration ?? Duration.zero;
                return ProgressBar(
                  progress: position,
                  total: total,
                  progressBarColor: Colors.cyanAccent,
                  baseBarColor: Colors.white24,
                  onSeek: (duration) => _audioPlayer.seek(duration),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
