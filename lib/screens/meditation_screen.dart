import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import 'meditation_progress_services.dart';

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
  final MeditationProgressService _progressService =
      MeditationProgressService();

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
          _saveMeditationProgress();
        }
      });
    });
  }

  void _saveMeditationProgress() {
    _progressService.saveMeditationSession(_duration).then((_) {
      // Show completion dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Session Complete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                'Congratulations! You completed $_duration minutes of meditation.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Failed to save meditation progress. Please check your internet connection.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void _stopTimer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session'),
        content:
            const Text('Are you sure you want to end this meditation session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isRunning = false;
                _timer.cancel();
              });
            },
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightGreen, primaryGreen],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              if (!_isRunning)
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Meditation Timer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _isRunning
                                ? _formatTime(_remainingSeconds)
                                : '$_duration:00',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            if (_duration > 1) {
                              setState(() => _duration--);
                            }
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
                      onPressed: _isRunning ? _stopTimer : _startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isRunning ? Icons.stop : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isRunning ? 'Stop' : 'Start',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.white,
        elevation: 5,
      ),
      child: Icon(icon, color: primaryGreen),
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
