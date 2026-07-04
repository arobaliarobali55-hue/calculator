import 'package:flutter/material.dart';
import '../utils/statistical_logic.dart';

class StatisticalCalculatorScreen extends StatefulWidget {
  const StatisticalCalculatorScreen({super.key});

  @override
  State<StatisticalCalculatorScreen> createState() =>
      _StatisticalCalculatorScreenState();
}

class _StatisticalCalculatorScreenState
    extends State<StatisticalCalculatorScreen> {
  final TextEditingController dataController = TextEditingController();
  String result = '';

  void calculateStatistics() {
    List<String> values = dataController.text.split(',');
    List<double> numbers = [];

    for (String value in values) {
      double? num = double.tryParse(value.trim());
      if (num != null) {
        numbers.add(num);
      }
    }

    if (numbers.isEmpty) {
      setState(() {
        result = 'Please enter valid numbers separated by commas';
      });
      return;
    }

    final stats = StatisticalLogic.calculateStats(numbers);

    setState(() {
      result = '''
Count: ${stats['count']?.toInt()}
Sum: ${stats['sum']?.toStringAsFixed(2)}
Mean: ${stats['mean']?.toStringAsFixed(2)}
Median: ${stats['median']?.toStringAsFixed(2)}
Std Deviation: ${stats['stdDev']?.toStringAsFixed(2)}
Variance: ${stats['variance']?.toStringAsFixed(2)}
Min: ${stats['min']?.toStringAsFixed(2)}
Max: ${stats['max']?.toStringAsFixed(2)}
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistical Calculator'),
        backgroundColor: const Color(0xFF0f3460),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter data separated by commas',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dataController,
                maxLines: 5,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g., 10, 20, 30, 40, 50',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF2d3561),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: calculateStatistics,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Calculate Statistics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),
              if (result.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2d3561),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.5,
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
