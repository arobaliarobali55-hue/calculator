import 'package:flutter/material.dart';
import '../utils/financial_logic.dart';

class CompoundInterestCalculatorScreen extends StatefulWidget {
  const CompoundInterestCalculatorScreen({super.key});

  @override
  State<CompoundInterestCalculatorScreen> createState() =>
      _CompoundInterestCalculatorScreenState();
}

class _CompoundInterestCalculatorScreenState
    extends State<CompoundInterestCalculatorScreen> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _compoundFrequencyController =
      TextEditingController();

  String _result = "";

  void _calculateCompoundInterest() {
    double? principal = double.tryParse(_principalController.text);
    double? rate = double.tryParse(_rateController.text);
    double? time = double.tryParse(_timeController.text);
    int? compoundFrequency = int.tryParse(_compoundFrequencyController.text);

    if (principal != null &&
        rate != null &&
        time != null &&
        compoundFrequency != null &&
        compoundFrequency > 0) {
      double amount = FinancialLogic.calculateCompoundInterest(
        principal: principal,
        rate: rate,
        time: time,
        timesCompounded: compoundFrequency,
      );
      setState(() {
        _result = "Final Amount: \$${amount.toStringAsFixed(2)}";
      });
    } else {
      setState(() {
        _result = "Invalid Input";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compound Interest Calculator"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _principalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Principal Amount (\$)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Annual Interest Rate (%)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Time (Years)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _compoundFrequencyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText:
                    "Compounding Frequency (e.g., 1 for annually, 12 for monthly)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateCompoundInterest,
              child: const Text("Calculate Compound Interest"),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
