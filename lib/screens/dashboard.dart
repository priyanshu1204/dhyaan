import 'package:flutter/material.dart';
import '../homescreen2.dart';

// import 'meditation_screen.dart';
// import 'mood_tracker_screen.dart';
// import 'profile_screen.dart';
// import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen2(),
    // MeditationScreen(),
    // MoodTrackerScreen(),
    // ProfileScreen(),
    // SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
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
            icon: Icon(Icons.mood),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:meditation_app/pages/songboard.dart';
// import '../widgets/meditation_card.dart';
// import '../utils/constants.dart';
// import '../utils/assets.dart';
//
// class Dashboard extends StatelessWidget {
//   const Dashboard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     child: const Icon(
//                       Icons.arrow_back,
//                       size: 30,
//                       color: Colors.deepPurple,
//                     ),
//                     onTap: () => Navigator.pop(context),
//                   ),
//                   const Text(
//                     "Hey Sweetie!",
//                     style: kLargeTextStyle,
//                   ),
//                 ],
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 30, bottom: 30),
//                 child: Text(
//                   "What's your mood today?",
//                   style: kMeduimTextStyle,
//                 ),
//               ),
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 20,
//                   crossAxisSpacing: 30,
//                   children: [
//                     MeditationCard(
//                       title: 'Mediate',
//                       description: 'Breathe',
//                       image: kMeditateImageSource,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SongBoard(
//                               musicName: kMeditateTitle,
//                               imageSource: kMeditateImageSource,
//                               musicSource: kMeditateMusicSource,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     MeditationCard(
//                       title: 'Relax',
//                       description: 'Read Book',
//                       image: kRelaxImageSource,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SongBoard(
//                               musicName: kRelaxTitle,
//                               imageSource: kRelaxImageSource,
//                               musicSource: kRelaxMusicSource,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     MeditationCard(
//                       title: kBrainTitle,
//                       description: kBrainSubtitle,
//                       image: kBrainImageSource,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SongBoard(
//                               musicName: kBrainTitle,
//                               imageSource: kBrainImageSource,
//                               musicSource: kBrainMusicSource,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     MeditationCard(
//                       title: kStudyTitle,
//                       description: kStudySubtitle,
//                       image: kStudyImageSource,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SongBoard(
//                               musicName: kStudyTitle,
//                               imageSource: kStudyImageSource,
//                               musicSource: kStudyMusicSource,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     MeditationCard(
//                       title: 'Sleep',
//                       description: 'Good Night',
//                       image: kSleepImageSource,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SongBoard(
//                               musicName: 'Sleep',
//                               imageSource: kSleepImageSource,
//                               musicSource: kSleepMusicSource,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     MeditationCard(
//                       title: 'Focus',
//                       description: 'Goals',
//                       image: kFocusImageSource,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SongBoard(
//                               musicName: 'Focus',
//                               imageSource: kFocusImageSource,
//                               musicSource: kFocusMusicSource,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
