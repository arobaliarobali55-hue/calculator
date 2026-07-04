import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/calculator_logic.dart';

class ScientificCalculatorScreen extends StatefulWidget {
  const ScientificCalculatorScreen({super.key});

  @override
  State<ScientificCalculatorScreen> createState() =>
      _ScientificCalculatorScreenState();
}

class _ScientificCalculatorScreenState
    extends State<ScientificCalculatorScreen> {
  String display = '0';
  String expression = '';
  double? firstOperand;
  String? operation;
  bool shouldResetDisplay = false;

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = '0';
        expression = '';
        firstOperand = null;
        operation = null;
      } else if (value == 'DEL') {
        if (display.length > 1) {
          display = display.substring(0, display.length - 1);
        } else {
          display = '0';
        }
      } else if (value == '=') {
        calculateResult();
      } else if (['+', '-', '×', '÷'].contains(value)) {
        if (firstOperand == null) {
          firstOperand = double.tryParse(display);
          operation = value;
          expression = '$display $value ';
          shouldResetDisplay = true;
        } else {
          calculateResult();
          operation = value;
          expression = '$display $value ';
          shouldResetDisplay = true;
        }
      } else if (value == 'sin' ||
          value == 'cos' ||
          value == 'tan' ||
          value == 'ln' ||
          value == 'log' ||
          value == '√') {
        calculateFunction(value);
      } else if (value == 'π') {
        display = pi.toString();
      } else if (value == 'e') {
        display = e.toString();
      } else if (value == 'x²') {
        double num = double.tryParse(display) ?? 0;
        display = (num * num).toString();
      } else if (value == '±') {
        if (display != '0') {
          if (display.startsWith('-')) {
            display = display.substring(1);
          } else {
            display = '-$display';
          }
        }
      } else {
        if (shouldResetDisplay) {
          display = value;
          shouldResetDisplay = false;
        } else {
          if (display == '0') {
            display = value;
          } else {
            display += value;
          }
        }
        expression += value;
      }
    });
  }

  void calculateFunction(String func) {
    double num = double.tryParse(display) ?? 0;
    double result = CalculatorLogic.calculateFunction(func, num);

    setState(() {
      expression = '$func(${CalculatorLogic.formatResult(num)})';
      display = CalculatorLogic.formatResult(result);
      shouldResetDisplay = true;
    });
  }

  void calculateResult() {
    if (firstOperand != null && operation != null) {
      double secondOperand = double.tryParse(display) ?? 0;
      double result = CalculatorLogic.calculateResult(
          firstOperand!, secondOperand, operation!);

      display = CalculatorLogic.formatResult(result);
      expression = '';
      firstOperand = null;
      operation = null;
      shouldResetDisplay = true;
    }
  }

  Widget buildButton(String text, {Color? color, bool isWide = false}) {
    return Expanded(
      flex: isWide ? 2 : 1,
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color(0xFF2d3561),
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (expression.isNotEmpty)
                    Text(
                      expression,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      display,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          buildButton('sin', color: const Color(0xFF4a5568)),
                          buildButton('cos', color: const Color(0xFF4a5568)),
                          buildButton('tan', color: const Color(0xFF4a5568)),
                          buildButton('DEL', color: const Color(0xFFe74c3c)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          buildButton('ln', color: const Color(0xFF4a5568)),
                          buildButton('log', color: const Color(0xFF4a5568)),
                          buildButton('√', color: const Color(0xFF4a5568)),
                          buildButton('÷', color: const Color(0xFF3498db)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          buildButton('7'),
                          buildButton('8'),
                          buildButton('9'),
                          buildButton('×', color: const Color(0xFF3498db)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          buildButton('4'),
                          buildButton('5'),
                          buildButton('6'),
                          buildButton('-', color: const Color(0xFF3498db)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          buildButton('1'),
                          buildButton('2'),
                          buildButton('3'),
                          buildButton('+', color: const Color(0xFF3498db)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          buildButton('±'),
                          buildButton('0'),
                          buildButton('.'),
                          buildButton('=', color: const Color(0xFF27ae60)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          buildButton('π', color: const Color(0xFF4a5568)),
                          buildButton('e', color: const Color(0xFF4a5568)),
                          buildButton('x²', color: const Color(0xFF4a5568)),
                          buildButton('C', color: const Color(0xFFe74c3c)),
                        ],
                      ),
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
