import 'package:dhyan/screens/daily_motivation_screen.dart';
import 'package:dhyan/screens/meditation_screen.dart';
import 'package:dhyan/screens/music_screen.dart';
import 'package:dhyan/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen2> {
  final Color primaryColor = const Color(0xFFA8D8B9);
  final Color secondaryColor = const Color(0xFF508D4E);
  final Color accentColor = const Color(0xFFD4B2D8);

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
        title: const Text('Dhyaan', style: TextStyle(color: Colors.black)),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
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
        return MusicScreen();
      case 3:
        return DailyMotivationScreen();
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Dhyaan',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 20),
              Text(
                'Quick Actions',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 10),
              _buildQuickActionGrid(),
              const SizedBox(height: 20),
              Text(
                'Today\'s Recommended Meditation',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 10),
              _buildRecommendedMeditation(),
              const SizedBox(height: 20),
              Text(
                'Your Progress',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 10),
              _buildProgressSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _buildQuickActionItem('Quick Meditation', Icons.timer, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeditationScreen()),
          );
        }),
        _buildQuickActionItem('Breathing Exercise', Icons.air, () {
          // TODO: Implement breathing exercise screen
          _showComingSoonDialog('Breathing Exercise');
        }),
        _buildQuickActionItem('Daily Challenge', Icons.stars, () {
          // TODO: Implement daily challenge screen
          _showComingSoonDialog('Daily Challenge');
        }),
        _buildQuickActionItem('Journal', Icons.book, () {
          // TODO: Implement journal screen
          _showComingSoonDialog('Journal');
        }),
      ],
    );
  }

  Widget _buildQuickActionItem(
      String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffACE1AF), //secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: secondaryColor),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: Text('The $feature feature is coming soon!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecommendedMeditation() {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.play_circle_filled, color: accentColor),
        title: const Text('Mindful Breathing'),
        subtitle: const Text('10 minutes'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeditationScreen()),
          );
        },
      ),
    );
  }

  Widget _buildProgressSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Meditation Streak: 5 days',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            const Text('Total Meditation Time: 2 hours',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: 0.6,
              backgroundColor: primaryColor.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
