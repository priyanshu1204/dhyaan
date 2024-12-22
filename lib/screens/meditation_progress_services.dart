import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class MeditationProgressService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Get current user ID
//   String? get currentUserId => _auth.currentUser?.uid;
//
//   // Save meditation session
//   Future<void> saveMeditationSession(int duration) async {
//     if (currentUserId == null) return;
//
//     try {
//       // Get the current date as string (YYYY-MM-DD)
//       final String today = DateTime.now().toString().split(' ')[0];
//
//       // Reference to user's meditation document
//       final userMeditationRef = _firestore
//           .collection('users')
//           .doc(currentUserId)
//           .collection('meditation_progress')
//           .doc(today);
//
//       // Get the current document
//       final docSnapshot = await userMeditationRef.get();
//
//       if (docSnapshot.exists) {
//         // Update existing document
//         await userMeditationRef.update({
//           'totalMinutes': FieldValue.increment(duration),
//           'sessions': FieldValue.increment(1),
//           'lastUpdated': FieldValue.serverTimestamp(),
//         });
//       } else {
//         // Create new document
//         await userMeditationRef.set({
//           'totalMinutes': duration,
//           'sessions': 1,
//           'date': today,
//           'lastUpdated': FieldValue.serverTimestamp(),
//         });
//       }
//
//       // Update lifetime stats
//       await _updateLifetimeStats(duration);
//       await _updateStreak();
//     } catch (e) {
//       print('Error saving meditation session: $e');
//       rethrow;
//     }
//   }
//
//   // Update lifetime statistics
//   Future<void> _updateLifetimeStats(int duration) async {
//     if (currentUserId == null) return;
//
//     try {
//       final userStatsRef = _firestore
//           .collection('users')
//           .doc(currentUserId)
//           .collection('stats')
//           .doc('lifetime');
//
//       final statsSnapshot = await userStatsRef.get();
//
//       if (statsSnapshot.exists) {
//         await userStatsRef.update({
//           'totalMinutes': FieldValue.increment(duration),
//           'totalSessions': FieldValue.increment(1),
//           'lastUpdated': FieldValue.serverTimestamp(),
//         });
//       } else {
//         await userStatsRef.set({
//           'totalMinutes': duration,
//           'totalSessions': 1,
//           'lastUpdated': FieldValue.serverTimestamp(),
//         });
//       }
//     } catch (e) {
//       print('Error updating lifetime stats: $e');
//       rethrow;
//     }
//   }
//
//   // Update meditation streak
//   Future<void> _updateStreak() async {
//     if (currentUserId == null) return;
//
//     try {
//       final userRef = _firestore.collection('users').doc(currentUserId);
//       final yesterday = DateTime.now().subtract(const Duration(days: 1));
//       final yesterdayStr = yesterday.toString().split(' ')[0];
//
//       // Check if user meditated yesterday
//       final yesterdayDoc = await userRef
//           .collection('meditation_progress')
//           .doc(yesterdayStr)
//           .get();
//
//       final streakRef = userRef.collection('stats').doc('streak');
//       final streakDoc = await streakRef.get();
//
//       if (streakDoc.exists) {
//         final currentStreak = streakDoc.data()?['currentStreak'] ?? 0;
//
//         if (yesterdayDoc.exists) {
//           // Continue streak
//           await streakRef.update({
//             'currentStreak': currentStreak + 1,
//             'lastUpdated': FieldValue.serverTimestamp(),
//           });
//         } else {
//           // Reset streak
//           await streakRef.update({
//             'currentStreak': 1,
//             'lastUpdated': FieldValue.serverTimestamp(),
//           });
//         }
//       } else {
//         // Initialize streak
//         await streakRef.set({
//           'currentStreak': 1,
//           'lastUpdated': FieldValue.serverTimestamp(),
//         });
//       }
//     } catch (e) {
//       print('Error updating streak: $e');
//       rethrow;
//     }
//   }
//
//   // Fetch user progress
//   Future<Map<String, dynamic>> fetchUserProgress() async {
//     if (currentUserId == null) {
//       return {'totalMinutes': 0, 'streak': 0};
//     }
//
//     try {
//       final lifetimeStats = await _firestore
//           .collection('users')
//           .doc(currentUserId)
//           .collection('stats')
//           .doc('lifetime')
//           .get();
//
//       final streakStats = await _firestore
//           .collection('users')
//           .doc(currentUserId)
//           .collection('stats')
//           .doc('streak')
//           .get();
//
//       return {
//         'totalMinutes': lifetimeStats.data()?['totalMinutes'] ?? 0,
//         'streak': streakStats.data()?['currentStreak'] ?? 0,
//       };
//     } catch (e) {
//       print('Error fetching user progress: $e');
//       return {'totalMinutes': 0, 'streak': 0};
//     }
//   }
//
//   // Get meditation history
//   Future<List<Map<String, dynamic>>> getMeditationHistory(
//       {int limit = 7}) async {
//     if (currentUserId == null) return [];
//
//     try {
//       final querySnapshot = await _firestore
//           .collection('users')
//           .doc(currentUserId)
//           .collection('meditation_progress')
//           .orderBy('date', descending: true)
//           .limit(limit)
//           .get();
//
//       return querySnapshot.docs
//           .map((doc) => {
//                 'date': doc.data()['date'],
//                 'totalMinutes': doc.data()['totalMinutes'],
//                 'sessions': doc.data()['sessions'],
//               })
//           .toList();
//     } catch (e) {
//       print('Error fetching meditation history: $e');
//       return [];
//     }
//   }
// }

class MeditationProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> saveMeditationSession(int duration) async {
    if (currentUserId == null) return;

    try {
      final String today = DateTime.now().toString().split(' ')[0];

      final userMeditationRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('meditation_progress')
          .doc(today);

      final docSnapshot = await userMeditationRef.get();

      if (docSnapshot.exists) {
        await userMeditationRef.update({
          'totalMinutes': FieldValue.increment(duration),
          'sessions': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        await userMeditationRef.set({
          'totalMinutes': duration,
          'sessions': 1,
          'date': today,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }

      // Update lifetime stats
      await _updateLifetimeStats(duration);
      await _updateStreak();
    } catch (e) {
      print('Error saving meditation session: $e');
      rethrow;
    }
  }

  Future<void> _updateLifetimeStats(int duration) async {
    if (currentUserId == null) return;

    try {
      final userStatsRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('stats')
          .doc('lifetime');

      final statsSnapshot = await userStatsRef.get();

      if (statsSnapshot.exists) {
        await userStatsRef.update({
          'totalMinutes': FieldValue.increment(duration),
          'totalSessions': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        await userStatsRef.set({
          'totalMinutes': duration,
          'totalSessions': 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating lifetime stats: $e');
      rethrow;
    }
  }

  Future<void> _updateStreak() async {
    if (currentUserId == null) return;

    try {
      final userRef = _firestore.collection('users').doc(currentUserId);
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayStr = yesterday.toString().split(' ')[0];

      final yesterdayDoc = await userRef
          .collection('meditation_progress')
          .doc(yesterdayStr)
          .get();

      final streakRef = userRef.collection('stats').doc('streak');
      final streakDoc = await streakRef.get();

      if (streakDoc.exists) {
        final currentStreak = streakDoc.data()?['currentStreak'] ?? 0;

        if (yesterdayDoc.exists) {
          await streakRef.update({
            'currentStreak': currentStreak + 1,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        } else {
          await streakRef.update({
            'currentStreak': 1,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      } else {
        await streakRef.set({
          'currentStreak': 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating streak: $e');
      rethrow;
    }
  }
}
