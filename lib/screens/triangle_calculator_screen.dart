import 'dart:math';
import 'package:flutter/material.dart';

class TriangleCalculatorScreen extends StatefulWidget {
  const TriangleCalculatorScreen({super.key});

  @override
  State<TriangleCalculatorScreen> createState() =>
      _TriangleCalculatorScreenState();
}

class _TriangleCalculatorScreenState extends State<TriangleCalculatorScreen> {
  final TextEditingController _sideAController = TextEditingController();
  final TextEditingController _sideBController = TextEditingController();
  final TextEditingController _sideCController = TextEditingController();
  final TextEditingController _angleAController = TextEditingController();
  final TextEditingController _angleBController = TextEditingController();

  Map<String, double?> results = {
    'A': null,
    'B': null,
    'C': null,
    'a': null,
    'b': null,
    'area': null,
    'perimeter': null,
    'circumcircle': null,
    'incircle': null,
    'height': null,
  };

  void _calculate() {
    double? A = double.tryParse(_sideAController.text);
    double? B = double.tryParse(_sideBController.text);
    double? C = double.tryParse(_sideCController.text);
    double? a = double.tryParse(_angleAController.text);
    double? b = double.tryParse(_angleBController.text);

    int inputsCount = [A, B, C, a, b].where((e) => e != null).length;
    bool hasSide = [A, B, C].any((e) => e != null);

    if (inputsCount < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least 2 values')),
      );
      return;
    }

    if (!hasSide) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one side must be provided')),
      );
      return;
    }

    try {
      // Logic for Right Triangle (c = 90)
      if (A != null && B != null) {
        C = sqrt(pow(A, 2) + pow(B, 2));
        a = atan(A / B) * 180 / pi;
        b = 90 - a;
      } else if (A != null && C != null) {
        if (C <= A) throw Exception('Hypotenuse must be longer than side');
        B = sqrt(pow(C, 2) - pow(A, 2));
        a = asin(A / C) * 180 / pi;
        b = 90 - a;
      } else if (B != null && C != null) {
        if (C <= B) throw Exception('Hypotenuse must be longer than side');
        A = sqrt(pow(C, 2) - pow(B, 2));
        b = asin(B / C) * 180 / pi;
        a = 90 - b;
      } else if (A != null && a != null) {
        C = A / sin(a * pi / 180);
        B = A / tan(a * pi / 180);
        b = 90 - a;
      } else if (A != null && b != null) {
        B = A * tan(b * pi / 180);
        C = A / cos(b * pi / 180);
        a = 90 - b;
      } else if (B != null && a != null) {
        A = B * tan(a * pi / 180);
        C = B / cos(a * pi / 180);
        b = 90 - a;
      } else if (B != null && b != null) {
        C = B / sin(b * pi / 180);
        A = B / tan(b * pi / 180);
        a = 90 - b;
      } else if (C != null && a != null) {
        A = C * sin(a * pi / 180);
        B = C * cos(a * pi / 180);
        b = 90 - a;
      } else if (C != null && b != null) {
        B = C * sin(b * pi / 180);
        A = C * cos(b * pi / 180);
        a = 90 - b;
      }

      if (A != null && B != null && C != null && a != null && b != null) {
        final double resA = A;
        final double resB = B;
        final double resC = C;
        final double resAngleA = a;
        final double resAngleB = b;

        setState(() {
          results['A'] = resA;
          results['B'] = resB;
          results['C'] = resC;
          results['a'] = resAngleA;
          results['b'] = resAngleB;
          results['area'] = 0.5 * resA * resB;
          results['perimeter'] = resA + resB + resC;
          results['circumcircle'] = resC / 2;
          results['incircle'] = (resA + resB - resC) / 2;
          results['height'] = (resA * resB) / resC;

          _sideAController.text = resA.toStringAsFixed(3);
          _sideBController.text = resB.toStringAsFixed(3);
          _sideCController.text = resC.toStringAsFixed(3);
          _angleAController.text = resAngleA.toStringAsFixed(3);
          _angleBController.text = resAngleB.toStringAsFixed(3);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Error: ${e.toString().replaceAll('Exception: ', '')}')),
      );
    }
  }

  void _reset() {
    setState(() {
      _sideAController.clear();
      _sideBController.clear();
      _sideCController.clear();
      _angleAController.clear();
      _angleBController.clear();
      results.updateAll((key, value) => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Triangle Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
                  : [Colors.blue[700]!, Colors.blue[400]!],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[50]!, Colors.white],
                ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Diagram Section
              Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: CustomPaint(
                  painter: RightTrianglePainter(isDark: isDark),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Right Triangle (Enter any 2 values)',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Inputs Grid
              Row(
                children: [
                  Expanded(
                      child: _buildInputField(
                          'A (Side)', _sideAController, isDark)),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildInputField(
                          'B (Side)', _sideBController, isDark)),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildInputField(
                          'C (Hypo)', _sideCController, isDark)),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: _buildInputField(
                          'a° (Angle)', _angleAController, isDark)),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildInputField(
                          'b° (Angle)', _angleBController, isDark)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          const Text('c°',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey)),
                          Text('90°',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('CALCULATE',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      side: BorderSide(color: Colors.blue[600]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('RESET',
                        style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Extra Results
              if (results['area'] != null) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Extra Parameters',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      _buildResultRow('Area', results['area']!, isDark),
                      _buildResultRow(
                          'Perimeter', results['perimeter']!, isDark),
                      _buildResultRow('Circumcircle Radius',
                          results['circumcircle']!, isDark),
                      _buildResultRow(
                          'Incircle Radius', results['incircle']!, isDark),
                      _buildResultRow('Height (h)', results['height']!, isDark),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            filled: true,
            fillColor:
                isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, double value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
          Text(value.toStringAsFixed(3),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class RightTrianglePainter extends CustomPainter {
  final bool isDark;
  RightTrianglePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    double padding = 40;

    // Triangle vertices
    Offset p1 = Offset(padding, padding); // Top
    Offset p2 = Offset(padding, size.height - padding); // Bottom Left (90 deg)
    Offset p3 =
        Offset(size.width - padding, size.height - padding); // Bottom Right

    // Draw triangle
    Path path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    // Fill triangle with subtle gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue.withValues(alpha: 0.15),
          Colors.blue.withValues(alpha: 0.05)
        ],
      ).createShader(Rect.fromPoints(p1, p3))
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);

    // Draw 90 deg square
    double sSize = 15;
    canvas.drawRect(Rect.fromLTWH(p2.dx, p2.dy - sSize, sSize, sSize), paint);

    // Labels
    _drawLabel(canvas, "A", Offset(p2.dx - 15, (p1.dy + p2.dy) / 2), isDark);
    _drawLabel(canvas, "B", Offset((p2.dx + p3.dx) / 2, p2.dy + 15), isDark);
    _drawLabel(canvas, "C",
        Offset((p1.dx + p3.dx) / 2 + 15, (p1.dy + p3.dy) / 2 - 15), isDark);

    _drawLabel(canvas, "a°", Offset(p3.dx - 30, p3.dy - 15), isDark,
        fontSize: 12);
    _drawLabel(canvas, "b°", Offset(p1.dx + 15, p1.dy + 30), isDark,
        fontSize: 12);
    _drawLabel(canvas, "90°", Offset(p2.dx + 18, p2.dy - 18), isDark,
        fontSize: 10);
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, bool isDark,
      {double fontSize = 14}) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: isDark ? Colors.white70 : Colors.black87,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(offset.dx - textPainter.width / 2,
            offset.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
