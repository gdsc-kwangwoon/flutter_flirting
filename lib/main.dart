import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<int> _items = [];

  void _loadMore() async {
    await Future.delayed(const Duration(seconds: 1));
    var startIdx = _items.length;
    for (var i = startIdx; i < startIdx + 20; i++) {
      _items.add(i);
    }
    setState(() {});
  }

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
          title: const Text('List view example'),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.red,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    for (var i in List.generate(20, (index) => index))
                      _ListViewItem(idx: i),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.blue,
                child: CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemBuilder: (context, index) =>
                          _ListViewItem(idx: index),
                      itemCount: 20,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                color: Colors.green,
                child: CustomScrollView(
                  slivers: [
                    SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2 / 1,
                      ),
                      itemBuilder: (context, index) =>
                          _ListViewItem(idx: index),
                      itemCount: 10,
                    ),
                    SliverAppBar(
                      title: const Text('Sliver example'),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(20),
                        child: Container(
                          color: Colors.blue,
                          child: Column(
                            children: [
                              const Text('Infinite scroll example'),
                              Text('${_items.length} Items loaded'),
                            ],
                          ),
                        ),
                      ),
                      floating: true,
                      expandedHeight: 200,
                    ),
                    SliverList.builder(
                      itemBuilder: (context, index) {
                        if (index < _items.length) {
                          return _ListViewItem(idx: _items[index]);
                        }
                        return _LoadingWidget(
                          onBuild: _loadMore,
                        );
                      },
                      itemCount: _items.length + 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListViewItem extends StatelessWidget {
  final int idx;

  const _ListViewItem({
    super.key,
    required this.idx,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('BUILD $idx');
    return Container(
      height: 40,
      color: idx % 2 == 0
          ? Colors.black.withOpacity(0.1)
          : Colors.black.withOpacity(0.2),
      child: Center(
        child: Text('Item $idx'),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  final Function()? onBuild;

  const _LoadingWidget({
    super.key,
    this.onBuild,
  });

  @override
  Widget build(BuildContext context) {
    onBuild?.call();
    debugPrint('LOADING');
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
