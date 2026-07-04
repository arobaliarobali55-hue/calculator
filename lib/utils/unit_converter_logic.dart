class UnitConverterLogic {
  static const Map<String, double> lengthMultipliers = {
    'Meter': 1.0,
    'Kilometer': 1000.0,
    'Mile': 1609.34,
    'Foot': 0.3048,
    'Inch': 0.0254,
    'Centimeter': 0.01,
    'Millimeter': 0.001,
    'Yard': 0.9144,
  };

  static const Map<String, double> weightMultipliers = {
    'Kilogram': 1.0,
    'Gram': 0.001,
    'Pound': 0.453592,
    'Ounce': 0.0283495,
    'Ton': 1000.0,
    'Milligram': 0.000001,
  };

  static const Map<String, double> volumeMultipliers = {
    'Liter': 1.0,
    'Milliliter': 0.001,
    'Gallon': 3.78541,
    'Cubic Meter': 1000.0,
  };

  static double convertGeneral(
      double value, String from, String to, Map<String, double> multipliers) {
    if (!multipliers.containsKey(from) || !multipliers.containsKey(to)) {
      return 0;
    }
    return value * (multipliers[from]! / multipliers[to]!);
  }

  static double convertTemperature(double value, String from, String to) {
    if (from == to) return value;
    double celsius;
    if (from == 'Fahrenheit') {
      celsius = (value - 32) * 5 / 9;
    } else if (from == 'Kelvin') {
      celsius = value - 273.15;
    } else {
      celsius = value;
    }

    if (to == 'Fahrenheit') {
      return (celsius * 9 / 5) + 32;
    } else if (to == 'Kelvin') {
      return celsius + 273.15;
    }
    return celsius;
  }
}
