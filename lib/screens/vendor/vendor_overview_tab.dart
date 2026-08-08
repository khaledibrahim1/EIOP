import 'package:flutter/material.dart';
import '../../models/vendor_store_config.dart';

class VendorOverviewTab extends StatefulWidget {
  final String categoryId;
  final String storeName;
  final String categoryTitle;
  final String searchQuery;
  final VoidCallback onNavigateToProducts;
  final VoidCallback onNavigateToOrders;

  const VendorOverviewTab({
    super.key,
    required this.categoryId,
    required this.storeName,
    required this.categoryTitle,
    this.searchQuery = '',
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

  List<Map<String, dynamic>> get _filteredLiveOrders {
    final q = widget.searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _liveOrders;
    return _liveOrders.where((order) {
      final name = (order['customerName'] ?? '').toString().toLowerCase();
      final id = (order['id'] ?? '').toString().toLowerCase();
      final status = (order['status'] ?? '').toString().toLowerCase();
      return name.contains(q) || id.contains(q) || status.contains(q);
    }).toList();
  }

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
                          ? 'استقبال الطلبات بجرجا مفتوح'
                          : 'المتجر مغلق حالياً',
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
                            ? 'تم فتح المتجر لاستقبال طلبات العملاء بجرجا'
                            : 'تم إغلاق المتجر مؤقتاً'),
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
                          'تحديث مباشر',
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
                  '12 فبراير 2024',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 10),
                const Text(
                  'ارتفعت أرباح مبيعاتك بنسبة 40%\nخلال أسبوع واحد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: widget.onNavigateToOrders,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'عرض التحليلات الكاملة',
                        style: TextStyle(
                          color: vibrantLimeGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded,
                          color: vibrantLimeGreen, size: 18),
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
                  title: 'صافي الأرباح',
                  amount: '193,000 ج.م',
                  trend: '+35% عن الشهر الماضي',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildIncomeCard(
                  title: 'المرتجعات والطلبات',
                  amount: '32,000 ج.م',
                  trend: '-24% عن الشهر الماضي',
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
                    const Expanded(
                      child: Text(
                        'تقرير المبيعات والمنتجات',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
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
                            'يناير 2024',
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

                // Horizontal Bar 1: المنتجات المعروضة (233)
                _buildBarRow('المنتجات المعروضة (233)', 0.65, vibrantLimeGreen),
                const SizedBox(height: 14),

                // Horizontal Bar 2: طلبات قيد الإعداد (23)
                _buildBarRow('طلبات قيد الإعداد (23)', 0.35, const Color(0xFFC0ED76)),
                const SizedBox(height: 14),

                // Horizontal Bar 3: المنتجات المباعة (482)
                _buildBarRow('المنتجات المباعة (482)', 0.88, darkForestGreen),
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'إحصائيات تصفح متجرك بجرجا',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                    ),
                    Icon(Icons.more_horiz_rounded, color: textSubtle),
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
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'إجمالي الزيارات',
                          style: TextStyle(fontSize: 11, color: textSubtle),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '565 ألف',
                          style: TextStyle(
                            fontSize: 22,
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
                    _buildLegendDot(vibrantLimeGreen, 'عدد الزيارات'),
                    const SizedBox(width: 16),
                    _buildLegendDot(darkForestGreen, 'التفاعل'),
                    const SizedBox(width: 16),
                    _buildLegendDot(accentOrange, 'المبيعات'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 6. TRANSACTIONS / RECENT ORDERS LIST (MATCHING IMAGE 1)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'أحدث العمليات والطلبات',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              Icon(Icons.more_horiz_rounded, color: textSubtle),
            ],
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredLiveOrders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final order = _filteredLiveOrders[index];
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
                            ? Icons.fastfood_rounded
                            : Icons.shopping_bag_rounded,
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
                            order['customerName'] ?? 'أحمد محمود',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '12 يوليو 2024',
                            style: TextStyle(
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
                          isCompleted ? 'مكتمل' : 'قيد الإعداد',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? darkForestGreen
                                : accentOrange,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order['id'] ?? '#ORD-8921',
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
