import 'package:flutter/material.dart';
import 'package:practice_app/loading_animations/straggered_dots.dart';
import 'package:practice_app/loading_animations/waved_dots.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24),
            ),
            const WaveDots(size: 100, color: Colors.amber),
            const StaggeredDotsWave(size: 100, color: Colors.red),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
