import 'package:flutter/material.dart';

class CurrencyRegulationScreen extends StatefulWidget {
  const CurrencyRegulationScreen({super.key});

  @override
  State<CurrencyRegulationScreen> createState() => _CurrencyRegulationScreenState();
}

class _CurrencyRegulationScreenState extends State<CurrencyRegulationScreen> {
  // Default exchange rates (units per 1 USD)
  final Map<String, double> _defaultRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'JPY': 156.0,
    'CAD': 1.37,
    'INR': 89.50,
    'BDT': 117.50,
  };

  // Names for default currencies
  final Map<String, String> _currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'CAD': 'Canadian Dollar',
    'INR': 'Indian Rupee',
    'BDT': 'Bangladeshi Taka',
  };

  late Map<String, double> _exchangeRates;
  
  // Converter state
  final TextEditingController _amountController = TextEditingController(text: '100');
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  String _convertedAmount = '';

  @override
  void initState() {
    super.initState();
    _exchangeRates = Map.from(_defaultRates);
    _convertCurrency();
  }

  void _convertCurrency() {
    if (_amountController.text.isEmpty) {
      setState(() {
        _convertedAmount = '';
      });
      return;
    }

    double? amount = double.tryParse(_amountController.text);
    if (amount == null) {
      setState(() {
        _convertedAmount = 'Invalid amount';
      });
      return;
    }

    if (!_exchangeRates.containsKey(_fromCurrency) || !_exchangeRates.containsKey(_toCurrency)) {
      setState(() {
        _convertedAmount = 'Currency not found';
      });
      return;
    }

    double fromRate = _exchangeRates[_fromCurrency]!;
    double toRate = _exchangeRates[_toCurrency]!;

    if (fromRate <= 0 || toRate <= 0) {
      setState(() {
        _convertedAmount = 'Invalid rates';
      });
      return;
    }

    // Convert from Source Currency to USD, then USD to Target Currency
    double amountInUsd = amount / fromRate;
    double finalAmount = amountInUsd * toRate;

    setState(() {
      _convertedAmount = finalAmount.toStringAsFixed(2);
    });
  }

  IconData _getCurrencyIcon(String code) {
    switch (code) {
      case 'USD':
      case 'CAD':
        return Icons.attach_money_rounded;
      case 'EUR':
        return Icons.euro_rounded;
      case 'GBP':
        return Icons.currency_pound_rounded;
      case 'JPY':
        return Icons.currency_yen_rounded;
      case 'INR':
        return Icons.currency_rupee_rounded;
      case 'BDT':
        return Icons.money_rounded;
      default:
        return Icons.currency_exchange_rounded;
    }
  }

  void _editRate(String code) {
    final controller = TextEditingController(text: _exchangeRates[code].toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Edit Rate for $code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specify exchange rate relative to USD (1 USD = ? $code)',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Exchange Rate',
                hintText: 'e.g. 1.25',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              double? newRate = double.tryParse(controller.text);
              if (newRate != null && newRate > 0) {
                setState(() {
                  _exchangeRates[code] = newRate;
                });
                _convertCurrency();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Updated $code exchange rate to $newRate')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid rate greater than 0')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addCustomCurrency() {
    final codeController = TextEditingController();
    final rateController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Custom Currency'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                textCapitalization: TextCapitalization.characters,
                maxLength: 3,
                decoration: InputDecoration(
                  labelText: 'Currency Code (3 letters)',
                  hintText: 'e.g. AUD',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Currency Name',
                  hintText: 'e.g. Australian Dollar',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: rateController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Exchange Rate (1 USD = ?)',
                  hintText: 'e.g. 1.50',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              String code = codeController.text.trim().toUpperCase();
              String name = nameController.text.trim();
              double? rate = double.tryParse(rateController.text);

              if (code.length != 3) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Currency Code must be exactly 3 characters.')),
                );
                return;
              }
              if (_exchangeRates.containsKey(code)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Currency $code already exists.')),
                );
                return;
              }
              if (rate == null || rate <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid rate greater than 0.')),
                );
                return;
              }

              setState(() {
                _exchangeRates[code] = rate;
                if (name.isNotEmpty) {
                  _currencyNames[code] = name;
                } else {
                  _currencyNames[code] = 'Custom Currency';
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added custom currency $code ($name)')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteCurrency(String code) {
    if (_defaultRates.containsKey(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Baseline currencies cannot be deleted.')),
      );
      return;
    }

    setState(() {
      _exchangeRates.remove(code);
      _currencyNames.remove(code);
      if (_fromCurrency == code) _fromCurrency = 'USD';
      if (_toCurrency == code) _toCurrency = 'USD';
    });
    _convertCurrency();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted currency $code')),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Rates'),
        content: const Text('Are you sure you want to reset all exchange rates to default baseline values? This will also remove custom currencies.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _exchangeRates = Map.from(_defaultRates);
                _fromCurrency = 'USD';
                _toCurrency = 'INR';
              });
              _convertCurrency();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reset exchange rates to default baseline.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Regulation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset to Baseline',
            onPressed: _resetToDefaults,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [Colors.blue[50]!, Colors.white, Colors.blue[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Converter Panel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                    ),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Exchange Rate Calculator',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: _amountController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: 'Amount',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              onChanged: (value) => _convertCurrency(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _fromCurrency,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _fromCurrency = newValue;
                                      });
                                      _convertCurrency();
                                    }
                                  },
                                  items: _exchangeRates.keys.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.grey),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _toCurrency,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _toCurrency = newValue;
                                      });
                                      _convertCurrency();
                                    }
                                  },
                                  items: _exchangeRates.keys.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Converted Value:',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              _convertedAmount.isEmpty ? '0.00' : '$_convertedAmount $_toCurrency',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.blue[300] : Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Rates Title and Add Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Regulated Exchange Rates',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Custom'),
                      onPressed: _addCustomCurrency,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),

              // Rates List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: _exchangeRates.length,
                  itemBuilder: (context, index) {
                    String code = _exchangeRates.keys.elementAt(index);
                    double rate = _exchangeRates[code]!;
                    String name = _currencyNames[code] ?? 'Custom Currency';
                    bool isBaseCurrency = code == 'USD';
                    bool isCustom = !_defaultRates.containsKey(code);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 0,
                      color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          foregroundColor: Colors.blueAccent,
                          child: Icon(_getCurrencyIcon(code)),
                        ),
                        title: Row(
                          children: [
                            Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (isBaseCurrency) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'BASE',
                                  style: TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            if (isCustom) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amberAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'CUSTOM',
                                  style: TextStyle(fontSize: 9, color: Colors.orange, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Text(
                          '$name\nRate: $rate',
                          style: const TextStyle(fontSize: 12),
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_rounded, color: Colors.grey),
                              tooltip: 'Edit exchange rate',
                              onPressed: isBaseCurrency ? null : () => _editRate(code),
                            ),
                            if (isCustom)
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                tooltip: 'Delete currency',
                                onPressed: () => _deleteCurrency(code),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
