import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200, // Adjust this value as needed
                child: Lottie.network(
                  'https://lottie.host/8e5d219e-c636-4abd-adca-eb9702542b17/A4JeYUkOz4.json', // Replace with your chosen Lottie animation URL
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  // TODO: Implement login logic
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
              TextButton(
                child: const Text('Don\'t have an account? Register'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
