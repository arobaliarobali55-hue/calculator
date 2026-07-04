import 'package:flutter/material.dart';

class WatchCalculatorScreen extends StatefulWidget {
  const WatchCalculatorScreen({super.key});

  @override
  State<WatchCalculatorScreen> createState() => _WatchCalculatorScreenState();
}

class _WatchCalculatorScreenState extends State<WatchCalculatorScreen> {
  String _display = "0";
  double _firstOperand = 0;
  String _operator = "";
  bool _shouldReset = false;

  void _onPressed(String value) {
    setState(() {
      if (value == "C") {
        _display = "0";
        _firstOperand = 0;
        _operator = "";
      } else if (value == "=") {
        if (_operator.isNotEmpty) {
          double second = double.tryParse(_display) ?? 0;
          double result = 0;
          switch (_operator) {
            case "+":
              result = _firstOperand + second;
              break;
            case "-":
              result = _firstOperand - second;
              break;
            case "×":
              result = _firstOperand * second;
              break;
            case "÷":
              result = second != 0 ? _firstOperand / second : 0;
              break;
          }
          _display = result.toString();
          if (_display.endsWith(".0")) {
            _display = _display.substring(0, _display.length - 2);
          }
          _operator = "";
          _shouldReset = true;
        }
      } else if (["+", "-", "×", "÷"].contains(value)) {
        _firstOperand = double.tryParse(_display) ?? 0;
        _operator = value;
        _shouldReset = true;
      } else {
        if (_display == "0" || _shouldReset) {
          _display = value;
          _shouldReset = false;
        } else {
          _display += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Watch Calculator (Retro)'),
        backgroundColor: Colors.grey[900],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey[700]!, width: 4),
              boxShadow: [
                BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Watch Display
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFC4D4AF), // Liquid Crystal Display color
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Text(
                    _display,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 24),
                // Buttons Grid
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton("÷", color: Colors.orange),
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton("×", color: Colors.orange),
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton("-", color: Colors.orange),
                    _buildButton("C", color: Colors.red),
                    _buildButton("0"),
                    _buildButton("="),
                    _buildButton("+", color: Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, {Color? color}) {
    return SizedBox(
      width: 55,
      height: 55,
      child: ElevatedButton(
        onPressed: () => _onPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.grey[800],
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
