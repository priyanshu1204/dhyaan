import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dhyan/screens/breathing_exercise.dart';
import 'package:dhyan/screens/daily_motivation_screen.dart';
//import 'package:dhyan/screens/detailed_progress_screen.dart';
import 'package:dhyan/screens/journals.dart';
import 'package:dhyan/screens/meditation_screen.dart';
import 'package:dhyan/screens/music_screen.dart';
import 'package:dhyan/screens/profile_screen.dart';
//import 'package:dhyan/screens/meditation_progress_services.dart';
import 'daily_challenges.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen2> {
  final Color primaryColor = const Color(0xFFBDE5D1);
  final Color secondaryColor = const Color(0xFF78A97E);
  final Color accentColor = const Color(0xFF4CAF50);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late int totalMeditationMinutes = 0;
  late int meditationStreak = 0;
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    if (currentUserId == null) return;

    try {
      // Get lifetime stats
      final lifetimeStats = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('stats')
          .doc('lifetime')
          .get();

      // Get streak stats
      final streakStats = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('stats')
          .doc('streak')
          .get();

      setState(() {
        totalMeditationMinutes = lifetimeStats.data()?['totalMinutes'] ?? 0;
        meditationStreak = streakStats.data()?['currentStreak'] ?? 0;
      });
    } catch (e) {
      print('Error loading user progress: $e');
      // Handle error appropriately
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dhyaan',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ).then((_) =>
                  _loadUserProgress()); // Reload progress when returning from profile
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Meditate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Motivation',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const MeditationScreen();
      case 2:
        return const MusicScreen();
      case 3:
        return const DailyMotivationScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primaryColor.withOpacity(0.6), Colors.white],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadUserProgress,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                const SizedBox(height: 20),
                _buildQuickActionsSection(),
                const SizedBox(height: 20),
                _buildRecommendedSection(),
                const SizedBox(height: 20),
                _buildProgressSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Dhyaan',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(currentUserId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data?.data() != null) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return Text(
                'Hello, ${userData['name'] ?? 'Meditator'}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black54,
                    ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        _buildQuickActionGrid(),
      ],
    );
  }

  Widget _buildQuickActionGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildQuickActionItem(
          'Quick Meditation',
          Icons.timer,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MeditationScreen()),
            ).then((_) => _loadUserProgress());
          },
        ),
        _buildQuickActionItem(
          'Breathing Exercise',
          Icons.air,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BreathingExerciseScreen()),
            );
          },
        ),
        _buildQuickActionItem(
          'Daily Challenge',
          Icons.stars,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DailyChallengeScreen()),
            );
          },
        ),
        _buildQuickActionItem(
          'Journal',
          Icons.book,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JournalScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(
      String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffACE1AF),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black87),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Recommended Meditation',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        _buildRecommendedMeditation(),
      ],
    );
  }

  Widget _buildRecommendedMeditation() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.play_circle_filled, color: accentColor, size: 32),
        title: const Text(
          'Mindful Breathing',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('10 minutes'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeditationScreen()),
          ).then((_) => _loadUserProgress());
        },
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Meditation Streak',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$meditationStreak days',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Time',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${(totalMeditationMinutes).toStringAsFixed(1)} minutes',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: (meditationStreak % 7) / 7,
                  backgroundColor: primaryColor.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Text(
                  '${7 - (meditationStreak % 7)} days until next milestone',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
