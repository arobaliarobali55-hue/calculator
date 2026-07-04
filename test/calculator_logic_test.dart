import 'package:flutter_test/flutter_test.dart';
import 'package:totalizer/utils/calculator_logic.dart';

void main() {
  group('CalculatorLogic Unit Tests', () {
    test('Addition works correctly', () {
      expect(CalculatorLogic.calculateResult(5, 3, '+'), 8);
    });

    test('Subtraction works correctly', () {
      expect(CalculatorLogic.calculateResult(10, 4, '-'), 6);
    });

    test('Multiplication works correctly', () {
      expect(CalculatorLogic.calculateResult(4, 3, '×'), 12);
    });

    test('Division works correctly', () {
      expect(CalculatorLogic.calculateResult(12, 3, '÷'), 4);
    });

    test('Division by zero returns 0', () {
      expect(CalculatorLogic.calculateResult(5, 0, '÷'), 0);
    });

    test('Square root works correctly', () {
      expect(CalculatorLogic.calculateResult(0, 0, '√'),
          0); // Not using this for sqrt
      expect(CalculatorLogic.calculateFunction('√', 16), 4);
    });

    test('Formatting long decimals', () {
      expect(CalculatorLogic.formatResult(1 / 3), '0.33333333');
    });
  });
}
