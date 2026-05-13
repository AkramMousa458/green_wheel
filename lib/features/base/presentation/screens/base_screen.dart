import 'package:flutter/material.dart';
import 'package:green_wheel/features/base/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:green_wheel/features/home/presentation/screens/home_screen.dart';
import 'package:green_wheel/features/alerts/presentation/screens/alerts_screen.dart';
import 'package:green_wheel/features/settings/presentation/screens/settings_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
  static const String routeName = '/base-screen';

  static void changeTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_BaseScreenState>();
    if (state != null && state._selectedIndex != index) {
      state._onItemTapped(index);
    }
  }

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Placeholder(),
    const AlertsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool get _isOnHomeTab => _selectedIndex == 0;

  void _goToHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isOnHomeTab,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _goToHome();
        }
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
