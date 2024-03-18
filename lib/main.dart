import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flirting/repository/number_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NumberRepository numberRepository = NumberRepository();

  final ValueNotifier<bool> _isDataLoading = ValueNotifier(false);
  final ValueNotifier<int?> _data = ValueNotifier<int?>(null);

  void _getData() async {
    _isDataLoading.value = true;
    _data.value = await numberRepository.getNumber(20);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BUILD');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Future example'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('This is future'),
              Center(
                child: FutureBuilder(
                  future: numberRepository.getNumber(10),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.toString(),
                        style: const TextStyle(fontSize: 20),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text('This is stream'),
              StreamBuilder(
                stream: numberRepository.getNumStream(),
                initialData: 0,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!.toString(),
                      style: const TextStyle(fontSize: 20),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 30),
              const Text('Loading by interaction'),
              Center(
                child: ValueListenableBuilder(
                  valueListenable: _data,
                  builder: (context, value, child) {
                    if (value == null) {
                      return ValueListenableBuilder(
                        valueListenable: _isDataLoading,
                        builder: (context, isLoading, child) {
                          if (!isLoading) {
                            return ElevatedButton(
                              onPressed: _getData,
                              child: const Text('Get 20'),
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      );
                    }
                    return Text(
                      value.toString(),
                      style: const TextStyle(fontSize: 20),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
