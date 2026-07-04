import 'package:flutter/material.dart';
import 'dart:math' as math;

class GeometryCalculatorScreen extends StatefulWidget {
  const GeometryCalculatorScreen({super.key});

  @override
  State<GeometryCalculatorScreen> createState() =>
      _GeometryCalculatorScreenState();
}

class _GeometryCalculatorScreenState extends State<GeometryCalculatorScreen> {
  String _selectedShape = 'Cube';
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  String _result = '';

  void _calculate() {
    setState(() {
      try {
        if (_selectedShape == 'Cube') {
          double? side = double.tryParse(_controller1.text);
          if (side != null) {
            double perimeter = 12 * side;
            double surfaceArea = 6 * math.pow(side, 2).toDouble();
            _result =
                'Perimeter (Total Edges): ${perimeter.toStringAsFixed(2)}\nSurface Area: ${surfaceArea.toStringAsFixed(2)}';
          } else {
            _result = 'Please enter a valid side length';
          }
        } else if (_selectedShape == 'Triangle') {
          double? a = double.tryParse(_controller1.text);
          double? b = double.tryParse(_controller2.text);
          double? c = double.tryParse(_controller3.text);
          if (a != null && b != null && c != null) {
            double perimeter = a + b + c;
            _result = 'Perimeter: ${perimeter.toStringAsFixed(2)}';
          } else {
            _result = 'Please enter all three sides';
          }
        } else if (_selectedShape == 'Circle') {
          double? radius = double.tryParse(_controller1.text);
          if (radius != null) {
            double perimeter = 2 * math.pi * radius;
            double area = math.pi * math.pow(radius, 2);
            _result =
                'Perimeter (Circumference): ${perimeter.toStringAsFixed(2)}\nArea: ${area.toStringAsFixed(2)}';
          } else {
            _result = 'Please enter a valid radius';
          }
        }
      } catch (e) {
        _result = 'Error in calculation';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geometry Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border:
                    Border.all(color: isDark ? Colors.white24 : Colors.black12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedShape,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedShape = newValue!;
                      _controller1.clear();
                      _controller2.clear();
                      _controller3.clear();
                      _result = '';
                    });
                  },
                  items: <String>['Cube', 'Triangle', 'Circle']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (_selectedShape == 'Cube')
              _buildInputField(_controller1, 'Side Length'),
            if (_selectedShape == 'Triangle') ...[
              _buildInputField(_controller1, 'Side A'),
              const SizedBox(height: 15),
              _buildInputField(_controller2, 'Side B'),
              const SizedBox(height: 15),
              _buildInputField(_controller3, 'Side C'),
            ],
            if (_selectedShape == 'Circle')
              _buildInputField(_controller1, 'Radius'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Calculate', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 40),
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white10
                      : Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _result,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
      ),
    );
  }
}
