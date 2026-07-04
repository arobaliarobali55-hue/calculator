import 'package:flutter/material.dart';

class DiscountCalculatorScreen extends StatefulWidget {
  const DiscountCalculatorScreen({super.key});

  @override
  State<DiscountCalculatorScreen> createState() =>
      _DiscountCalculatorScreenState();
}

class _DiscountCalculatorScreenState extends State<DiscountCalculatorScreen> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  String result = '';

  void _calculate() {
    double? price = double.tryParse(priceController.text);
    double? discount = double.tryParse(discountController.text);

    if (price == null || discount == null) return;

    double savings = price * (discount / 100);
    double finalPrice = price - savings;

    setState(() {
      result =
          'Final Price: \$${finalPrice.toStringAsFixed(2)}\nYou Save: \$${savings.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Discount Calculator'),
          backgroundColor: const Color(0xFF0f3460)),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'Original Price (\$)',
                    labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'Discount (%)',
                    labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12)),
                child: const Text('Calculate Discount'),
              ),
              const SizedBox(height: 40),
              if (result.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: const Color(0xFF2d3561),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(result,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22, height: 1.5),
                      textAlign: TextAlign.center),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
