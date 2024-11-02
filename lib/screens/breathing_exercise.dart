import 'package:flutter/material.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _phase = "Inhale";
  int _currentCycle = 0;
  static const int totalCycles = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addListener(() {
        if (_controller.value < 0.5) {
          setState(() => _phase = "Inhale");
        } else {
          setState(() => _phase = "Exhale");
        }
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _currentCycle++);
        if (_currentCycle < totalCycles) {
          _controller.reset();
          _controller.forward();
        }
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercise'),
        backgroundColor: const Color(0xFFA8D8B9),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFA8D8B9).withOpacity(0.6), Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _phase,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 200 + (_controller.value * 100),
                    height: 200 + (_controller.value * 100),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD4B2D8).withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        '${(_controller.value * 8).toInt()} s',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                'Cycle ${_currentCycle + 1} of $totalCycles',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
