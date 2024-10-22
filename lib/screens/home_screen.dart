//import 'package:dhyan/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../homescreen2.dart';
import '../utils/constants.dart';
import '../widgets/rectangle_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image.asset("assets/images/meditation.png"),
              Container(
                height: 200, // Adjust this value as needed
                child: Lottie.network(
                  'https://lottie.host/602f2d9d-1093-4584-8d3c-163f1f568019/Pm1ktuT9Zp.json', // Replace with your chosen Lottie animation URL
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Time to meditate",
                style: kLargeTextStyle,
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "Take a breath,\nand ease your mind",
                  style: kMeduimTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              RectangleButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen2(),
                    )),
                child: const Text(
                  "Let's get started",
                  style: kButtonTextStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
