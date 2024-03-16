import 'package:flutter/material.dart';
import 'package:flutter_flirting/pages/new_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? returnValue;

  void _onTap() async {
    returnValue = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => const NewPage(),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(returnValue?.toString() ?? 'N/A'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onTap,
              child: const Text('Push new page'),
            ),
          ],
        ),
      ),
    );
  }
}
