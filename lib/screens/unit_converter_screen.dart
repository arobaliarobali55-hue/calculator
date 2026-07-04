import 'package:flutter/material.dart';
import '../utils/unit_converter_logic.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController inputController = TextEditingController();
  String selectedCategory = 'Length';
  String fromUnit = 'Meter';
  String toUnit = 'Kilometer';
  String result = '';

  final Map<String, List<String>> units = {
    'Length': UnitConverterLogic.lengthMultipliers.keys.toList(),
    'Weight': UnitConverterLogic.weightMultipliers.keys.toList(),
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Volume': ['Liter', 'Milliliter', 'Gallon', 'Cubic Meter'],
  };

  void convert() {
    double? input = double.tryParse(inputController.text);
    if (input == null) return;

    double converted = 0;

    if (selectedCategory == 'Length') {
      converted = UnitConverterLogic.convertGeneral(
          input, fromUnit, toUnit, UnitConverterLogic.lengthMultipliers);
    } else if (selectedCategory == 'Weight') {
      converted = UnitConverterLogic.convertGeneral(
          input, fromUnit, toUnit, UnitConverterLogic.weightMultipliers);
    } else if (selectedCategory == 'Temperature') {
      converted =
          UnitConverterLogic.convertTemperature(input, fromUnit, toUnit);
    } else if (selectedCategory == 'Volume') {
      converted = UnitConverterLogic.convertGeneral(
          input, fromUnit, toUnit, UnitConverterLogic.volumeMultipliers);
    }

    setState(() {
      result = '${converted.toStringAsFixed(4)} $toUnit';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2d3561),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF2d3561),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  underline: const SizedBox(),
                  items: units.keys.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                      fromUnit = units[selectedCategory]![0];
                      toUnit = units[selectedCategory]![1];
                      result = '';
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: inputController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter value',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2d3561),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2d3561),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: fromUnit,
                        isExpanded: true,
                        dropdownColor: const Color(0xFF2d3561),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        underline: const SizedBox(),
                        items: units[selectedCategory]!.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            fromUnit = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2d3561),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: toUnit,
                        isExpanded: true,
                        dropdownColor: const Color(0xFF2d3561),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        underline: const SizedBox(),
                        items: units[selectedCategory]!.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            toUnit = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: convert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Convert',
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
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
