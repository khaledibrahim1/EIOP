import 'package:flutter/material.dart';
import '../../models/vendor_store_config.dart';

class VendorOverviewTab extends StatefulWidget {
  final String categoryId;
  final String storeName;
  final String categoryTitle;
  final VoidCallback onNavigateToProducts;
  final VoidCallback onNavigateToOrders;

  const VendorOverviewTab({
    super.key,
    required this.categoryId,
    required this.storeName,
    required this.categoryTitle,
    required this.onNavigateToProducts,
    required this.onNavigateToOrders,
  });

  @override
  State<VendorOverviewTab> createState() => _VendorOverviewTabState();
}

class _VendorOverviewTabState extends State<VendorOverviewTab> {
  bool _isStoreOpen = true;
  late VendorStoreConfig _storeConfig;
  late List<Map<String, dynamic>> _liveOrders;

  // Custom Colors matching the reference image
  static const darkForestGreen = Color(0xFF0D2B1D);
  static const vibrantLimeGreen = Color(0xFFA3E635);
  static const lightBgColor = Color(0xFFF6F8F5);
  static const cardWhite = Colors.white;
  static const accentOrange = Color(0xFFF97316);
  static const textDark = Color(0xFF0F172A);
  static const textSubtle = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _storeConfig = VendorStoreConfig.fromCategoryId(widget.categoryId);
    _liveOrders = _storeConfig.getInitialSampleOrders();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. STORE OPEN/CLOSED TOGGLE BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _isStoreOpen ? vibrantLimeGreen : Colors.redAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isStoreOpen ? vibrantLimeGreen : Colors.redAccent)
                                .withValues(alpha: 0.6),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isStoreOpen
                          ? 'استقبال الطلبات بجرجا مفتوح 🟢'
                          : 'المتجر مغلق حالياً 🔴',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: darkForestGreen,
                      ),
                    ),
                  ],
                ),
                Switch.adaptive(
                  value: _isStoreOpen,
                  activeThumbColor: darkForestGreen,
                  activeTrackColor: vibrantLimeGreen,
                  onChanged: (val) {
                    setState(() => _isStoreOpen = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isStoreOpen
                            ? 'تم فتح المتجر لاستقبال طلبات العملاء بجرجا 🚀'
                            : 'تم إغلاق المتجر مؤقتاً 🛑'),
                        backgroundColor: darkForestGreen,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. HERO UPDATE CARD (DARK FOREST GREEN CARD MATCHING IMAGE 1)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: darkForestGreen,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: darkForestGreen.withValues(alpha: 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.more_horiz_rounded,
                        color: Colors.white54, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Feb 12th 2024',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sales revenue increased 40%\nin 1 week',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: widget.onNavigateToOrders,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See Statistics',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded,
                          color: Colors.white70, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. NET INCOME & TOTAL RETURN CARDS ROW (MATCHING IMAGE 1)
          Row(
            children: [
              Expanded(
                child: _buildIncomeCard(
                  title: 'Net Income',
                  amount: '193.000 ج.م',
                  trend: '+35% from last month',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildIncomeCard(
                  title: 'Total Return',
                  amount: '32.000 ج.م',
                  trend: '-24% from last month',
                  isPositive: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 4. SALES REPORT HORIZONTAL BAR CHART CARD (MATCHING IMAGE 2)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardWhite,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sales Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: lightBgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 12, color: textSubtle),
                          SizedBox(width: 6),
                          Text(
                            'January 2024',
                            style: TextStyle(fontSize: 11, color: textDark),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              size: 14, color: textDark),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Horizontal Bar 1: Product Launched (233)
                _buildBarRow('Product Launched (233)', 0.65, vibrantLimeGreen),
                const SizedBox(height: 14),

                // Horizontal Bar 2: Ongoing Product (23)
                _buildBarRow('Ongoing Product (23)', 0.35, const Color(0xFFC0ED76)),
                const SizedBox(height: 14),

                // Horizontal Bar 3: Product Sold (482)
                _buildBarRow('Product Sold (482)', 0.88, darkForestGreen),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 5. TOTAL VIEW PERFORMANCE DONUT CHART (MATCHING IMAGE 3)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardWhite,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total View Performance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const Icon(Icons.more_horiz_rounded, color: textSubtle),
                  ],
                ),
                const SizedBox(height: 20),

                // DONUT RING VISUAL
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 170,
                      height: 170,
                      child: CircularProgressIndicator(
                        value: 0.68,
                        strokeWidth: 22,
                        backgroundColor: darkForestGreen.withValues(alpha: 0.15),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(vibrantLimeGreen),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Count',
                          style: TextStyle(fontSize: 11, color: textSubtle),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '565K',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Legend Pills Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendDot(vibrantLimeGreen, 'View Count'),
                    const SizedBox(width: 16),
                    _buildLegendDot(darkForestGreen, 'Percentage'),
                    const SizedBox(width: 16),
                    _buildLegendDot(accentOrange, 'Sales'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 6. TRANSACTIONS / RECENT ORDERS LIST (MATCHING IMAGE 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaction',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const Icon(Icons.more_horiz_rounded, color: textSubtle),
            ],
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _liveOrders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final order = _liveOrders[index];
              final bool isCompleted = order['status'] == 'المكتملة' || index == 0;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardWhite,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: lightBgColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        index % 2 == 0
                            ? Icons.checkroom_rounded
                            : Icons.videogame_asset_rounded,
                        color: darkForestGreen,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['customerName'] ?? 'Tinek Detstar T-Shirt',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Jul 12th 2024',
                            style: const TextStyle(
                              fontSize: 11,
                              color: textSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isCompleted ? 'Completed' : 'Pending',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? darkForestGreen
                                : accentOrange,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order['id'] ?? 'OJWEJS7ISNC',
                          style: const TextStyle(
                            fontSize: 10,
                            color: textSubtle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 90), // Spacing for floating bottom bar
        ],
      ),
    );
  }

  Widget _buildIncomeCard({
    required String title,
    required String amount,
    required String trend,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: textSubtle),
              ),
              const Icon(Icons.more_horiz_rounded, color: textSubtle, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: 14,
                color: isPositive ? darkForestGreen : Colors.redAccent,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  trend,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? darkForestGreen : Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarRow(String label, double ratio, Color barColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: textSubtle),
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 12,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: lightBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: constraints.maxWidth * ratio,
                  height: 12,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: textSubtle),
        ),
      ],
    );
  }
}
