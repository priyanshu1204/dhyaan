import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  int? currentlyPlayingIndex;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  List<Map<String, String>> meditationTracks = [
    {'title': 'Peaceful Rain', 'url': 'music/calm-quest.mp3'},
    {'title': 'Ocean Waves', 'url': 'music/cold-october.mp3'},
    {'title': 'Forest Ambience', 'url': 'music/forest-lullaby.mp3'},
    {'title': 'Calm Quest', 'url': 'music/relax-your-mind.mp3'},
    {'title': 'Relax Mind', 'url': 'music/meditate.mp3'},
  ];

  @override
  void initState() {
    super.initState();

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        currentlyPlayingIndex = null;
        position = Duration.zero;
      });
    });
  }

  Future<void> playTrack(int index) async {
    if (currentlyPlayingIndex == index) {
      // If the same track is clicked, pause it
      await audioPlayer.pause();
      setState(() {
        currentlyPlayingIndex = null;
      });
    } else {
      // If a different track is clicked or no track is playing
      if (currentlyPlayingIndex != null) {
        // Stop the currently playing track
        await audioPlayer.stop();
      }
      // Play the new track
      await audioPlayer.play(AssetSource(meditationTracks[index]['url']!));
      setState(() {
        currentlyPlayingIndex = index;
      });
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Dhyaan Music'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: meditationTracks.length,
                itemBuilder: (context, index) {
                  final isThisPlaying = currentlyPlayingIndex == index;
                  return Card(
                    elevation: isThisPlaying ? 4 : 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        meditationTracks[index]['title']!,
                        style: TextStyle(
                          fontWeight: isThisPlaying
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isThisPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 32,
                          color: isThisPlaying ? Colors.blue : Colors.grey[700],
                        ),
                        onPressed: () => playTrack(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (currentlyPlayingIndex != null) ...[
              const SizedBox(height: 20),
              Text(
                'Now Playing: ${meditationTracks[currentlyPlayingIndex!]['title']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  await audioPlayer.seek(Duration(seconds: value.toInt()));
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position)),
                    Text(formatTime(duration)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
