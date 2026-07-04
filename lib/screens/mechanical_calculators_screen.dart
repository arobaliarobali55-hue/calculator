import 'package:flutter/material.dart';

class MechanicalCalculatorsScreen extends StatefulWidget {
  const MechanicalCalculatorsScreen({super.key});

  @override
  State<MechanicalCalculatorsScreen> createState() =>
      _MechanicalCalculatorsScreenState();
}

class _MechanicalCalculatorsScreenState
    extends State<MechanicalCalculatorsScreen> {
  double _sliderValue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B1B17), // Wood color
      appBar: AppBar(
          title: const Text('Mechanical (Slide Rule)'),
          backgroundColor: Colors.brown[900]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("17th Century Slide Rule",
                style: TextStyle(
                    color: Color(0xFFF5DEB3),
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 60),
            LayoutBuilder(
              builder: (context, constraints) {
                double rulerWidth = constraints.maxWidth * 0.9;
                if (rulerWidth > 400) rulerWidth = 400;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Fixed outer scale
                    Container(
                      width: rulerWidth,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5DC),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                    // Sliding inner scale
                    Transform.translate(
                      offset:
                          Offset((_sliderValue - 50) * (rulerWidth / 100), 0),
                      child: Container(
                        width: rulerWidth,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEDC82),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                    // Indicator
                    Container(width: 2, height: 120, color: Colors.red),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              activeColor: const Color(0xFFF5DEB3),
              onChanged: (val) => setState(() => _sliderValue = val),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "A slide rule is a mechanical analog computer used primarily for multiplication and division. Slide the center piece to align values!",
                style: TextStyle(
                    color: Color(0xFFF5DEB3), fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
