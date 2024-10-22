import 'dart:async';
import 'package:flutter/material.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  MeditationScreenState createState() => MeditationScreenState();
}

class MeditationScreenState extends State<MeditationScreen>
    with SingleTickerProviderStateMixin {
  int _duration = 5; // Default duration in minutes
  bool _isRunning = false;
  late Timer _timer;
  int _remainingSeconds = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  final Color primaryGreen = const Color(0xFF4CAF50);
  final Color lightGreen = const Color(0xFF8BC34A);
  final Color darkGreen = const Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _remainingSeconds = _duration * 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _isRunning = false;
          _timer.cancel();
          // TODO: Add sound or vibration to notify the user
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
      _timer.cancel();
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Meditation Timer',
      //       style: TextStyle(color: Colors.white)),
      //   backgroundColor: darkGreen,
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightGreen, primaryGreen],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_animation.value * 0.1),
                    child: child,
                  );
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Text(
                      _isRunning
                          ? _formatTime(_remainingSeconds)
                          : '$_duration:00',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (!_isRunning) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircleButton(Icons.remove, () {
                      if (_duration > 1) setState(() => _duration--);
                    }),
                    const SizedBox(width: 20),
                    Text(
                      '$_duration minutes',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    _buildCircleButton(Icons.add, () {
                      setState(() => _duration++);
                    }),
                  ],
                ),
                const SizedBox(height: 40),
              ],
              ElevatedButton(
                child: Text(_isRunning ? 'Stop' : 'Start',
                    style: const TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: _isRunning ? _stopTimer : _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      child: Icon(icon, color: primaryGreen),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }
}
