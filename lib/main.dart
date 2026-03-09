import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

void main() {
  runApp(const MaterialApp(
    home: SplashScreen(), // البداية من شاشة الترحيب
    debugShowCheckedModeBanner: false,
  ));
}

// --- 1. كود شاشة البداية (Splash Screen) ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // بينتظر 3 ثواني وبعدها يحولك للمشغل
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
      backgroundColor: const Color(0xFF1E3D4A), // نفس لون خلفية تطبيقك
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // صورة الشيخ اللي ظبطنا مقاسها
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                'assets/images/luhaydan.jpg',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "القارئ محمد اللحيدان",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.cyanAccent,
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. كود المشغل الأساسي (Player) ---
class AlLuhaydanPlayer extends StatefulWidget {
  const AlLuhaydanPlayer({super.key});

  @override
  State<AlLuhaydanPlayer> createState() => _AlLuhaydanPlayerState();
}

class _AlLuhaydanPlayerState extends State<AlLuhaydanPlayer> {
  late AudioPlayer _audioPlayer;
  int? _currentIndex;
  String _currentTitle = "اختر سورة للاستماع";

  final List<Map<String, String>> playlist = [
    {
      "title": "سورة الحجر", 
      "file": "سورة الحجر كاملة للشيخ محمد اللحيدان - رمضان 1446 - (Surat Al-Hijr(MP3_160K.mp3"
    },
    {
      "title": "سورة الكهف", 
      "file": "سورة الكهف كاملة للشيخ محمد اللحيدان - رمضان 1446 - (Surat Al-Kahf(MP3_160K.mp3"
    },
    {
      "title": "سورة المؤمنون", 
      "file": "سورة المؤمنون كاملة للشيخ محمد اللحيدان - رمضان 1446 - (Surat Al-Mu_minun(MP3_160K.mp3"
    },
    {
      "title": "سورة المدثر", 
      "file": "سورة المدثر كاملة للشيخ محمد اللحيدان - رمضان 1446 - (Surat Al-Muddathir(MP3_160K.mp3"
    },
    {
      "title": "سورة لقمان", 
      "file": "سورة لقمان كاملة للشيخ محمد اللحيدان - رمضان 1446 - (Surat Luqman(MP3_160K.mp3"
    },
    {
      "title": "سورة يوسف", 
      "file": "سورة يوسف كاملة للشيخ محمد اللحيدان - رمضان 1446 - (Surat Yusuf(MP3_160K.mp3"
    },
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
        SnackBar(content: Text("عذراً، الملف غير موجود: ${playlist[index]['file']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3D4A),
      appBar: AppBar(
        title: const Text("القارئ محمد اللحيدان", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.cyanAccent,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage('assets/images/luhaydan.jpg'),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _currentTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text("محمد اللحيدان", style: TextStyle(color: Colors.cyanAccent, fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2C5364),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: playlist.length,
                separatorBuilder: (context, index) => const Divider(color: Colors.white10),
                itemBuilder: (context, index) {
                  bool isPlaying = _currentIndex == index;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isPlaying ? Colors.cyanAccent : Colors.white12,
                      child: Text("${index + 1}", style: TextStyle(color: isPlaying ? Colors.black : Colors.white)),
                    ),
                    title: Text(
                      playlist[index]['title']!,
                      style: TextStyle(color: isPlaying ? Colors.cyanAccent : Colors.white, fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal),
                    ),
                    trailing: Icon(isPlaying ? Icons.equalizer : Icons.play_arrow_rounded, color: Colors.cyanAccent),
                    onTap: () => _playSurah(index),
                  );
                },
              ),
            ),
          ),
          Container(
            color: const Color(0xFF162E38),
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<Duration?>(
                  stream: _audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final total = _audioPlayer.duration ?? Duration.zero;
                    return ProgressBar(
                      progress: position,
                      total: total,
                      baseBarColor: Colors.white24,
                      progressBarColor: Colors.cyanAccent,
                      thumbColor: Colors.cyanAccent,
                      timeLabelTextStyle: const TextStyle(color: Colors.white),
                      onSeek: (duration) => _audioPlayer.seek(duration),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(icon: const Icon(Icons.shuffle, color: Colors.white), onPressed: () {}),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white, size: 35),
                      onPressed: _currentIndex != null && _currentIndex! > 0 ? () => _playSurah(_currentIndex! - 1) : null,
                    ),
                    StreamBuilder<PlayerState>(
                      stream: _audioPlayer.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final playing = playerState?.playing ?? false;
                        if (playing) {
                          return IconButton(
                            icon: const Icon(Icons.pause_circle_filled, color: Colors.cyanAccent, size: 65),
                            onPressed: _audioPlayer.pause,
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(Icons.play_circle_filled, color: Colors.cyanAccent, size: 65),
                            onPressed: _audioPlayer.play,
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white, size: 35),
                      onPressed: _currentIndex != null && _currentIndex! < playlist.length - 1 ? () => _playSurah(_currentIndex! + 1) : null,
                    ),
                    IconButton(icon: const Icon(Icons.repeat, color: Colors.white), onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
