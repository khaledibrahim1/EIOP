import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/vendor_store_config.dart';
import '../../widgets/promo_banner.dart';

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

  final List<PromoOfferData> _myOffers = [];

  static const List<String> realEstatePropertyTypes = [
    'عمارة',
    'شقة',
    'أرض',
    'محل',
    'فيلا',
    'قصر',
    'دوار',
    'شاليه',
    'مشروع',
  ];

  static const List<String> realEstateContractTypes = [
    'تمليك',
    'إيجار',
    'تقسيط',
  ];

  static const List<String> realEstateInstallmentTypes = [
    'شهري',
    'سنوي',
  ];

  static const darkForestGreen = Color(0xFF0D2B1D);
  static const vibrantLimeGreen = Color(0xFFA3E635);
  static const lightBgColor = Color(0xFFF6F8F5);
  static const cardWhite = Colors.white;
  static const textDark = Color(0xFF0F172A);
  static const textSubtle = Color(0xFF64748B);
  static const accentOrange = Color(0xFFF97316);

  // Available sample product images in device gallery
  final List<String> _deviceGalleryImages = [
    'assets/images/food_koshary.png',
    'assets/images/food_pizza.png',
    'assets/images/food_burger.png',
    'assets/images/supermarket_milk.png',
    'assets/images/electronics_earbuds.png',
    'assets/images/fashion_shirt.png',
    'assets/images/pharmacy_panadol.png',
  ];

  List<String> get sampleImages => _deviceGalleryImages;

  @override
  void initState() {
    super.initState();
    _storeConfig = VendorStoreConfig.fromCategoryId(widget.categoryId);
    _myProducts = _storeConfig.getInitialSampleProducts();
    _initCategoryOffers();
  }

  void _initCategoryOffers() {
    _myOffers.clear();
    switch (widget.categoryId) {
      case 'real_estate':
      case 'realEstate':
        _myOffers.add(
          const PromoOfferData(
            badgeText: 'عرض خاص 🏗️',
            title: 'خصم 25% على رسوم معاينة الأراضي بجرجا',
            subtitleText: 'خصم يصل إلى',
            discountNum: '25',
            footerNote: 'على جميع الأراضي والعقارات | كود: LAND25',
            buttonText: 'احجز المعاينة',
            bgImagePath: 'assets/images/cat_realestate.png',
          ),
        );
        break;
      case 'pharmacy':
        _myOffers.add(
          const PromoOfferData(
            badgeText: 'عرض الصيدلية 💊',
            title: 'خصم 20% على المستلزمات الطبية والفيتامينات',
            subtitleText: 'خصم يصل إلى',
            discountNum: '20',
            footerNote: 'على المستحضرات والفيتامينات | كود: PHARM20',
            buttonText: 'اطلب الآن',
            bgImagePath: 'assets/images/pharmacy_panadol.png',
          ),
        );
        break;
      case 'supermarket':
        _myOffers.add(
          const PromoOfferData(
            badgeText: 'عروض السوبرماركت 🛒',
            title: 'خصم 15% على كرتونة جهينة والأرز الفاخر',
            subtitleText: 'خصم يصل إلى',
            discountNum: '15',
            footerNote: 'على جميع السلع الأساسية | كود: MARKET15',
            buttonText: 'اطلب السلع',
            bgImagePath: 'assets/images/supermarket_milk.png',
          ),
        );
        break;
      default:
        _myOffers.add(
          const PromoOfferData(
            badgeText: 'عرض خاص 🔥',
            title: 'خصم 30% على الوجبات العائلية والميكس',
            subtitleText: 'خصم يصل إلى',
            discountNum: '30',
            footerNote: 'على جميع الأطباق | كود: EIOP30',
            buttonText: 'احصل عليه',
            bgImagePath: 'assets/images/hadramout_cover.png',
          ),
        );
        break;
    }
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: lightBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: darkForestGreen),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // Opens Native OS File Dialog Explorer (Windows OpenFileDialog)
  Future<List<String>> _pickImageFromSystem() async {
    try {
      final result = await Process.run('powershell', [
        '-command',
        'Add-Type -AssemblyName System.Windows.Forms; \$f = New-Object System.Windows.Forms.OpenFileDialog; \$f.Filter = "Image Files (*.png;*.jpg;*.jpeg;*.webp)|*.png;*.jpg;*.jpeg;*.webp"; \$f.Multiselect = \$true; if(\$f.ShowDialog() -eq "OK"){ \$f.FileNames -join ";" }'
      ]);
      if (result.exitCode == 0) {
        final output = result.stdout.toString().trim();
        if (output.isNotEmpty) {
          return output.split(';').where((s) => s.trim().isNotEmpty).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  // REAL-TIME LIVE PROMO OFFER CREATOR MODAL
  void _showAddPromoOfferModal(BuildContext context) {
    final titleCtrl = TextEditingController(text: 'خصم خاص على جميع الأطباق');
    final discountCtrl = TextEditingController(text: '25');
    final badgeCtrl = TextEditingController(text: 'عرض جديد 🔥');
    final footerCtrl = TextEditingController(text: 'كود: MEAL25 | لفترة محدودة');
    String imagePath = 'assets/images/hadramout_cover.png';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setOfferState) {
            titleCtrl.addListener(() => setOfferState(() {}));
            discountCtrl.addListener(() => setOfferState(() {}));
            badgeCtrl.addListener(() => setOfferState(() {}));
            footerCtrl.addListener(() => setOfferState(() {}));

            return Container(
              height: MediaQuery.of(ctx).size.height * 0.85,
              padding: EdgeInsets.only(
                top: 16,
                left: 18,
                right: 18,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 18,
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
                    // Handle
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
                    const SizedBox(height: 12),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.local_offer_rounded,
                                color: accentOrange, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'إنشاء ونشر عرض ترويجي جديد',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: textSubtle),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 1. REAL-TIME LIVE CAROUSEL BANNER PREVIEW CARD
                    const Text(
                      'معاينة العرض التفاعلية المباشرة (Real-time Live Preview):',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: darkForestGreen,
                      ),
                    ),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: () async {
                        final picked = await _pickImageFromSystem();
                        if (picked.isNotEmpty) {
                          setOfferState(() {
                            imagePath = picked.first;
                          });
                        }
                      },
                      child: Container(
                        height: 155,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: File(imagePath).existsSync()
                                    ? Image.file(File(imagePath),
                                        fit: BoxFit.cover)
                                    : Image.asset(imagePath, fit: BoxFit.cover),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withValues(alpha: 0.85),
                                        Colors.black.withValues(alpha: 0.55),
                                        Colors.black.withValues(alpha: 0.15),
                                      ],
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          badgeCtrl.text.isNotEmpty
                                              ? badgeCtrl.text
                                              : 'عرض خاص 🔥',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          titleCtrl.text.isNotEmpty
                                              ? titleCtrl.text
                                              : 'عنوان العرض المباشر...',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Text(
                                              'خصم يصل إلى ',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 11,
                                              ),
                                            ),
                                            Text(
                                              discountCtrl.text.isNotEmpty
                                                  ? discountCtrl.text
                                                  : '20',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: const BoxDecoration(
                                                color: accentOrange,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Text(
                                                '%',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          footerCtrl.text.isNotEmpty
                                              ? footerCtrl.text
                                              : 'شروط العرض',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 9,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: darkForestGreen,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.photo_camera_rounded,
                                                  color: vibrantLimeGreen,
                                                  size: 12),
                                              SizedBox(width: 4),
                                              Text(
                                                'تغيير الصورة',
                                                style: TextStyle(
                                                  color: vibrantLimeGreen,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // FORM INPUT FIELDS
                    _buildModalTextField(
                      controller: titleCtrl,
                      label: 'عنوان العرض الترويجي',
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _buildModalTextField(
                            controller: discountCtrl,
                            label: 'نسبة الخصم %',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildModalTextField(
                            controller: badgeCtrl,
                            label: 'شارة العرض (مثلاً: عرض خاص 🔥)',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    _buildModalTextField(
                      controller: footerCtrl,
                      label: 'شروط العرض وكود الخصم',
                    ),
                    const SizedBox(height: 16),

                    // PUBLISH BUTTON
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
                          final title = titleCtrl.text.trim();
                          final disc = discountCtrl.text.trim();
                          if (title.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يرجى إدخال عنوان العرض أولاً!'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          final newOffer = PromoOfferData(
                            badgeText: badgeCtrl.text.trim().isNotEmpty
                                ? badgeCtrl.text.trim()
                                : 'عرض جديد 🔥',
                            title: title,
                            subtitleText: 'خصم يصل إلى',
                            discountNum: disc.isNotEmpty ? disc : '20',
                            footerNote: footerCtrl.text.trim().isNotEmpty
                                ? footerCtrl.text.trim()
                                : 'على جميع الطلبات',
                            buttonText: 'احصل عليه',
                            bgImagePath: imagePath,
                          );

                          setState(() {
                            _myOffers.insert(0, newOffer);
                          });
                          PromoOfferStore.addOffer(newOffer);

                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'تم نشر العرض الترويجي ($title) وإدراجه بصفحة الوجبات بنجاح! 🎁🚀'),
                              backgroundColor: darkForestGreen,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        icon: const Icon(Icons.rocket_launch_rounded,
                            color: vibrantLimeGreen, size: 20),
                        label: const Text(
                          'نشر العرض للمستخدمين 🚀',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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

  // CONFIRM DELETE PRODUCT DIALOG
  void _confirmDeleteProduct(Map<String, dynamic> prod) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
              SizedBox(width: 8),
              Text(
                'تأكيد حذف الوجبة',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: textDark),
              ),
            ],
          ),
          content: Text(
            'هل أنت تأكد من رغبتك في حذف "${prod['title']}" نهائياً من متجرك؟',
            style: const TextStyle(fontSize: 13, color: textDark),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء', style: TextStyle(color: textSubtle)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  _myProducts.removeWhere((p) => p['id'] == prod['id']);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حذف وجبة (${prod['title']}) نهائياً! 🗑️'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              child: const Text(
                'حذف نهائي',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
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

    if (File(path).existsSync()) {
      return Image.file(
        File(path),
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

  // INTERACTIVE PRODUCT DETAILS MODAL SHEET
  void _showProductDetailsModal(Map<String, dynamic> prod) {
    final String title = prod['title'] ?? 'منتج بدون عنوان';
    final double price = (prod['price'] ?? 0.0).toDouble();
    final double? oldPrice =
        prod['oldPrice'] != null ? (prod['oldPrice'] as num).toDouble() : null;
    final bool isAvail = prod['isAvailable'] ?? true;
    final String? badgeText = prod['badge'];
    final List<dynamic>? options = prod['options'];
    final List<dynamic>? images = prod['images'];
    final List<String> allPhotos = images != null && images.isNotEmpty
        ? List<String>.from(images)
        : [prod['imagePath'] ?? _deviceGalleryImages.first];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDetailsState) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.82,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
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

                    // Header Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color: darkForestGreen, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'تفاصيل الوجبة / المنتج',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.close_rounded, color: textSubtle),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // MULTI-PHOTO GALLERY CAROUSEL
                    SizedBox(
                      height: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: allPhotos.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(ctx).size.width * 0.75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color:
                                        darkForestGreen.withValues(alpha: 0.15)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: _buildProductImageWidget(
                                    allPhotos[index],
                                    size: double.infinity),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // TITLE & BADGES
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ),
                        if (badgeText != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: darkForestGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              badgeText,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: darkForestGreen,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // PRICE & DISCOUNT BREAKDOWN
                    Row(
                      children: [
                        Text(
                          '$price ج.م',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: darkForestGreen,
                          ),
                        ),
                        if (oldPrice != null && oldPrice > price) ...[
                          const SizedBox(width: 10),
                          Text(
                            '$oldPrice ج.م',
                            style: const TextStyle(
                              fontSize: 14,
                              color: textSubtle,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'خصم ${(((oldPrice - price) / oldPrice) * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),

                    // AVAILABILITY TOGGLE CARD
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: lightBgColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: Colors.black.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isAvail
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: isAvail
                                    ? darkForestGreen
                                    : Colors.redAccent,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isAvail
                                        ? 'الوجبة متوفرة للطلب'
                                        : 'الوجبة غير متوفرة حالياً',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isAvail
                                          ? darkForestGreen
                                          : Colors.redAccent,
                                    ),
                                  ),
                                  const Text(
                                    'يمكنك تغيير التوفر فوراً من هنا',
                                    style: TextStyle(
                                        fontSize: 10, color: textSubtle),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Switch.adaptive(
                            value: isAvail,
                            activeTrackColor: vibrantLimeGreen,
                            activeThumbColor: darkForestGreen,
                            onChanged: (val) {
                              setDetailsState(() {
                                prod['isAvailable'] = val;
                              });
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CUSTOMER OPTIONS & ADDONS SECTION
                    const Text(
                      'الخيارات والإضافات المتاحة للزبائن:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (options != null && options.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: options.map((opt) {
                          return Chip(
                            backgroundColor: lightBgColor,
                            side: BorderSide(
                                color: darkForestGreen.withValues(alpha: 0.2)),
                            avatar: const Icon(Icons.add_task_rounded,
                                size: 14, color: darkForestGreen),
                            label: Text(
                              opt.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    else
                      const Text(
                        'لا توجد إضافات خاصة محددة لهذه الوجبة.',
                        style: TextStyle(fontSize: 11, color: textSubtle),
                      ),

                    const SizedBox(height: 24),

                    // EDIT & DELETE ACTIONS ROW
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkForestGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                _showEditProductModal(prod);
                              },
                              icon: const Icon(Icons.edit_rounded,
                                  color: vibrantLimeGreen, size: 20),
                              label: const Text(
                                'تعديل ✏️',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                _confirmDeleteProduct(prod);
                              },
                              icon: const Icon(Icons.delete_forever_rounded,
                                  color: Colors.white, size: 20),
                              label: const Text(
                                'حذف الوجبة 🗑️',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // EDIT PRODUCT MODAL SHEET
  void _showEditProductModal(Map<String, dynamic> prod) {
    final bool isRealEstate = _storeConfig.categoryId == 'real_estate' ||
        _storeConfig.categoryId == 'realEstate' ||
        widget.categoryId == 'real_estate' ||
        widget.categoryId == 'realEstate';

    final titleCtrl = TextEditingController(text: prod['title']);
    final priceCtrl = TextEditingController(text: prod['price']?.toString());
    final oldPriceCtrl = TextEditingController(
        text: prod['oldPrice'] != null ? prod['oldPrice'].toString() : '');
    final extra1Ctrl = TextEditingController(text: prod['badge'] ?? '');
    final optionInputCtrl = TextEditingController();

    // Real Estate tailored fields
    String selectedPropertyType = prod['propertyType'] ?? 'شقة';
    String selectedContractType = prod['contractType'] ?? 'تمليك';
    String selectedInstallmentType = prod['installmentType'] ?? 'شهري';
    final installmentDurationCtrl = TextEditingController(
        text: prod['installmentDuration'] ?? '3 سنوات');
    final installmentAmountCtrl = TextEditingController(
        text: prod['installmentAmount']?.toString() ?? '5000');
    final downPaymentCtrl = TextEditingController(
        text: prod['downPayment']?.toString() ?? '100000');

    bool hasDiscount = prod['oldPrice'] != null;
    List<String> optionsList = prod['options'] != null
        ? List<String>.from(prod['options'])
        : [];
    List<String> productPhotos = prod['images'] != null && (prod['images'] as List).isNotEmpty
        ? List<String>.from(prod['images'])
        : [prod['imagePath'] ?? (isRealEstate ? 'assets/images/cat_realestate.png' : _deviceGalleryImages.first)];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
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
                    // Handle
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
                        const Icon(Icons.edit_note_rounded,
                            color: darkForestGreen, size: 26),
                        const SizedBox(width: 8),
                        Text(
                          'تعديل بيانات: ${prod['title']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 1. MULTI-IMAGE CAROUSEL PREVIEW & PICKER BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'صور ${_storeConfig.productTerm} المرفقة (${productPhotos.length} / 5):',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final nativePicked = await _pickImageFromSystem();
                            if (nativePicked.isNotEmpty) {
                              setModalState(() {
                                for (final p in nativePicked) {
                                  if (!_deviceGalleryImages.contains(p)) {
                                    _deviceGalleryImages.insert(0, p);
                                  }
                                  if (!productPhotos.contains(p) && productPhotos.length < 5) {
                                    productPhotos.add(p);
                                  }
                                }
                              });
                            } else if (context.mounted) {
                              _showMultiImagePickerModal(context, productPhotos,
                                  (newSelected) {
                                setModalState(() {
                                  productPhotos = newSelected;
                                });
                              });
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.desktop_windows_rounded,
                                  color: darkForestGreen, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'تصفح صور الكمبيوتر',
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

                    // SELECTED PHOTOS PREVIEW HORIZONTAL CAROUSEL
                    SizedBox(
                      height: 75,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: productPhotos.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          if (index == productPhotos.length) {
                            if (productPhotos.length >= 5) {
                              return const SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: () async {
                                final nativePicked = await _pickImageFromSystem();
                                if (nativePicked.isNotEmpty) {
                                  setModalState(() {
                                    for (final p in nativePicked) {
                                      if (!_deviceGalleryImages.contains(p)) {
                                        _deviceGalleryImages.insert(0, p);
                                      }
                                      if (!productPhotos.contains(p) && productPhotos.length < 5) {
                                        productPhotos.add(p);
                                      }
                                    }
                                  });
                                } else if (context.mounted) {
                                  _showMultiImagePickerModal(
                                      context, productPhotos, (newSelected) {
                                    setModalState(() {
                                      productPhotos = newSelected;
                                    });
                                  });
                                }
                              },
                              child: Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  color: lightBgColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: darkForestGreen.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate_rounded,
                                        color: darkForestGreen, size: 22),
                                    SizedBox(height: 2),
                                    Text(
                                      '+ صورة',
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

                          final photoPath = productPhotos[index];
                          return Stack(
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: darkForestGreen,
                                    width: 1.5,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _buildProductImageWidget(photoPath, size: 68),
                                ),
                              ),
                              if (productPhotos.length > 1)
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        productPhotos.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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

                    // REAL ESTATE TAILORED SELECT DROPDOWNS
                    if (isRealEstate) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'نوع العقار 🏠:',
                              value: selectedPropertyType,
                              items: realEstatePropertyTypes,
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => selectedPropertyType = val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDropdownField(
                              label: 'نوع العقد 📝:',
                              value: selectedContractType,
                              items: realEstateContractTypes,
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => selectedContractType = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // CONDITIONAL INSTALLMENT FORM FIELDS
                      if (selectedContractType == 'تقسيط') ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: lightBgColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: darkForestGreen.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.payments_rounded,
                                      color: darkForestGreen, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'تفاصيل وحساب التقسيط 💳:',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: darkForestGreen,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildDropdownField(
                                label: 'نظام التقسيط (شهري / سنوي):',
                                value: selectedInstallmentType,
                                items: realEstateInstallmentTypes,
                                onChanged: (val) {
                                  if (val != null) {
                                    setModalState(
                                        () => selectedInstallmentType = val);
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModalTextField(
                                      controller: installmentDurationCtrl,
                                      label: 'مدة التقسيط (كم سنة/شهر)',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildModalTextField(
                                      controller: installmentAmountCtrl,
                                      label:
                                          'مبلغ القسط الـ$selectedInstallmentType (ج.م)',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _buildModalTextField(
                                controller: downPaymentCtrl,
                                label: 'المقدم / الدفعة الأولى (ج.م - اختياري)',
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ],

                    // 3. DISCOUNT TOGGLE SWITCH
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
                                    'تفعيل خصم خاص؟',
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

                    // PRICE INPUTS
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
                        label: isRealEstate ? 'السعر الإجمالي (ج.م)' : 'السعر (ج.م)',
                        keyboardType: TextInputType.number,
                      ),

                    const SizedBox(height: 14),

                    // 4. OPTIONS BUILDER
                    const Text(
                      'خيارات وإضافات المستخدم:',
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
                            label: isRealEstate
                                ? 'مثلاً: تشطيب سوبر لوكس أو شامل الجراج'
                                : 'مثلاً: حجم دبل (+15 ج.م)',
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

                    // 5. EXTRA FIELDS
                    _buildModalTextField(
                      controller: extra1Ctrl,
                      label: _storeConfig.extraField1Label,
                    ),

                    const SizedBox(height: 20),

                    // 6. SAVE EDITS BUTTON
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
                          final t = titleCtrl.text.trim();
                          final p = _parsePrice(priceCtrl.text);
                          final double? oldP =
                              hasDiscount ? _parsePrice(oldPriceCtrl.text) : null;

                          if (t.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('يرجى إدخال ${_storeConfig.fieldLabelTitle}!'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          if (p <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يرجى إدخال سعر صحيح!'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          String badgeText = extra1Ctrl.text.trim();
                          if (isRealEstate) {
                            if (selectedContractType == 'تقسيط') {
                              final dur = installmentDurationCtrl.text.trim();
                              final amt = installmentAmountCtrl.text.trim();
                              final downP = downPaymentCtrl.text.trim();
                              final amtStr = amt.isNotEmpty ? '$amt ج.م' : '';
                              final durStr = dur.isNotEmpty ? dur : 'فترة ميسرة';
                              final downPStr = downP.isNotEmpty ? '(مقدم $downP ج.م)' : '';
                              badgeText =
                                  '$selectedPropertyType • تقسيط $selectedInstallmentType $amtStr على $durStr $downPStr'.trim();
                            } else {
                              final extraStr = badgeText.isNotEmpty ? '• $badgeText' : '';
                              badgeText =
                                  '$selectedPropertyType • عقد $selectedContractType $extraStr'.trim();
                            }
                          } else if (badgeText.isEmpty) {
                            badgeText = 'متوفر بالفرع';
                          }

                          setState(() {
                            prod['title'] = t;
                            prod['price'] = p;
                            prod['oldPrice'] = (oldP != null && oldP > 0) ? oldP : null;
                            if (isRealEstate) {
                              prod['category'] = selectedPropertyType;
                              prod['propertyType'] = selectedPropertyType;
                              prod['contractType'] = selectedContractType;
                              prod['installmentType'] = selectedInstallmentType;
                              prod['installmentDuration'] = installmentDurationCtrl.text.trim();
                              prod['installmentAmount'] = _parsePrice(installmentAmountCtrl.text);
                              prod['downPayment'] = _parsePrice(downPaymentCtrl.text);
                            }
                            prod['badge'] = badgeText;
                            prod['options'] = List<String>.from(optionsList);
                            prod['imagePath'] = productPhotos.first;
                            prod['images'] = List<String>.from(productPhotos);
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم حفظ وتعديل بيانات ($t) بنجاح! ✏️'),
                              backgroundColor: darkForestGreen,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_rounded,
                            color: vibrantLimeGreen, size: 20),
                        label: const Text(
                          'تحديث وتطبيق التعديلات',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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

  // DIRECT VISUAL MULTI-IMAGE GALLERY PICKER MODAL (WITH NATIVE WINDOWS FILE EXPLORER DIALOG)
  void _showMultiImagePickerModal(
      BuildContext context, List<String> currentSelected, Function(List<String>) onConfirm) {
    List<String> tempSelected = List<String>.from(currentSelected);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setPickerState) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.8,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: darkForestGreen.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.folder_open_rounded,
                                color: darkForestGreen, size: 22),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'اختيار صور من جهازك (حتى 5 صور)',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: textDark),
                              ),
                              Text(
                                'تصفح ملفات كمبيوترك أو اختر من المعرض',
                                style: TextStyle(fontSize: 11, color: textSubtle),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: tempSelected.length == 5
                              ? Colors.redAccent.withValues(alpha: 0.1)
                              : darkForestGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${tempSelected.length} / 5',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: tempSelected.length == 5
                                ? Colors.redAccent
                                : darkForestGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // NATIVE WINDOWS FILE EXPLORER DIALOG ACTION BUTTON
                  GestureDetector(
                    onTap: () async {
                      final pickedPaths = await _pickImageFromSystem();
                      if (pickedPaths.isNotEmpty) {
                        setPickerState(() {
                          for (final p in pickedPaths) {
                            if (!_deviceGalleryImages.contains(p)) {
                              _deviceGalleryImages.insert(0, p);
                            }
                            if (!tempSelected.contains(p) && tempSelected.length < 5) {
                              tempSelected.add(p);
                            }
                          }
                        });
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم اختيار (${pickedPaths.length}) صور من ملفات كمبيوترك بنجاح! 📁'),
                              backgroundColor: darkForestGreen,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: lightBgColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: darkForestGreen.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.desktop_windows_rounded,
                              color: darkForestGreen, size: 22),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'فتح واستكشاف ملفات الكمبيوتر',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: darkForestGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // GALLERY MEDIA GRID
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _deviceGalleryImages.length,
                      itemBuilder: (context, index) {
                        final imgPath = _deviceGalleryImages[index];
                        final selectedIndex = tempSelected.indexOf(imgPath);
                        final isSelected = selectedIndex != -1;

                        return GestureDetector(
                          onTap: () {
                            setPickerState(() {
                              if (isSelected) {
                                tempSelected.remove(imgPath);
                              } else {
                                if (tempSelected.length < 5) {
                                  tempSelected.add(imgPath);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('يمكنك اختيار 5 صور كحد أقصى للوجبة!'),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? darkForestGreen
                                        : Colors.black.withValues(alpha: 0.1),
                                    width: isSelected ? 3 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: _buildProductImageWidget(imgPath,
                                      size: double.infinity),
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: darkForestGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${selectedIndex + 1}',
                                        style: const TextStyle(
                                          color: vibrantLimeGreen,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  // CONFIRM SELECTION BUTTON
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
                        if (tempSelected.isEmpty && _deviceGalleryImages.isNotEmpty) {
                          tempSelected.add(_deviceGalleryImages.first);
                        }
                        onConfirm(tempSelected);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'تم حفظ وثبيت (${tempSelected.length}) صور بالوجبة بنجاح!'),
                            backgroundColor: darkForestGreen,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle_rounded,
                          color: vibrantLimeGreen, size: 20),
                      label: Text(
                        'تأكيد واستخدام (${tempSelected.length}) صور',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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

  double _parsePrice(String text) {
    String clean = text
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9')
        .trim();
    return double.tryParse(clean) ?? 0.0;
  }

  void _showAddProductModal() {
    final bool isRealEstate = _storeConfig.categoryId == 'real_estate' ||
        _storeConfig.categoryId == 'realEstate' ||
        widget.categoryId == 'real_estate' ||
        widget.categoryId == 'realEstate';

    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final oldPriceCtrl = TextEditingController();
    final extra1Ctrl = TextEditingController();
    final extra2Ctrl = TextEditingController();
    final optionInputCtrl = TextEditingController();

    // Real Estate tailored selects & fields
    String selectedPropertyType = 'شقة';
    String selectedContractType = 'تمليك';
    String selectedInstallmentType = 'شهري';
    final installmentDurationCtrl = TextEditingController(text: '3 سنوات');
    final installmentAmountCtrl = TextEditingController(text: '5000');
    final downPaymentCtrl = TextEditingController(text: '100000');

    List<String> productPhotos = [
      isRealEstate ? 'assets/images/cat_realestate.png' : _deviceGalleryImages.first
    ];
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
              height: MediaQuery.of(context).size.height * 0.88,
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

                    // 1. MULTI-IMAGE CAROUSEL PREVIEW & PICKER BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'صور ${_storeConfig.productTerm} المرفقة (${productPhotos.length} / 5):',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final nativePicked = await _pickImageFromSystem();
                            if (nativePicked.isNotEmpty) {
                              setModalState(() {
                                for (final p in nativePicked) {
                                  if (!_deviceGalleryImages.contains(p)) {
                                    _deviceGalleryImages.insert(0, p);
                                  }
                                  if (!productPhotos.contains(p) && productPhotos.length < 5) {
                                    productPhotos.add(p);
                                  }
                                }
                              });
                            } else if (context.mounted) {
                              _showMultiImagePickerModal(context, productPhotos,
                                  (newSelected) {
                                setModalState(() {
                                  productPhotos = newSelected;
                                });
                              });
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.desktop_windows_rounded,
                                  color: darkForestGreen, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'تصفح صور الكمبيوتر',
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

                    // SELECTED PHOTOS PREVIEW HORIZONTAL CAROUSEL
                    SizedBox(
                      height: 75,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: productPhotos.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          // Plus tile to open native system file explorer dialog
                          if (index == productPhotos.length) {
                            if (productPhotos.length >= 5) {
                              return const SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: () async {
                                final nativePicked = await _pickImageFromSystem();
                                if (nativePicked.isNotEmpty) {
                                  setModalState(() {
                                    for (final p in nativePicked) {
                                      if (!_deviceGalleryImages.contains(p)) {
                                        _deviceGalleryImages.insert(0, p);
                                      }
                                      if (!productPhotos.contains(p) && productPhotos.length < 5) {
                                        productPhotos.add(p);
                                      }
                                    }
                                  });
                                } else if (context.mounted) {
                                  _showMultiImagePickerModal(
                                      context, productPhotos, (newSelected) {
                                    setModalState(() {
                                      productPhotos = newSelected;
                                    });
                                  });
                                }
                              },
                              child: Container(
                                width: 68,
                                height: 68,
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
                                      '+ صورة',
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

                          final photoPath = productPhotos[index];
                          return Stack(
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: darkForestGreen,
                                    width: 1.5,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _buildProductImageWidget(photoPath, size: 68),
                                ),
                              ),

                              // Remove image badge (X)
                              if (productPhotos.length > 1)
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        productPhotos.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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

                    // REAL ESTATE TAILORED SELECT DROPDOWNS
                    if (isRealEstate) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'نوع العقار 🏠:',
                              value: selectedPropertyType,
                              items: realEstatePropertyTypes,
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => selectedPropertyType = val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDropdownField(
                              label: 'نوع العقد 📝:',
                              value: selectedContractType,
                              items: realEstateContractTypes,
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => selectedContractType = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // CONDITIONAL INSTALLMENT FORM FIELDS
                      if (selectedContractType == 'تقسيط') ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: lightBgColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: darkForestGreen.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.payments_rounded,
                                      color: darkForestGreen, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'تفاصيل وحساب التقسيط 💳:',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: darkForestGreen,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildDropdownField(
                                label: 'نظام التقسيط (شهري / سنوي):',
                                value: selectedInstallmentType,
                                items: realEstateInstallmentTypes,
                                onChanged: (val) {
                                  if (val != null) {
                                    setModalState(
                                        () => selectedInstallmentType = val);
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModalTextField(
                                      controller: installmentDurationCtrl,
                                      label: 'مدة التقسيط (كم سنة/شهر)',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildModalTextField(
                                      controller: installmentAmountCtrl,
                                      label:
                                          'مبلغ القسط الـ$selectedInstallmentType (ج.م)',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _buildModalTextField(
                                controller: downPaymentCtrl,
                                label: 'المقدم / الدفعة الأولى (ج.م - اختياري)',
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ],

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
                                    'تفعيل خصم خاص؟',
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
                        label: isRealEstate ? 'السعر الإجمالي (ج.م)' : 'السعر (ج.م)',
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
                            label: isRealEstate
                                ? 'مثلاً: تشطيب سوبر لوكس أو شامل الجراج'
                                : 'مثلاً: حجم دبل (+15 ج.م)',
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
                          final p = _parsePrice(priceCtrl.text);
                          final double? oldP =
                              hasDiscount ? _parsePrice(oldPriceCtrl.text) : null;

                          if (t.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('يرجى إدخال ${_storeConfig.fieldLabelTitle} أولاً!'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          if (p <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يرجى إدخال سعر صحيح!'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          String badgeText = extra1Ctrl.text.trim();
                          if (isRealEstate) {
                            if (selectedContractType == 'تقسيط') {
                              final dur = installmentDurationCtrl.text.trim();
                              final amt = installmentAmountCtrl.text.trim();
                              final downP = downPaymentCtrl.text.trim();
                              final amtStr = amt.isNotEmpty ? '$amt ج.م' : '';
                              final durStr = dur.isNotEmpty ? dur : 'فترة ميسرة';
                              final downPStr = downP.isNotEmpty ? '(مقدم $downP ج.م)' : '';
                              badgeText =
                                  '$selectedPropertyType • تقسيط $selectedInstallmentType $amtStr على $durStr $downPStr'.trim();
                            } else {
                              final extraStr = badgeText.isNotEmpty ? '• $badgeText' : '';
                              badgeText =
                                  '$selectedPropertyType • عقد $selectedContractType $extraStr'.trim();
                            }
                          } else if (badgeText.isEmpty) {
                            badgeText = 'متوفر بالفرع';
                          }

                          setState(() {
                            _myProducts.insert(0, {
                              'id':
                                  'p_${DateTime.now().millisecondsSinceEpoch}',
                              'title': t,
                              'price': p,
                              'oldPrice': (oldP != null && oldP > 0) ? oldP : null,
                              'category': 'جديد',
                              'badge': badgeText,
                              'options': List<String>.from(optionsList),
                              'isAvailable': true,
                              'imagePath': productPhotos.first,
                              'images': List<String>.from(productPhotos),
                            });
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'تم إضافة ($t) مع (${productPhotos.length}) صور بنجاح!'),
                              backgroundColor: darkForestGreen,
                            ),
                          );
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
            // 1. ACTIVE STORE OFFERS CAROUSEL SECTION (عروض المتجر النشطة 🔥)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer_rounded,
                          color: accentOrange, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'عروض المتجر النشطة (${_myOffers.length}):',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showAddPromoOfferModal(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: darkForestGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded,
                            color: vibrantLimeGreen, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'إضافة عرض جديد',
                          style: TextStyle(
                            color: vibrantLimeGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (_myOffers.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _myOffers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final offer = _myOffers[index];
                    return Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: File(offer.bgImagePath).existsSync()
                                      ? Image.file(File(offer.bgImagePath),
                                          fit: BoxFit.cover)
                                      : Image.asset(offer.bgImagePath,
                                          fit: BoxFit.cover),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withValues(alpha: 0.85),
                                          Colors.black.withValues(alpha: 0.55),
                                          Colors.black.withValues(alpha: 0.15),
                                        ],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Text(
                                            offer.badgeText,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            offer.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${offer.subtitleText} ',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Text(
                                                offer.discountNum,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              const SizedBox(width: 3),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(
                                                  color: accentOrange,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Text(
                                                  '%',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        offer.footerNote,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _myOffers.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم إيقاف وحذف العرض الترويجي!'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            const SizedBox(height: 18),

            // 2. STORE CATEGORY TAILORED BANNER & QUICK TAGS
            if (_storeConfig.hasPrescriptionFeature) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _storeConfig.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: _storeConfig.primaryColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.medical_information_rounded,
                        color: _storeConfig.primaryColor, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نظام الصيدلية والروشتات الطبية 📜',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _storeConfig.primaryColor,
                            ),
                          ),
                          const Text(
                            'يدعم تلقي صور روشتات المرضى وفحص المادة الفعالة مع التوصيل',
                            style: TextStyle(fontSize: 10, color: textSubtle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // QUICK CATEGORY FILTER TAGS HORIZONTAL LIST
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _storeConfig.quickCategoryTags.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tag = _storeConfig.quickCategoryTags[index];
                  final isSelected = index == 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? darkForestGreen : cardWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? darkForestGreen
                            : Colors.black.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? vibrantLimeGreen : textDark,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 3. PRODUCTS LIST HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'قائمة ${_storeConfig.productTerm} (${_filteredProducts.length}):',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'انقر للتفاصيل أو الحذف',
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
                final List<dynamic>? images = prod['images'];
                final String imgPath = prod['imagePath'] ??
                    (images != null && images.isNotEmpty
                        ? images.first
                        : _deviceGalleryImages.first);

                return GestureDetector(
                  onTap: () => _showProductDetailsModal(prod),
                  child: Container(
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
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: _buildProductImageWidget(imgPath, size: 64),
                            ),
                            if (images != null && images.length > 1)
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: darkForestGreen.withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${images.length} صور',
                                    style: const TextStyle(
                                      color: vibrantLimeGreen,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
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
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 6,
                                runSpacing: 2,
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
                                    Text(
                                      '${prod['oldPrice']} ج.م',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: textSubtle,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
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
                            Row(
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
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () => _showEditProductModal(prod),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: darkForestGreen.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit_rounded,
                                      size: 14,
                                      color: darkForestGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () => _confirmDeleteProduct(prod),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 14,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
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
