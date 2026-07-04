import 'package:flutter/material.dart';
import '../widgets/adaptive_banner_ad.dart';

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? birthDate;
  String result = '';

  void _calculateAge() {
    if (birthDate == null) return;
    DateTime now = DateTime.now();
    int years = now.year - birthDate!.year;
    int months = now.month - birthDate!.month;
    int days = now.day - birthDate!.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(now.year, now.month, 0).day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    setState(() {
      result = 'Age: $years Years, $months Months, $days Days';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Age Calculator'),
          backgroundColor: const Color(0xFF0f3460)),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1a1a2e),
                    Color(0xFF16213e),
                    Color(0xFF0f3460)
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: birthDate ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => birthDate = picked);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2d3561),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(12)),
                      child: Text(birthDate == null
                          ? 'Select Birth Date'
                          : 'Birth Date: ${birthDate!.day}/${birthDate!.month}/${birthDate!.year}'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _calculateAge,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(20)),
                      child: const Text('Calculate Age'),
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
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const AdaptiveBannerAd(),
        ],
      ),
    );
  }
}
