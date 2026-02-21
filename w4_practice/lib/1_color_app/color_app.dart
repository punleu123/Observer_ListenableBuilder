import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Home()),
    ),
  );
}

enum CardType {
  red(Colors.red),
  green(Colors.green),
  yellow(Colors.yellow),
  blue(Colors.blue);

  const CardType(this.color);
  final Color color;
}

class TapCountNotifier extends ChangeNotifier {
  final Map<CardType, int> _tapCounts = {
    for (var type in CardType.values) type: 0,
  };
  int getCount(CardType type) => _tapCounts[type]!;
  Map<CardType, int> get allCounts => _tapCounts;
  void increment(CardType type) {
    _tapCounts[type] = getCount(type) + 1;
    notifyListeners();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final TapCountNotifier _tapCountNotifier = TapCountNotifier();

  @override
  void dispose() {
    _tapCountNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? ColorTapsScreen(notifier: _tapCountNotifier)
          : StatisticsScreen(notifier: _tapCountNotifier),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.tap_and_play),
            label: 'Taps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}

class ColorTapsScreen extends StatelessWidget {
  final TapCountNotifier notifier;

  const ColorTapsScreen({super.key, required this.notifier});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Taps')),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, child) {
          return Column(
            children: CardType.values.map((type) {
              return ColorTap(
                type: type,
                tapCount: notifier.getCount(type),
                onTap: () => notifier.increment(type),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;
  final int tapCount;
  final VoidCallback onTap;

  const ColorTap({
    super.key,
    required this.type,
    required this.tapCount,
    required this.onTap,
  });

  Color get backgroundColor => type.color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 100,
        child: Center(
          child: Text(
            'Taps: $tapCount',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  final TapCountNotifier notifier;

  const StatisticsScreen({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: notifier.allCounts.entries.map((entry) {
                return Text(
                  'Number of ${entry.key.name} = ${entry.value}',
                  style: TextStyle(fontSize: 24),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
