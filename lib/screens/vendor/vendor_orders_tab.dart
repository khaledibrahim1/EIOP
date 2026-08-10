import 'package:flutter/material.dart';
import '../../models/vendor_store_config.dart';
import '../location_picker_screen.dart';

class VendorOrdersTab extends StatefulWidget {
  final String categoryId;
  final String searchQuery;

  const VendorOrdersTab({
    super.key,
    required this.categoryId,
    this.searchQuery = '',
  });

  @override
  State<VendorOrdersTab> createState() => _VendorOrdersTabState();
}

class _VendorOrdersTabState extends State<VendorOrdersTab> {
  String _selectedFilter = 'الكل';
  late VendorStoreConfig _storeConfig;
  late List<Map<String, dynamic>> _allOrders;

  static const darkForestGreen = Color(0xFF0D2B1D);
  static const vibrantLimeGreen = Color(0xFFA3E635);
  static const lightBgColor = Color(0xFFF6F8F5);
  static const cardWhite = Colors.white;
  static const textDark = Color(0xFF0F172A);
  static const textSubtle = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _storeConfig = VendorStoreConfig.fromCategoryId(widget.categoryId);
    _allOrders = _storeConfig.getInitialSampleOrders();
  }

  List<Map<String, dynamic>> get _filteredOrders {
    return _allOrders.where((order) {
      if (_selectedFilter != 'الكل' && order['status'] != _selectedFilter) {
        return false;
      }
      final query = widget.searchQuery.trim().toLowerCase();
      if (query.isNotEmpty) {
        final id = (order['id'] ?? '').toString().toLowerCase();
        final name = (order['customerName'] ?? '').toString().toLowerCase();
        final phone = (order['phone'] ?? '').toString().toLowerCase();
        final items = (order['items'] ?? '').toString().toLowerCase();
        return id.contains(query) ||
            name.contains(query) ||
            phone.contains(query) ||
            items.contains(query);
      }
      return true;
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'الجديدة':
      case 'معاينات جديدة':
        return darkForestGreen;
      case 'قيد التحضير':
      case 'موعد محدد':
        return const Color(0xFFF59E0B);
      case 'جاهزة للتسليم':
        return const Color(0xFF6366F1);
      case 'المكتملة':
      case 'معاينات مكتملة':
        return const Color(0xFF10B981);
      default:
        return textSubtle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isRealEstate = _storeConfig.categoryId == 'real_estate' ||
        _storeConfig.categoryId == 'realEstate' ||
        widget.categoryId == 'real_estate' ||
        widget.categoryId == 'realEstate';

    final List<String> filterTabs = isRealEstate
        ? ['الكل', 'معاينات جديدة', 'موعد محدد', 'معاينات مكتملة']
        : ['الكل', 'الجديدة', 'قيد التحضير', 'جاهزة للتسليم', 'المكتملة'];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2. FILTER CHOICE CHIPS
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: filterTabs.map((tab) {
                final isSelected = _selectedFilter == tab;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(tab),
                    selected: isSelected,
                    selectedColor: darkForestGreen,
                    backgroundColor: cardWhite,
                    side: BorderSide(
                      color: isSelected
                          ? darkForestGreen
                          : Colors.black.withValues(alpha: 0.08),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? vibrantLimeGreen : textDark,
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedFilter = tab);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // 3. ORDERS LIST
          if (_filteredOrders.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.receipt_long_outlined,
                        size: 48, color: textSubtle),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد طلبات في قسم ($_selectedFilter) حالياً',
                      style: const TextStyle(
                        fontSize: 13,
                        color: textSubtle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                final statusColor = _getStatusColor(order['status']);

                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardWhite,
                    borderRadius: BorderRadius.circular(22),
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: darkForestGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  order['id'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: vibrantLimeGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  order['status'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${order['total']} ج.م',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: darkForestGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.person_rounded,
                              size: 16, color: textSubtle),
                          const SizedBox(width: 6),
                          Text(
                            '${order['customerName']} • ${order['phone']}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              size: 16, color: textSubtle),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              order['address'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: textSubtle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: lightBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.black.withValues(alpha: 0.05)),
                        ),
                        child: Text(
                          isRealEstate
                              ? 'تفاصيل المعاينة والعقار: ${order['items']}'
                              : 'محتويات الطلب: ${order['items']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: textDark,
                            height: 1.4,
                          ),
                        ),
                      ),
                      if (isRealEstate) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4285F4).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF4285F4).withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4285F4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.map_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order['mapLocation'] != null
                                          ? 'موقع المعاينة على الخريطة 📍'
                                          : 'لوكيشن العقار عبر Google Maps 🌐',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      order['mapLocation'] ??
                                          'لم يتم إرسال موقع الخريطة الدقيق للمشتري بعد',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: textSubtle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () async {
                                  final selectedLoc =
                                      await Navigator.push<String>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LocationPickerScreen(
                                        currentLocation:
                                            order['address'] ?? 'جرجا',
                                      ),
                                    ),
                                  );
                                  if (selectedLoc != null &&
                                      selectedLoc.isNotEmpty) {
                                    setState(() {
                                      order['mapLocation'] = selectedLoc;
                                    });
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'تم إرسال لوكيشن المعاينة عبر Google Maps للمشتري: $selectedLoc 📍'),
                                          backgroundColor:
                                              const Color(0xFF4285F4),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                      );
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4285F4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.send_rounded,
                                          color: Colors.white, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        order['mapLocation'] != null
                                            ? 'تعديل/إعادة إرسال'
                                            : 'إرسال اللوكيشن',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),

                      // STORE SPECIFIC STATUS UPDATE BUTTONS
                      if (order['status'] == 'الجديدة' ||
                          order['status'] == 'معاينات جديدة')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkForestGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              setState(() => order['status'] =
                                  isRealEstate ? 'موعد محدد' : 'قيد التحضير');
                            },
                            icon: Icon(
                                isRealEstate
                                    ? Icons.event_available_rounded
                                    : Icons.check_circle_outline_rounded,
                                color: vibrantLimeGreen,
                                size: 18),
                            label: Text(
                              isRealEstate
                                  ? 'تأكيد وحجز موعد المعاينة 🏠'
                                  : _storeConfig.orderActionLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      else if (order['status'] == 'قيد التحضير' ||
                          order['status'] == 'موعد محدد')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isRealEstate
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF6366F1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              setState(() => order['status'] = isRealEstate
                                  ? 'معاينات مكتملة'
                                  : 'جاهزة للتسليم');
                            },
                            icon: Icon(
                                isRealEstate
                                    ? Icons.task_alt_rounded
                                    : Icons.takeout_dining_rounded,
                                color: Colors.white,
                                size: 18),
                            label: Text(
                              isRealEstate
                                  ? 'إتمام المعاينة بنجاح ✅'
                                  : 'جاهز للتسليم للمندوب',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      else if (order['status'] == 'جاهزة للتسليم')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              setState(() => order['status'] = 'المكتملة');
                            },
                            icon: const Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 18),
                            label: const Text(
                              'تأكيد استلام العميل للطلب',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }
}
