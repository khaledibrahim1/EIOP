import 'package:flutter/material.dart';
import '../../models/vendor_store_config.dart';

class VendorProductsTab extends StatefulWidget {
  final String categoryId;
  final String searchQuery;

  const VendorProductsTab({
    super.key,
    required this.categoryId,
    this.searchQuery = '',
  });

  @override
  State<VendorProductsTab> createState() => _VendorProductsTabState();
}

class _VendorProductsTabState extends State<VendorProductsTab> {
  late VendorStoreConfig _storeConfig;
  late List<Map<String, dynamic>> _myProducts;

  static const darkForestGreen = Color(0xFF0D2B1D);
  static const vibrantLimeGreen = Color(0xFFA3E635);
  static const lightBgColor = Color(0xFFF6F8F5);
  static const cardWhite = Colors.white;
  static const textDark = Color(0xFF0F172A);
  static const textSubtle = Color(0xFF64748B);

  // Available sample product images to choose from
  final List<String> _sampleImages = [
    'assets/images/food_koshary.png',
    'assets/images/food_pizza.png',
    'assets/images/food_burger.png',
    'assets/images/supermarket_milk.png',
    'assets/images/electronics_earbuds.png',
    'assets/images/fashion_shirt.png',
    'assets/images/pharmacy_panadol.png',
  ];

  @override
  void initState() {
    super.initState();
    _storeConfig = VendorStoreConfig.fromCategoryId(widget.categoryId);
    _myProducts = _storeConfig.getInitialSampleProducts();
  }

  List<Map<String, dynamic>> get _filteredProducts {
    final q = widget.searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _myProducts;
    return _myProducts.where((p) {
      final title = (p['title'] ?? '').toString().toLowerCase();
      final cat = (p['category'] ?? '').toString().toLowerCase();
      final badge = (p['badge'] ?? '').toString().toLowerCase();
      return title.contains(q) || cat.contains(q) || badge.contains(q);
    }).toList();
  }

  Widget _buildProductImageWidget(String path, {double size = 64}) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          color: lightBgColor,
          child: const Icon(Icons.fastfood_rounded, color: darkForestGreen),
        ),
      );
    }

    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: size,
        height: size,
        color: lightBgColor,
        child: const Icon(Icons.fastfood_rounded, color: darkForestGreen),
      ),
    );
  }

  void _showCustomImageDialog(
      BuildContext context, StateSetter setModalState, Function(String) onImageAdded) {
    final urlCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sheet Handle
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
                const SizedBox(height: 16),

                // Modal Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: darkForestGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cloud_upload_rounded,
                          color: darkForestGreen, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'رفع صورة الوجبة / المنتج (Upload)',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textDark),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'اختر صورة من معرض الصور أو جهازك المباشر',
                            style: TextStyle(fontSize: 11, color: textSubtle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 1. DIRECT UPLOAD DROPZONE CONTAINER
                GestureDetector(
                  onTap: () {
                    // Simulate picking file from device gallery/storage
                    final sampleUploaded = _sampleImages[
                        (DateTime.now().millisecondsSinceEpoch) %
                            _sampleImages.length];
                    onImageAdded(sampleUploaded);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم رفع واختيار صورة الوجبة بنجاح! ☁️📸'),
                        backgroundColor: darkForestGreen,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: lightBgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: darkForestGreen.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: darkForestGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_photo_alternate_rounded,
                              color: vibrantLimeGreen, size: 32),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'انقر هنا لاختيار ورفع صورة من جهازك',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: darkForestGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'يدعم ملفات الصور JPG, PNG, WEBP حتى 5 ميجابايت',
                          style: TextStyle(fontSize: 10, color: textSubtle),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // OR DIVIDER
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.black12)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('أو أدخل رابط / مسار الملف',
                          style: TextStyle(fontSize: 11, color: textSubtle)),
                    ),
                    Expanded(child: Divider(color: Colors.black12)),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. URL OR LOCAL FILE PATH TEXTFIELD
                TextField(
                  controller: urlCtrl,
                  style: const TextStyle(fontSize: 13, color: textDark),
                  decoration: InputDecoration(
                    hintText: 'مثلاً: https://example.com/meal.png أو C:\\path\\image.jpg',
                    hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                    filled: true,
                    fillColor: lightBgColor,
                    prefixIcon: const Icon(Icons.link_rounded,
                        color: darkForestGreen, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          BorderSide(color: Colors.black.withValues(alpha: 0.1)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),

                // ACTION BUTTONS
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkForestGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      final url = urlCtrl.text.trim();
                      if (url.isNotEmpty) {
                        onImageAdded(url);
                        Navigator.pop(ctx);
                      } else {
                        // Fallback upload simulation if field empty
                        final sampleUploaded = _sampleImages[
                            (DateTime.now().millisecondsSinceEpoch) %
                                _sampleImages.length];
                        onImageAdded(sampleUploaded);
                        Navigator.pop(ctx);
                      }
                    },
                    icon: const Icon(Icons.check_circle_rounded,
                        color: vibrantLimeGreen, size: 20),
                    label: const Text(
                      'تأكيد واستخدام الصورة المرفوعة',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddProductModal() {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final oldPriceCtrl = TextEditingController();
    final extra1Ctrl = TextEditingController();
    final extra2Ctrl = TextEditingController();
    final optionInputCtrl = TextEditingController();

    String selectedImg = _sampleImages.first;
    bool hasDiscount = false;
    List<String> optionsList = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sheet handle bar
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

                    // Sheet Header
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

                    // 1. SELECT OR UPLOAD PRODUCT IMAGE SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'اختر صورة الصنف / الوجبة:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showCustomImageDialog(context, setModalState, (customPath) {
                              setModalState(() {
                                if (!_sampleImages.contains(customPath)) {
                                  _sampleImages.insert(0, customPath);
                                }
                                selectedImg = customPath;
                              });
                            });
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.add_a_photo_rounded,
                                  color: darkForestGreen, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'إضافة صورة جديدة',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: darkForestGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _sampleImages.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          // First tile is "Upload / Add New Photo" button
                          if (index == 0) {
                            return GestureDetector(
                              onTap: () {
                                _showCustomImageDialog(context, setModalState, (customPath) {
                                  setModalState(() {
                                    if (!_sampleImages.contains(customPath)) {
                                      _sampleImages.insert(0, customPath);
                                    }
                                    selectedImg = customPath;
                                  });
                                });
                              },
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: lightBgColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: darkForestGreen.withValues(alpha: 0.3),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate_rounded,
                                        color: darkForestGreen, size: 22),
                                    SizedBox(height: 2),
                                    Text(
                                      'صورة جديدة',
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: darkForestGreen),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final imgPath = _sampleImages[index - 1];
                          final isSelected = selectedImg == imgPath;

                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedImg = imgPath;
                              });
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected
                                          ? darkForestGreen
                                          : Colors.grey.withValues(alpha: 0.3),
                                      width: isSelected ? 2.5 : 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: _buildProductImageWidget(imgPath, size: 64),
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: darkForestGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        color: vibrantLimeGreen,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. PRODUCT NAME INPUT
                    _buildModalTextField(
                      controller: titleCtrl,
                      label: _storeConfig.fieldLabelTitle,
                    ),
                    const SizedBox(height: 14),

                    // 3. DISCOUNT TOGGLE SWITCH (تطبيق خصم أم لا)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: lightBgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.black.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.local_offer_outlined,
                                    color: darkForestGreen, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'تفعيل خصم على هذه الوجبة / السلعة؟',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: textDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: hasDiscount,
                            activeTrackColor: vibrantLimeGreen,
                            activeThumbColor: darkForestGreen,
                            onChanged: (val) {
                              setModalState(() {
                                hasDiscount = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // PRICE INPUTS (مع الخصم أو بدون خصم)
                    if (hasDiscount)
                      Row(
                        children: [
                          Expanded(
                            child: _buildModalTextField(
                              controller: priceCtrl,
                              label: 'السعر بعد الخصم (ج.م)',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildModalTextField(
                              controller: oldPriceCtrl,
                              label: 'السعر الأصلي قبل الخصم',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      )
                    else
                      _buildModalTextField(
                        controller: priceCtrl,
                        label: 'السعر (ج.م)',
                        keyboardType: TextInputType.number,
                      ),

                    const SizedBox(height: 14),

                    // 4. DYNAMIC CUSTOMER OPTIONS BUILDER (إضافة خيارات للمستخدم)
                    const Text(
                      'إضافة خيارات وإضافات للمستخدم (اختياري):',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _buildModalTextField(
                            controller: optionInputCtrl,
                            label: 'مثلاً: حجم دبل (+15 ج.م) أو بدون بصل',
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkForestGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                          onPressed: () {
                            final optText = optionInputCtrl.text.trim();
                            if (optText.isNotEmpty) {
                              setModalState(() {
                                optionsList.add(optText);
                                optionInputCtrl.clear();
                              });
                            }
                          },
                          child: const Text(
                            'إضافة',
                            style: TextStyle(
                              color: vibrantLimeGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (optionsList.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: optionsList.map((opt) {
                          return Chip(
                            backgroundColor: lightBgColor,
                            side: BorderSide(
                                color: Colors.black.withValues(alpha: 0.1)),
                            label: Text(
                              opt,
                              style: const TextStyle(
                                  fontSize: 11, color: textDark),
                            ),
                            deleteIcon: const Icon(Icons.cancel_rounded,
                                size: 16, color: Colors.grey),
                            onDeleted: () {
                              setModalState(() {
                                optionsList.remove(opt);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 14),

                    // 5. STORE SPECIFIC EXTRA FIELDS
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

                    // 6. SAVE BUTTON
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
                          final p =
                              double.tryParse(priceCtrl.text.trim()) ?? 0.0;
                          final double? oldP = hasDiscount
                              ? double.tryParse(oldPriceCtrl.text.trim())
                              : null;

                          if (t.isNotEmpty && p > 0) {
                            final badgeText = extra1Ctrl.text.trim().isNotEmpty
                                ? extra1Ctrl.text.trim()
                                : 'متوفر بالفرع';

                            setState(() {
                              _myProducts.insert(0, {
                                'id':
                                    'p_${DateTime.now().millisecondsSinceEpoch}',
                                'title': t,
                                'price': p,
                                'oldPrice': oldP,
                                'category': 'جديد',
                                'badge': badgeText,
                                'options': List<String>.from(optionsList),
                                'isAvailable': true,
                                'imagePath': selectedImg,
                              });
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('تم إضافة ($t) لمعروضات متجرك بنجاح!'),
                                backgroundColor: darkForestGreen,
                              ),
                            );
                          }
                        },
                        child: Text(
                          'حفظ وإضافة إلى ${_storeConfig.productTerm}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: vibrantLimeGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
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
                final List<dynamic>? options = prod['options'];

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
                        child: _buildProductImageWidget(prod['imagePath'], size: 64),
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
                            if (options != null && options.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'الخيارات: ${options.join(" • ")}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: textSubtle,
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
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'خصم ${(((prod['oldPrice'] - prod['price']) / prod['oldPrice']) * 100).round()}%',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
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
                            isAvail ? 'متوفر' : 'غير متوفر',
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
