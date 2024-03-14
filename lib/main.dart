import 'package:flutter/material.dart';
import 'package:flutter_flirting/widgets/balance_widget.dart';
import 'package:flutter_flirting/widgets/card_widget.dart';
import 'package:flutter_flirting/widgets/spend_widget.dart';

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
        backgroundColor: Colors.grey.shade800,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hello GDSC_KW!',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Image.network(
                        'https://avatars.githubusercontent.com/u/146928825?s=48&v=4'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    Transform.scale(
                      scale: 0.9,
                      child: Transform.translate(
                        offset: const Offset(0, 20),
                        child: CardWidget(
                          number: '0000-0000-0000-0000',
                          color: Colors.yellow.shade800,
                        ),
                      ),
                    ),
                    const CardWidget(
                      name: 'Vizza',
                      number: '0000-0000-0000-0000',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 50),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                '3월 지출내역',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 20),
                              for (int i = 0; i < 20; i++)
                                SpendWidget(
                                  where: '어디서 썼더라?',
                                  value: 100 + i,
                                ),
                              SizedBox(
                                height: MediaQuery.paddingOf(context).bottom,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -120),
                        child: const BalanceWidget(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
