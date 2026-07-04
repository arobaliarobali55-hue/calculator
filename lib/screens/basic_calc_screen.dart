import 'package:flutter/material.dart';

class BasicCalcScreen extends StatefulWidget {
  const BasicCalcScreen({super.key});

  @override
  State<BasicCalcScreen> createState() => _BasicCalcScreenState();
}

class _BasicCalcScreenState extends State<BasicCalcScreen> {
  String _display = '0';
  String _history = '';
  double? _firstOperand;
  String? _operator;
  bool _shouldReset = false;

  void _onNumberPress(String val) {
    setState(() {
      if (val == '.') {
        if (!_display.contains('.')) {
          _display += val;
        }
      } else if (_display == '0' || _shouldReset) {
        _display = val;
        _shouldReset = false;
      } else {
        _display += val;
      }
    });
  }

  void _onOperatorPress(String op) {
    if (_firstOperand != null && _operator != null && !_shouldReset) {
      _calculateResult();
    }
    setState(() {
      _firstOperand = double.tryParse(_display);
      _operator = op;
      _history = '$_display $op';
      _shouldReset = true;
    });
  }

  void _calculateResult() {
    if (_firstOperand == null || _operator == null) return;
    double secondOperand = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '×':
        result = _firstOperand! * secondOperand;
        break;
      case '÷':
        result = secondOperand == 0 ? 0 : _firstOperand! / secondOperand;
        break;
    }

    setState(() {
      if (result.isInfinite || result.isNaN) {
        _display = 'Error';
      } else if (result % 1 == 0) {
        _display = result.toInt().toString();
      } else {
        String formatted = result.toStringAsFixed(8);
        while (formatted.contains('.') &&
            (formatted.endsWith('0') || formatted.endsWith('.'))) {
          formatted = formatted.substring(0, formatted.length - 1);
        }
        _display = formatted;
      }
      _firstOperand = result; // Allow chaining
      _operator = null;
      _history = '';
      _shouldReset = true;
    });
  }

  void _onClear() {
    setState(() {
      _display = '0';
      _history = '';
      _firstOperand = null;
      _operator = null;
    });
  }

  void _onDelete() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  Widget _buildButton(String label,
      {Color? color, VoidCallback? onPressed, bool isLarge = false, Widget? child}) {
    return Expanded(
      flex: isLarge ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onPressed ?? () => _onNumberPress(label),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: color ?? Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Center(
              child: child ?? Text(
                label,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: color != null ? Colors.white : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [const Color(0xFF1a1a2e), const Color(0xFF0f3460)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _history,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          _display,
                          style: const TextStyle(
                            fontSize: 72,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  Row(children: [
                    _buildButton('AC',
                        color: Colors.redAccent.withValues(alpha: 0.3),
                        onPressed: _onClear,
                        isLarge: true),
                    _buildButton('DEL',
                        color: Colors.orangeAccent.withValues(alpha: 0.3),
                        onPressed: _onDelete,
                        child: const Icon(Icons.backspace_outlined, size: 28, color: Colors.white)),
                    _buildButton('÷',
                        color: Colors.blueAccent.withValues(alpha: 0.3),
                        onPressed: () => _onOperatorPress('÷')),
                  ]),
                  Row(children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×',
                        color: Colors.blueAccent.withValues(alpha: 0.3),
                        onPressed: () => _onOperatorPress('×')),
                  ]),
                  Row(children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-',
                        color: Colors.blueAccent.withValues(alpha: 0.3),
                        onPressed: () => _onOperatorPress('-')),
                  ]),
                  Row(children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+',
                        color: Colors.blueAccent.withValues(alpha: 0.3),
                        onPressed: () => _onOperatorPress('+')),
                  ]),
                  Row(children: [
                    _buildButton('0', isLarge: true),
                    _buildButton('.'),
                    _buildButton('=',
                        color: Colors.greenAccent.withValues(alpha: 0.4),
                        onPressed: _calculateResult),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
