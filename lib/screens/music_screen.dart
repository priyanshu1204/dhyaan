import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentTrack = '';

  List<String> tracks = [
    'soothing_music_1.mp3',
    'soothing_music_2.mp3',
    'soothing_music_3.mp3',
  ];

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playPause(String track) async {
    if (isPlaying && currentTrack == track) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      String url = 'assets/$track';
      await audioPlayer.play(AssetSource(url));
      setState(() {
        isPlaying = true;
        currentTrack = track;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soothing Music'),
      ),
      body: ListView.builder(
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tracks[index]),
            trailing: IconButton(
              icon: Icon(
                currentTrack == tracks[index] && isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
              onPressed: () => playPause(tracks[index]),
            ),
          );
        },
      ),
    );
  }
}
