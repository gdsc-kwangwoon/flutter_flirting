import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stateful example'),
        ),
        body: const Center(
          child: StatefulContainer(),
        ),
      ),
    );
  }
}

///
///
///
///
///
/// Bright yellow color container
class StatefulContainer extends StatefulWidget {
  const StatefulContainer({super.key});

  @override
  State<StatefulContainer> createState() => _StatefulContainerState();
}

class _StatefulContainerState extends State<StatefulContainer> {
  bool _isView = false;
  int initValue = 0;

  void _switchView() {
    setState(() {
      _isView = !_isView;
    });
  }

  void _reset() {
    setState(() {
      // initValue++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('parent');
    return Container(
      color: Colors.yellowAccent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _switchView,
                child: Text(_isView ? '숨기기' : '보이기'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _reset,
                child: const Icon(Icons.plus_one),
              ),
            ],
          ),
          const SizedBox(height: 30),
          if (_isView) StatefulCounter(initialValue: initValue)
        ],
      ),
    );
  }
}

///
///
///
///
///
/// Yellow color container
class StatefulCounter extends StatefulWidget {
  final int initialValue;

  const StatefulCounter({
    super.key,
    required this.initialValue,
  });

  @override
  State<StatefulCounter> createState() => _StatefulCounterState();
}

class _StatefulCounterState extends State<StatefulCounter> {
  late int count;

  @override
  void initState() {
    debugPrint('INIT');
    super.initState();
    count = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant StatefulCounter oldWidget) {
    debugPrint('UPDATE');
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      count = widget.initialValue;
    }
  }

  @override
  void dispose() {
    debugPrint('DISPOSE');
    super.dispose();
  }

  void _add() {
    count++;
    setState(() {});
  }

  void _substract() {
    setState(() {
      count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BUILD');
    return Container(
      color: Colors.yellow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(count.toString()),
          const SizedBox(height: 30),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _add,
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _substract,
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
