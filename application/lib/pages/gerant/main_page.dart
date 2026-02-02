import 'package:application/pages/cloture_page.dart';
import 'package:application/pages/gerant/home_page.dart';
import 'package:application/pages/parametres_page.dart';
import 'package:application/pages/stock_page.dart';
import 'package:application/services/service.dart';
import 'package:flutter/material.dart';

class MainPageGerant extends StatefulWidget {
  const MainPageGerant({super.key});

  @override
  State<MainPageGerant> createState() => _MainPageState();
}

class _MainPageState extends State<MainPageGerant> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPageGerant(),
    const StockPage(),
    const CloturePage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    await ApiService.loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.local_shipping_outlined,
                  selectedIcon: Icons.local_shipping,
                  label: 'Stock',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.receipt_long_outlined,
                  selectedIcon: Icons.receipt_long,
                  label: 'Cloture',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.person,
                  label: 'Paramètres',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? Colors.blue : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
        ],
      ),
    );
  }
}
