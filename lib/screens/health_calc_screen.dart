import 'package:flutter/material.dart';

class HealthCalcScreen extends StatefulWidget {
  const HealthCalcScreen({super.key});

  @override
  State<HealthCalcScreen> createState() => _HealthCalcScreenState();
}

class _HealthCalcScreenState extends State<HealthCalcScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String gender = 'Male';
  String activityLevel = 'Sedentary';
  String result = '';

  final Map<String, double> activityMultipliers = {
    'Sedentary': 1.2,
    'Lightly Active': 1.375,
    'Moderately Active': 1.55,
    'Very Active': 1.725,
    'Extra Active': 1.9,
  };

  void calculate() {
    double? age = double.tryParse(ageController.text);
    double? weight = double.tryParse(weightController.text);
    double? height = double.tryParse(heightController.text);

    if (age == null || weight == null || height == null) return;

    // Miflin-St Jeor Equation
    double bmr = (10 * weight) + (6.25 * height) - (5 * age);
    if (gender == 'Male') {
      bmr += 5;
    } else {
      bmr -= 161;
    }

    double tdee = bmr * activityMultipliers[activityLevel]!;

    setState(() {
      result =
          'BMR: ${bmr.toStringAsFixed(0)} kcal/day\nTDEE: ${tdee.toStringAsFixed(0)} kcal/day';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Health Calculator'),
          backgroundColor: const Color(0xFF0f3460)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Calculate your BMR and Daily Needs',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'Age',
                    labelStyle: TextStyle(color: Colors.white70)),
              ),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    labelStyle: TextStyle(color: Colors.white70)),
              ),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 24),
              const Text('Gender', style: TextStyle(color: Colors.white70)),
              DropdownButton<String>(
                value: gender,
                dropdownColor: const Color(0xFF16213e),
                style: const TextStyle(color: Colors.white),
                items: ['Male', 'Female']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => gender = v!),
              ),
              const SizedBox(height: 16),
              const Text('Activity Level',
                  style: TextStyle(color: Colors.white70)),
              DropdownButton<String>(
                value: activityLevel,
                isExpanded: true,
                dropdownColor: const Color(0xFF16213e),
                style: const TextStyle(color: Colors.white),
                items: activityMultipliers.keys
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => activityLevel = v!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: calculate,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    foregroundColor: Colors.white),
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 24),
              if (result.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: const Color(0xFF2d3561),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(result,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 18, height: 1.5),
                      textAlign: TextAlign.center),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
