import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DailyMotivationScreen extends StatefulWidget {
  @override
  DailyMotivationScreenState createState() => DailyMotivationScreenState();
}

class DailyMotivationScreenState extends State<DailyMotivationScreen> {
  String quote = "";
  String author = "";
  bool isLoading = true;
  String error = "";

  // Replace 'YOUR_API_KEY' with the actual API key you received
  final String apiKey = 'YOUR_API_KEY';

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    setState(() {
      isLoading = true;
      error = "";
    });

    try {
      final response = await http.get(
        Uri.parse('https://zenquotes.io/api/random'),
        headers: {'X-API-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            quote = data[0]['q'];
            author = data[0]['a'];
            isLoading = false;
          });
        } else {
          throw Exception('No quote received');
        }
      } else {
        throw Exception(
            'Failed to load quote. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        error = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Motivation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CircularProgressIndicator()
              else if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.red))
              else
                Column(
                  children: [
                    Text(
                      quote,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "- $author",
                      style: const TextStyle(
                          fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: fetchQuote,
                child: const Text('New Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
