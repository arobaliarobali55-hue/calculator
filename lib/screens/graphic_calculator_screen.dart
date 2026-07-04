import 'package:flutter/material.dart';

class GraphicCalculatorScreen extends StatefulWidget {
  const GraphicCalculatorScreen({super.key});

  @override
  State<GraphicCalculatorScreen> createState() =>
      _GraphicCalculatorScreenState();
}

class _GraphicCalculatorScreenState extends State<GraphicCalculatorScreen> {
  final TextEditingController _aController = TextEditingController(text: "1");
  final TextEditingController _bController = TextEditingController(text: "0");
  final TextEditingController _cController = TextEditingController(text: "0");

  double a = 1, b = 0, c = 0;

  void _updateGraph() {
    setState(() {
      a = double.tryParse(_aController.text) ?? 1;
      b = double.tryParse(_bController.text) ?? 0;
      c = double.tryParse(_cController.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Graphic Calculator'),
          backgroundColor: const Color(0xFF0f3460)),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f3460)
          ]),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 2)),
                child: CustomPaint(
                    painter: GraphPainter(a, b, c), size: Size.infinite),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text("Equation: y = ax² + bx + c",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildInput("a", _aController),
                        _buildInput("b", _bController),
                        _buildInput("c", _cController),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateGraph,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50)),
                      child: const Text("Plot Graph"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final double a, b, c;
  GraphPainter(this.a, this.b, this.c);

  @override
  void paint(Canvas canvas, Size size) {
    final paintAxis = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1;
    final paintGraph = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double scale = 20.0;

    // Draw Axes
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), paintAxis);
    canvas.drawLine(
        Offset(centerX, 0), Offset(centerX, size.height), paintAxis);

    // Draw Function
    Path path = Path();
    bool first = true;

    for (double x = -centerX / scale; x <= centerX / scale; x += 0.1) {
      double y = a * x * x + b * x + c;
      double screenX = centerX + x * scale;
      double screenY = centerY - y * scale;

      if (first) {
        path.moveTo(screenX, screenY);
        first = false;
      } else {
        path.lineTo(screenX, screenY);
      }
    }
    canvas.drawPath(path, paintGraph);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
