import 'dart:math';

class CalculatorLogic {
  static double calculateFunction(String func, double num) {
    switch (func) {
      case 'sin':
        return sin(num * pi / 180);
      case 'cos':
        return cos(num * pi / 180);
      case 'tan':
        return tan(num * pi / 180);
      case 'ln':
        return log(num);
      case 'log':
        return log(num) / ln10;
      case '√':
        return sqrt(num);
      default:
        return 0;
    }
  }

  static double calculateResult(
      double firstOperand, double secondOperand, String operation) {
    switch (operation) {
      case '+':
        return firstOperand + secondOperand;
      case '-':
        return firstOperand - secondOperand;
      case '×':
        return firstOperand * secondOperand;
      case '÷':
        return secondOperand != 0 ? firstOperand / secondOperand : 0;
      default:
        return 0;
    }
  }

  static String formatResult(double result) {
    String str = result.toString();
    if (str.length > 12) {
      return result.toStringAsFixed(8);
    }
    return str;
  }
}
