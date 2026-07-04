import 'dart:math';

class FinancialLogic {
  static Map<String, double> calculateLoan({
    required double principal,
    required double annualRate,
    required double years,
  }) {
    double monthlyRate = annualRate / 100 / 12;
    double months = years * 12;

    double monthlyPayment =
        (principal * monthlyRate * pow(1 + monthlyRate, months)) /
            (pow(1 + monthlyRate, months) - 1);

    double totalPayment = monthlyPayment * months;
    double totalInterest = totalPayment - principal;

    return {
      'monthlyPayment': monthlyPayment,
      'totalPayment': totalPayment,
      'totalInterest': totalInterest,
    };
  }

  static double calculateCompoundInterest({
    required double principal,
    required double rate,
    required double time,
    required int timesCompounded,
  }) {
    return principal *
        pow((1 + (rate / 100) / timesCompounded), timesCompounded * time);
  }
}
