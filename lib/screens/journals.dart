import 'package:flutter/material.dart';

class JournalEntry {
  final String date;
  final String title;
  final String content;
  final String mood;

  JournalEntry({
    required this.date,
    required this.title,
    required this.content,
    required this.mood,
  });
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final List<JournalEntry> _entries = [];
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedMood = '😊';

  void _addEntry() {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      setState(() {
        _entries.add(JournalEntry(
          date: DateTime.now().toString().split(' ')[0],
          title: _titleController.text,
          content: _contentController.text,
          mood: _selectedMood,
        ));
        _titleController.clear();
        _contentController.clear();
        _selectedMood = '😊';
      });
      Navigator.pop(context);
    }
  }

  void _showAddEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Journal Entry'),
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _addEntry,
            child: const Text('Save'),
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
        child: _entries.isEmpty
            ? Center(
                child: Text(
                  'Start journaling your meditation journey',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )
            : ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
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
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntryDialog,
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
