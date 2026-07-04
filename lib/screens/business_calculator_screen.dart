import 'package:flutter/material.dart';
import '../utils/business_logic.dart';

class BusinessCalculatorScreen extends StatefulWidget {
  const BusinessCalculatorScreen({super.key});

  @override
  State<BusinessCalculatorScreen> createState() =>
      _BusinessCalculatorScreenState();
}

class _BusinessCalculatorScreenState extends State<BusinessCalculatorScreen> {
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _revenueController = TextEditingController();
  final TextEditingController _fixedCostsController = TextEditingController();
  final TextEditingController _pricePerUnitController = TextEditingController();
  final TextEditingController _costPerUnitController = TextEditingController();

  String _marginResult = "";
  String _markupResult = "";
  String _profitResult = "";
  String _breakEvenResult = "";
  String _depreciationResult = "";

  final TextEditingController _depAssetCostController = TextEditingController();
  final TextEditingController _depSalvageController = TextEditingController();
  final TextEditingController _depLifeController = TextEditingController();

  void _calculateProfit() {
    double cost = double.tryParse(_costController.text) ?? 0;
    double revenue = double.tryParse(_revenueController.text) ?? 0;

    setState(() {
      double margin = BusinessLogic.calculateMargin(cost, revenue);
      double markup = BusinessLogic.calculateMarkup(cost, revenue);
      double profit = BusinessLogic.calculateProfit(cost, revenue);

      _marginResult = "Margin: ${margin.toStringAsFixed(2)}%";
      _markupResult = "Markup: ${markup.toStringAsFixed(2)}%";
      _profitResult = "Gross Profit: \$${profit.toStringAsFixed(2)}";
    });
  }

  void _calculateDepreciation() {
    double cost = double.tryParse(_depAssetCostController.text) ?? 0;
    double salvage = double.tryParse(_depSalvageController.text) ?? 0;
    double life = double.tryParse(_depLifeController.text) ?? 0;

    setState(() {
      double dep = BusinessLogic.calculateDepreciation(cost, salvage, life);
      _depreciationResult = "Annual Depreciation: \$${dep.toStringAsFixed(2)}";
    });
  }

  void _calculateBreakEven() {
    double fixed = double.tryParse(_fixedCostsController.text) ?? 0;
    double price = double.tryParse(_pricePerUnitController.text) ?? 0;
    double cost = double.tryParse(_costPerUnitController.text) ?? 0;

    setState(() {
      double result = BusinessLogic.calculateBreakEven(fixed, price, cost);
      _breakEvenResult = "Break-even Units: ${result.toStringAsFixed(0)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Calculator'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Profit & Margin'),
              const SizedBox(height: 16),
              _buildTextField(_costController, 'Cost Price (\$)'),
              const SizedBox(height: 12),
              _buildTextField(_revenueController, 'Selling Price (\$)'),
              const SizedBox(height: 16),
              _buildActionButton('Calculate Profit', _calculateProfit),
              if (_profitResult.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildResultCard(
                    '$_profitResult\n$_marginResult\n$_markupResult'),
              ],
              const SizedBox(height: 32),
              _buildSectionTitle('Break-even Analysis'),
              const SizedBox(height: 16),
              _buildTextField(_fixedCostsController, 'Fixed Costs (\$)'),
              const SizedBox(height: 12),
              _buildTextField(_pricePerUnitController, 'Price per Unit (\$)'),
              const SizedBox(height: 12),
              _buildTextField(
                  _costPerUnitController, 'Variable Cost per Unit (\$)'),
              const SizedBox(height: 16),
              _buildActionButton('Calculate Break-even', _calculateBreakEven),
              if (_breakEvenResult.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildResultCard(_breakEvenResult),
              ],
              const SizedBox(height: 32),
              _buildSectionTitle('Straight-line Depreciation'),
              const SizedBox(height: 16),
              _buildTextField(_depAssetCostController, 'Asset Cost (\$)'),
              const SizedBox(height: 12),
              _buildTextField(_depSalvageController, 'Salvage Value (\$)'),
              const SizedBox(height: 12),
              _buildTextField(_depLifeController, 'Useful Life (Years)'),
              const SizedBox(height: 16),
              _buildActionButton(
                  'Calculate Depreciation', _calculateDepreciation),
              if (_depreciationResult.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildResultCard(_depreciationResult),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildResultCard(String result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Text(
        result,
        style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            height: 1.5,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
