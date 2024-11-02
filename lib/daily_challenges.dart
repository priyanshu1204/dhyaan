import 'package:flutter/material.dart';

class DailyChallengeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _challenges = [
    {
      'title': 'Morning Mindfulness',
      'description': 'Start your day with a 5-minute meditation session',
      'completed': false,
    },
    {
      'title': 'Gratitude Practice',
      'description': 'Write down 3 things you\'re grateful for today',
      'completed': false,
    },
    {
      'title': 'Mindful Walking',
      'description': 'Take a 10-minute walk focusing on each step',
      'completed': false,
    },
    {
      'title': 'Digital Detox',
      'description': 'Take a 1-hour break from all digital devices',
      'completed': false,
    },
    {
      'title': 'Breathing Exercise',
      'description': 'Complete one session of deep breathing exercises',
      'completed': false,
    },
  ];

  DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenges'),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Complete these challenges to improve your mindfulness practice',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _challenges.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListTile(
                      leading: Icon(
                        _challenges[index]['completed']
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: const Color(0xFF508D4E),
                      ),
                      title: Text(_challenges[index]['title']),
                      subtitle: Text(_challenges[index]['description']),
                      onTap: () {
                        // Show completion dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Complete Challenge'),
                            content: Text(
                                'Have you completed "${_challenges[index]['title']}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Not Yet'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Mark as completed logic would go here
                                  Navigator.pop(context);
                                },
                                child: const Text('Yes, Complete!'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
