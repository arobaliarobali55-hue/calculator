import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/ad_service.dart';
import '../widgets/adaptive_banner_ad.dart';
import 'scientific_calculator_screen.dart';
import 'financial_calculator_screen.dart';
import 'statistical_calculator_screen.dart';
import 'unit_converter_screen.dart';
import 'graphic_calculator_screen.dart';
import 'business_calculator_screen.dart';
import 'bmi_calculator_screen.dart';
import 'compound_interest_calculator_screen.dart';
import 'basic_calc_screen.dart';
import 'currency_regulation_screen.dart';
import 'health_calc_screen.dart';
import 'age_calculator_screen.dart';
import 'discount_calculator_screen.dart';
import 'triangle_calculator_screen.dart';
import 'geometry_calculator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    AdService.loadInterstitialAd();
  }

  void _navigateTo(Widget screen) {
    AdService.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'This All-in-One Calculator app does not collect, store, or share any personal data from its users. \n\n'
            '1. Permissions: The app does not require sensitive permissions.\n'
            '2. Advertising: We use Google AdMob to display ads. AdMob may collect device identifiers for ad personalization.\n'
            '3. Third-Party Services: We do not use any other third-party services that collect user data.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
                      : [Colors.blue[700]!, Colors.blue[400]!],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo/logo.png', height: 60),
                    const SizedBox(height: 10),
                    const Text(
                      'All-in-One Calc',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                _showPrivacyPolicy();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About App'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'All-in-One Calculator',
                  applicationVersion: '1.0.0',
                  applicationIcon:
                      Image.asset('assets/logo/logo.png', height: 40),
                  children: [
                    const Text(
                        'A comprehensive suite of tools for all your calculation needs.'),
                  ],
                );
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child:
                  Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                    Color(0xFF0F172A)
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[50]!, Colors.white, Colors.blue[50]!],
                ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu,
                          color: isDark ? Colors.white : Colors.black87),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Calculator',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () =>
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white10
                              : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color:
                              isDark ? Colors.amber[200] : Colors.blueGrey[800],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert,
                          color: isDark ? Colors.white : Colors.black87),
                      onSelected: (value) {
                        if (value == 'theme') {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                        } else if (value == 'currency') {
                          _navigateTo(const CurrencyRegulationScreen());
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'theme',
                          child: ListTile(
                            leading: Icon(Icons.brightness_6),
                            title: Text('Toggle Theme'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'currency',
                          child: ListTile(
                            leading: Icon(Icons.currency_exchange),
                            title: Text('Currency Regulation'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    int crossAxisCount = screenWidth > 600 ? 2 : 1;
                    double childAspectRatio = screenWidth > 600 ? 1.2 : 1.6;

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: _calculatorOptions.length,
                      itemBuilder: (context, index) {
                        final option = _calculatorOptions[index];
                        return CalculatorCard(
                          icon: option.icon,
                          title: option.title,
                          description: option.description,
                          onTap: () => _navigateTo(option.screen),
                        );
                      },
                    );
                  },
                ),
              ),
              const AdaptiveBannerAd(),
            ],
          ),
        ),
      ),
    );
  }

  List<CalculatorOption> get _calculatorOptions => [
        CalculatorOption(
          icon: Icons.calculate_rounded,
          title: 'Basic Calc',
          description: 'Simple operations for daily tasks.',
          screen: const BasicCalcScreen(),
        ),
        CalculatorOption(
          icon: Icons.science_rounded,
          title: 'Scientific',
          description: 'Complex math and engineering.',
          screen: const ScientificCalculatorScreen(),
        ),
        CalculatorOption(
          icon: Icons.account_balance_rounded,
          title: 'Financial',
          description: 'Loans, investment, and interest.',
          screen: const FinancialCalculatorScreen(),
        ),

        CalculatorOption(
          icon: Icons.monitor_weight_rounded,
          title: 'BMI Calc',
          description: 'Calculate your body mass index.',
          screen: const BmiCalculatorScreen(),
        ),
        CalculatorOption(
          icon: Icons.favorite_rounded,
          title: 'Health',
          description: 'BMR, calories, and fitness.',
          screen: const HealthCalcScreen(),
        ),
        CalculatorOption(
          icon: Icons.calendar_today_rounded,
          title: 'Age Calc',
          description: 'Precise age tracking.',
          screen: const AgeCalculatorScreen(),
        ),
        CalculatorOption(
          icon: Icons.discount_rounded,
          title: 'Discount',
          description: 'Swift price reductions.',
          screen: const DiscountCalculatorScreen(),
        ),
        CalculatorOption(
          icon: Icons.tag_rounded,
          title: 'Statistical',
          description: 'Data analysis and regression.',
          screen: const StatisticalCalculatorScreen(),
        ),
        CalculatorOption(
          icon: Icons.straighten_rounded,
          title: 'Unit Converter',
          description: 'Convert any measurement unit.',
          screen: const UnitConverterScreen(),
        ),
        CalculatorOption(
          icon: Icons.show_chart_rounded,
          title: 'Graphic',
          description: 'Visualize functions and equations.',
          screen: const GraphicCalculatorScreen(),
        ),
        CalculatorOption(
          icon: Icons.business_center_rounded,
          title: 'Business',
          description: 'Profitability and break-even.',
          screen: const BusinessCalculatorScreen(),
        ),
        CalculatorOption(
          icon: Icons.trending_up_rounded,
          title: 'Compound',
          description: 'Interest growth over time.',
          screen: const CompoundInterestCalculatorScreen(),
        ),
        CalculatorOption(
          icon: Icons.change_history_rounded,
          title: 'Triangle Calc',
          description: 'Right-angle triangle solver.',
          screen: const TriangleCalculatorScreen(),
        ),
        CalculatorOption(
          icon: Icons.category_rounded,
          title: 'Geometry Calc',
          description: 'Cube, Triangle, Circle properties.',
          screen: const GeometryCalculatorScreen(),
        ),
      ];
}

class CalculatorOption {
  final IconData icon;
  final String title;
  final String description;
  final Widget screen;

  CalculatorOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.screen,
  });
}

class CalculatorCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const CalculatorCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: isDark ? Colors.blue[300] : Colors.blue[600],
                  size: 28,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.black54,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
