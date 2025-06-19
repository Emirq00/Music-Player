import 'package:flutter/material.dart';
import '../code/counter.dart';

class HomePage extends StatefulWidget {
  const HomePage({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Counter counter = Counter();

  void _increment() {
    setState(() => counter.increment());
  }

  void _decrement() {
    setState(() => counter.decrement());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current value: ${counter.value}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _increment, child: const Text('+')),
                const SizedBox(width: 20),
                ElevatedButton(onPressed: _decrement, child: const Text('-')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
