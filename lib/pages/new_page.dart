import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  void _pop(BuildContext context) {
    Navigator.pop<int>(context, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pop(context),
          child: const Text('Pop with value 10'),
        ),
      ),
    );
  }
}
