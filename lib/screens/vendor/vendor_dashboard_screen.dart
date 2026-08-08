import 'package:flutter/material.dart';
import '../login_screen.dart';
import 'vendor_orders_tab.dart';
import 'vendor_overview_tab.dart';
import 'vendor_products_tab.dart';
import 'vendor_settings_tab.dart';

class VendorDashboardScreen extends StatefulWidget {
  final StoreCategoryType? category;

  const VendorDashboardScreen({
    super.key,
    this.category,
  });

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int _currentTabIndex = 0;
  final TextEditingController _topSearchCtrl = TextEditingController();

  static const darkForestGreen = Color(0xFF0D2B1D);
  static const vibrantLimeGreen = Color(0xFFA3E635);
  static const lightBgColor = Color(0xFFF6F8F5);
  static const textDark = Color(0xFF0F172A);
  static const textSubtle = Color(0xFF64748B);

  @override
  void dispose() {
    _topSearchCtrl.dispose();
    super.dispose();
  }

  String get _ownerName {
    if (widget.category != null && widget.category!.isVendor) {
      return 'متجر ${widget.category!.title}';
    }
    return 'متجر البرنس بجرجا';
  }

  void _onTabSelect(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. TOP HEADER SECTION MATCHING REFERENCE IMAGE 1
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'مرحباً بك',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textDark,
                                ),
                              ),
                              Text(
                                _ownerName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: textDark,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'إدارة ومتابعة مبيعات متجرك بجرجا بكل دقة.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textSubtle,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Avatar circle
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE2E8F0),
                                  shape: BoxShape.circle,
                                ),
                                child: const ClipOval(
                                  child: Icon(Icons.storefront_rounded,
                                      color: darkForestGreen, size: 22),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Grid Menu Pill Button
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: Colors.black.withValues(alpha: 0.08)),
                                ),
                                child: const Icon(
                                  Icons.grid_view_rounded,
                                  color: textDark,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // PILL SEARCH BAR MATCHING IMAGE 1
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Colors.black.withValues(alpha: 0.08)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _topSearchCtrl,
                          style:
                              const TextStyle(color: textDark, fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'ابحث عن أي شيء في متجرك بجرجا...',
                            hintStyle:
                                TextStyle(color: textSubtle, fontSize: 12),
                            suffixIcon: Icon(Icons.search_rounded,
                                color: textDark, size: 20),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. MAIN DASHBOARD CONTENT AREA
                Expanded(
                  child: IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      VendorOverviewTab(
                        categoryId: widget.category?.id ?? 'restaurant',
                        storeName: _ownerName,
                        categoryTitle: widget.category?.title ?? 'مطاعم',
                        onNavigateToProducts: () => _onTabSelect(2),
                        onNavigateToOrders: () => _onTabSelect(1),
                      ),
                      VendorOrdersTab(
                        categoryId: widget.category?.id ?? 'restaurant',
                      ),
                      VendorProductsTab(
                        categoryId: widget.category?.id ?? 'restaurant',
                      ),
                      VendorSettingsTab(
                        storeName: _ownerName,
                        categoryTitle: widget.category?.title ?? 'مطاعم',
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 3. FLOATING DARK FOREST GREEN BOTTOM NAVBAR MATCHING IMAGE 1, 2, 3
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: darkForestGreen,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: darkForestGreen.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFloatingNavItem(0, Icons.home_rounded, Icons.home_outlined),
                    _buildFloatingNavItem(
                        1, Icons.receipt_long_rounded, Icons.receipt_long_outlined),
                    _buildFloatingNavItem(
                        2, Icons.inventory_2_rounded, Icons.inventory_2_outlined),
                    _buildFloatingNavItem(
                        3, Icons.person_rounded, Icons.person_outline_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavItem(
      int index, IconData activeIcon, IconData inactiveIcon) {
    final isSelected = _currentTabIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelect(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
            : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? vibrantLimeGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          isSelected ? activeIcon : inactiveIcon,
          size: 22,
          color: isSelected ? darkForestGreen : Colors.white70,
        ),
      ),
    );
  }
}
