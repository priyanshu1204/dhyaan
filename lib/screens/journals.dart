import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalEntry {
  final String id;
  final String date;
  final String title;
  final String content;
  final String mood;

  JournalEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.mood,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'content': content,
      'mood': mood,
    };
  }

  // Create JournalEntry from Firestore document
  factory JournalEntry.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalEntry(
      id: doc.id,
      date: data['date'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      mood: data['mood'] ?? '😊',
    );
  }
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedMood = '😊';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> get _entriesStream {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('journal_entries')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> _addEntry() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty)
      return;

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('journal_entries')
          .add({
        'date': DateTime.now().toString().split(' ')[0],
        'title': _titleController.text,
        'content': _contentController.text,
        'mood': _selectedMood,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _contentController.clear();
      _selectedMood = '😊';

      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showErrorDialog('Error saving journal entry');
    }
  }

  Future<void> _updateEntry(String entryId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('journal_entries')
          .doc(entryId)
          .update({
        'title': _titleController.text,
        'content': _contentController.text,
        'mood': _selectedMood,
        'lastEdited': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _contentController.clear();
      _selectedMood = '😊';

      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showErrorDialog('Error updating journal entry');
    }
  }

  Future<void> _deleteEntry(String entryId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('journal_entries')
          .doc(entryId)
          .delete();
    } catch (e) {
      _showErrorDialog('Error deleting journal entry');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEntryDialog([JournalEntry? existingEntry]) {
    if (existingEntry != null) {
      _titleController.text = existingEntry.title;
      _contentController.text = existingEntry.content;
      _selectedMood = existingEntry.mood;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingEntry == null ? 'New Journal Entry' : 'Edit Entry'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: _selectedMood,
                items: ['😊', '😐', '😔', '😌', '🤔']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child:
                              Text(value, style: const TextStyle(fontSize: 24)),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedMood = newValue);
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _titleController.clear();
              _contentController.clear();
              _selectedMood = '😊';
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (existingEntry == null) {
                _addEntry();
              } else {
                _updateEntry(existingEntry.id);
              }
            },
            child: Text(existingEntry == null ? 'Save' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: _entriesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'Start journaling your meditation journey',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                final entry = JournalEntry.fromDocument(doc);
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Text(
                      entry.mood,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(entry.title),
                    subtitle: Text(
                      '${entry.date}\n${entry.content}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEntryDialog(entry);
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Entry'),
                              content: const Text(
                                  'Are you sure you want to delete this entry?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteEntry(entry.id);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEntryDialog(),
        backgroundColor: const Color(0xFFD4B2D8),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
