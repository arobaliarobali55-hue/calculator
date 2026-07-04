class BusinessLogic {
  static double calculateMargin(double cost, double revenue) {
    if (revenue == 0) return 0;
    return ((revenue - cost) / revenue) * 100;
  }

  static double calculateMarkup(double cost, double revenue) {
    if (cost == 0) return 0;
    return ((revenue - cost) / cost) * 100;
  }

  static double calculateBreakEven(
      double fixedCosts, double unitPrice, double unitCost) {
    if (unitPrice <= unitCost) return 0;
    return fixedCosts / (unitPrice - unitCost);
  }

  static double calculateROI(double initialInvestment, double finalValue) {
    if (initialInvestment == 0) return 0;
    return ((finalValue - initialInvestment) / initialInvestment) * 100;
  }

  static double calculateProfit(double cost, double revenue) {
    return revenue - cost;
  }

  static double calculateDepreciation(
      double cost, double salvageValue, double lifeInYears) {
    if (lifeInYears <= 0) return 0;
    return (cost - salvageValue) / lifeInYears;
  }
}
