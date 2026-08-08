import 'package:flutter/material.dart';
import '../../models/vendor_store_config.dart';

class VendorProductsTab extends StatefulWidget {
  final String categoryId;

  const VendorProductsTab({
    super.key,
    required this.categoryId,
  });

  @override
  State<VendorProductsTab> createState() => _VendorProductsTabState();
}

class _VendorProductsTabState extends State<VendorProductsTab> {
  final TextEditingController _searchCtrl = TextEditingController();
  late VendorStoreConfig _storeConfig;
  late List<Map<String, dynamic>> _myProducts;

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
    _myProducts = _storeConfig.getInitialSampleProducts();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProducts {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _myProducts;
    return _myProducts.where((p) {
      final title = p['title'].toString().toLowerCase();
      final cat = p['category'].toString().toLowerCase();
      return title.contains(q) || cat.contains(q);
    }).toList();
  }

  void _showAddProductModal() {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final oldPriceCtrl = TextEditingController();
    final extra1Ctrl = TextEditingController();
    final extra2Ctrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.add_business_rounded,
                          color: darkForestGreen, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        _storeConfig.addProductTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildModalTextField(
                    controller: titleCtrl,
                    label: _storeConfig.fieldLabelTitle,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalTextField(
                          controller: priceCtrl,
                          label: 'السعر (ج.م)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildModalTextField(
                          controller: oldPriceCtrl,
                          label: 'السعر قبل الخصم (اختياري)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildModalTextField(
                    controller: extra1Ctrl,
                    label: _storeConfig.extraField1Label,
                  ),
                  const SizedBox(height: 12),
                  _buildModalTextField(
                    controller: extra2Ctrl,
                    label: _storeConfig.extraField2Label,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkForestGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        final t = titleCtrl.text.trim();
                        final p = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
                        if (t.isNotEmpty && p > 0) {
                          final badgeText = extra1Ctrl.text.trim().isNotEmpty
                              ? extra1Ctrl.text.trim()
                              : 'متوفر بالفرع 🟢';

                          setState(() {
                            _myProducts.insert(0, {
                              'id': 'p_${DateTime.now().millisecondsSinceEpoch}',
                              'title': t,
                              'price': p,
                              'oldPrice': double.tryParse(oldPriceCtrl.text.trim()),
                              'category': 'جديد',
                              'badge': badgeText,
                              'isAvailable': true,
                              'imagePath': 'assets/images/food_koshary.png',
                            });
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم إضافة ($t) لمعروضات متجرك بنجاح! 🎉'),
                              backgroundColor: darkForestGreen,
                            ),
                          );
                        }
                      },
                      child: Text(
                        'حفظ وإضافة إلى ${_storeConfig.productTerm} 🚀',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: vibrantLimeGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: textDark, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: textSubtle),
        filled: true,
        fillColor: lightBgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75),
        child: FloatingActionButton.extended(
          onPressed: _showAddProductModal,
          backgroundColor: darkForestGreen,
          icon: const Icon(Icons.add_rounded, color: vibrantLimeGreen),
          label: const Text(
            'إضافة صنف جديد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PILL SEARCH BAR MATCHING DASHBOARD
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: textDark, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'ابحث في قائمة ${_storeConfig.productTerm}...',
                  hintStyle: const TextStyle(color: textSubtle, fontSize: 12),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: darkForestGreen, size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. PRODUCTS LIST HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'قائمة ${_storeConfig.productTerm} (${_filteredProducts.length}):',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const Text(
                  'تغيير التوفر بنقرة واحدة',
                  style: TextStyle(fontSize: 10, color: textSubtle),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredProducts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final prod = _filteredProducts[index];
                final bool isAvail = prod['isAvailable'] ?? true;
                final badgeText = prod['badge'];

                return Container(
                  padding: const EdgeInsets.all(12),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          prod['imagePath'],
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 64,
                            height: 64,
                            color: lightBgColor,
                            child: const Icon(Icons.inventory_2_outlined,
                                color: darkForestGreen),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prod['title'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            if (badgeText != null) ...[
                              const SizedBox(height: 3),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: darkForestGreen.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  badgeText,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: darkForestGreen,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${prod['price']} ج.م',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: darkForestGreen,
                                  ),
                                ),
                                if (prod['oldPrice'] != null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '${prod['oldPrice']} ج.م',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: textSubtle,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            isAvail ? 'متوفر 🟢' : 'غير متوفر 🔴',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isAvail
                                  ? darkForestGreen
                                  : Colors.redAccent,
                            ),
                          ),
                          Switch.adaptive(
                            value: isAvail,
                            activeTrackColor: vibrantLimeGreen,
                            activeThumbColor: darkForestGreen,
                            onChanged: (val) {
                              setState(() {
                                prod['isAvailable'] = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
