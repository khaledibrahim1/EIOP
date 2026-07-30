import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../theme/app_colors.dart';
import 'location_picker_screen.dart';

class ParcelDeliveryScreen extends StatefulWidget {
  const ParcelDeliveryScreen({super.key});

  @override
  State<ParcelDeliveryScreen> createState() => _ParcelDeliveryScreenState();
}

class _ParcelDeliveryScreenState extends State<ParcelDeliveryScreen> {
  // Service Type: 0 = طرد وأمانة, 1 = اشترِ لي (مرسول), 2 = مستندات وأوراق
  int _selectedServiceType = 0;

  // Package Size: 0 = صغير, 1 = متوسط, 2 = كبير
  int _selectedPackageSize = 1;

  final TextEditingController _pickupController =
      TextEditingController(text: 'شارع المحطة - بجوار البنك الأهلي (جرجا)');
  final TextEditingController _dropoffController = TextEditingController();
  final TextEditingController _errandDetailsController = TextEditingController();
  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _recipientPhoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();

  // Flags & Options
  bool _isFragile = false;
  bool _payOnDelivery = false;
  String? _attachedPhotoName;
  bool _isUploadingPhoto = false;
  double _discount = 0.0;

  // Categories for errand/package
  final List<String> _packageCategories = [
    'أمانة شخصية / ملابس',
    'هدية أو مشتريات خاصة',
    'مفاتيح / إلكترونيات',
    'مستندات وأوراق رسمية',
    'علاج / أدوات طبية',
  ];
  String _selectedCategory = 'أمانة شخصية / ملابس';

  double get _calculatedFee {
    double baseFee = 20.0;

    // Service modifier
    if (_selectedServiceType == 1) baseFee += 10.0; // اشترِ لي
    if (_selectedServiceType == 2) baseFee += 5.0; // مستندات

    // Size modifier
    if (_selectedPackageSize == 0) baseFee += 0.0;
    if (_selectedPackageSize == 1) baseFee += 5.0;
    if (_selectedPackageSize == 2) baseFee += 15.0;

    // Options
    if (_isFragile) baseFee += 5.0;

    double finalFee = baseFee - _discount;
    return finalFee < 15.0 ? 15.0 : finalFee;
  }

  void _pickPickupLocationOnMap() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          currentLocation: _pickupController.text,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _pickupController.text = result;
      });
    }
  }

  void _pickDropoffLocationOnMap() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          currentLocation: _dropoffController.text.isNotEmpty
              ? _dropoffController.text
              : 'ميدان النهضة - جرجا',
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _dropoffController.text = result;
      });
    }
  }

  void _simulatePhotoUpload() {
    setState(() => _isUploadingPhoto = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _isUploadingPhoto = false;
        _attachedPhotoName = 'صورة_الطرد_المرفقة.jpg';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرفاق صورة الشحنة بنجاح 📷'),
          backgroundColor: Color(0xFF0EA5E9),
        ),
      );
    });
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'EIOP10' || code == 'EXPRESS') {
      setState(() => _discount = 10.0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تطبيق خصم 10 جنيهات بنجاح! 🎟️'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كوبون غير صالح. جرب EIOP10'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitParcelOrder() {
    if (_dropoffController.text.trim().isEmpty && _selectedServiceType != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('برجاء تحديد عنوان تسليم الشحنة أولاً 📍'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final categoryDesc = _selectedServiceType == 1
        ? 'مرسول: ${_errandDetailsController.text.isNotEmpty ? _errandDetailsController.text : "طلب شراء خاص"}'
        : _selectedCategory;

    appState.placeParcelOrder(
      pickup: _pickupController.text,
      dropoff: _dropoffController.text.isNotEmpty
          ? _dropoffController.text
          : 'حسب توجيه العميل',
      category: categoryDesc,
      fee: _calculatedFee,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 28),
            SizedBox(width: 10),
            Text(
              'تم طلب المرسول بنجاح!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تم توجيه أقرب كابتن مرسول بمدينة جرجا واستلام أمانتك فوراً 🛵',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('تكلفة التوصيل:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(
                    '${_calculatedFee.toStringAsFixed(0)} ج.م',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Color(0xFF0EA5E9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0EA5E9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'متابعة التتبع المباشر ⚡',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 1. SLEEK HEADER WITH BACK BUTTON & STATUS BADGE
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.headerFadeGradient,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                if (Navigator.canPop(context))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0EA5E9)
                                              .withValues(alpha: 0.12),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back_rounded,
                                          color: Color(0xFF0EA5E9),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                const Icon(Icons.two_wheeler_rounded,
                                    color: Color(0xFF0EA5E9), size: 24),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'EIOP Express - مرسول وطرد',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF0EA5E9),
                                        ),
                                      ),
                                      Text(
                                        'توصيل سريع ونقل أمانات بجرجا',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'مندوبون جاهزون ⚡',
                                  style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // SERVICE TYPE SWITCHER TABS
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            _buildServiceTypeTab(0, 'ارسل طرد / أمانة',
                                Icons.inventory_2_outlined),
                            _buildServiceTypeTab(
                                1, 'اشترِ لي (مرسول)', Icons.shopping_bag_outlined),
                            _buildServiceTypeTab(
                                2, 'مستندات وأوراق', Icons.description_outlined),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. MAIN SCROLLABLE FORM
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. ROUTE & LOCATIONS VISUAL TIMELINE CARD
                    _buildRouteLocationCard(),
                    const SizedBox(height: 18),

                    // B. SERVICE SPECIFIC DETAILS
                    if (_selectedServiceType == 1) ...[
                      // ERRAND / BUY FOR ME DETAILS
                      Text(
                        'تفاصيل طلب الشراء وقضاء الحاجة:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                          ),
                        ),
                        child: TextField(
                          controller: _errandDetailsController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText:
                                'اكتب الأغراض المطلوب شراؤها والمحل المراد الشراء منه (مثال: اشترِ لي من مكتبة السلام كشكول وأقلام وسلمها في العنوان الموضح)...',
                            hintStyle: TextStyle(fontSize: 12),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ] else ...[
                      // PACKAGE CATEGORY CHIPS
                      Text(
                        'تصنيف ومحتوى الشحنة:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _packageCategories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cat = _packageCategories[index];
                            final isSelected = _selectedCategory == cat;
                            return ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: const Color(0xFF0EA5E9),
                              backgroundColor: AppColors.surface,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              onSelected: (val) {
                                if (val) {
                                  setState(() => _selectedCategory = cat);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // C. PACKAGE SIZE & WEIGHT PRESETS
                    Text(
                      'حجم الشحنة والوزن التقديري:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildSizeOption(
                            index: 0,
                            title: 'صغير 🔑',
                            subtitle: 'مفاتيح / أوراق',
                            priceTag: '+0 ج.م'),
                        const SizedBox(width: 8),
                        _buildSizeOption(
                            index: 1,
                            title: 'متوسط 🎁',
                            subtitle: 'علبة / أمانة',
                            priceTag: '+5 ج.م'),
                        const SizedBox(width: 8),
                        _buildSizeOption(
                            index: 2,
                            title: 'كبير 📦',
                            subtitle: 'كرتونة / أغراض',
                            priceTag: '+15 ج.م'),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // D. SPECIAL OPTIONS & PHOTO ATTACHMENT CARD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Photo Attachment
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.camera_alt_outlined,
                                        color: Color(0xFF0EA5E9), size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'إرفاق صورة الشحنة',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            'توثيق ومساعدة الكابتن في التعرف على الطرد',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (_isUploadingPhoto)
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF0EA5E9),
                                  ),
                                )
                              else if (_attachedPhotoName != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.check_circle_rounded,
                                          color: Color(0xFF10B981), size: 14),
                                      SizedBox(width: 4),
                                      Text(
                                        'تم الرفع',
                                        style: TextStyle(
                                          color: Color(0xFF10B981),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _simulatePhotoUpload,
                                  icon: const Icon(Icons.add_a_photo_outlined,
                                      size: 14, color: Color(0xFF0EA5E9)),
                                  label: const Text('إضافة صورة',
                                      style: TextStyle(
                                          color: Color(0xFF0EA5E9),
                                          fontSize: 11)),
                                ),
                            ],
                          ),
                          const Divider(height: 24),

                          // Fragile Option
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('قابل للكسر / يتعين التعامل بحذر ⚠️',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            value: _isFragile,
                            activeColor: const Color(0xFF0EA5E9),
                            onChanged: (val) {
                              setState(() => _isFragile = val ?? false);
                            },
                          ),

                          // COD Option
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('طلب الدفع عند الاستلام من المستلم (COD) 💵',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            value: _payOnDelivery,
                            activeColor: const Color(0xFF0EA5E9),
                            onChanged: (val) {
                              setState(() => _payOnDelivery = val ?? false);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // E. RECIPIENT DETAILS CARD
                    Text(
                      'بيانات الشخص المستلم:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              controller: _recipientNameController,
                              decoration: const InputDecoration(
                                hintText: 'اسم المستلم',
                                hintStyle: TextStyle(fontSize: 12),
                                prefixIcon: Icon(Icons.person_outline_rounded,
                                    color: Color(0xFF0EA5E9), size: 20),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              controller: _recipientPhoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: 'رقم هاتف المستلم',
                                hintStyle: TextStyle(fontSize: 12),
                                prefixIcon: Icon(Icons.phone_android_rounded,
                                    color: Color(0xFF0EA5E9), size: 20),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // NOTES FIELD
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText:
                              'ملاحظات إضافية للمندوب (مثال: اتصل بالمستلم قبل الوصول بخمس دقائق)...',
                          hintStyle: TextStyle(fontSize: 12),
                          prefixIcon: Icon(Icons.notes_rounded,
                              color: Colors.amber, size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // F. PROMO COUPON FIELD
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFF0EA5E9)
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: TextField(
                              controller: _couponController,
                              decoration: const InputDecoration(
                                hintText: 'كود الخصم (مثال: EIOP10)',
                                hintStyle: TextStyle(fontSize: 11),
                                prefixIcon: Icon(Icons.confirmation_number_outlined,
                                    color: Color(0xFF0EA5E9), size: 18),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0EA5E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _applyCoupon,
                            child: const Text('تطبيق',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // G. FARE BREAKDOWN & CONFIRMATION BUTTON
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'رسوم التوصيل التقديرية:',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  if (_discount > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Text(
                                        '${(_calculatedFee + _discount).toStringAsFixed(0)} ج.م',
                                        style: const TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    '${_calculatedFee.toStringAsFixed(0)} ج.م',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0EA5E9),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0EA5E9),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: _submitParcelOrder,
                              icon: const Icon(Icons.send_rounded,
                                  color: Colors.white, size: 20),
                              label: const Text(
                                'تأكيد واستدعاء مرسول التوصيل فوراً 🚀',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTypeTab(int index, String title, IconData icon) {
    final isSelected = _selectedServiceType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedServiceType = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0EA5E9) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRouteLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // PICKUP LOCATION (GREEN)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.my_location_rounded,
                    color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _pickupController,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'موقع الاستلام (منين نسلم الشحنة؟)',
                    labelStyle: TextStyle(fontSize: 11, color: Colors.green),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.map_rounded,
                    color: Color(0xFF0EA5E9), size: 20),
                onPressed: _pickPickupLocationOnMap,
                tooltip: 'اختيار من الخريطة',
              ),
            ],
          ),

          // TIMELINE DOTTED ROUTE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 2,
                  color: Colors.grey.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'مسافة تقديرية ~3.2 كم • 12-15 دقيقة ⏱️',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          // DROPOFF LOCATION (RED)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on_rounded,
                    color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _dropoffController,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'موقع التسليم (تترسل فين؟)',
                    hintText: 'مثال: حي الزهراء - بالقرب من المستشفى',
                    labelStyle: TextStyle(fontSize: 11, color: Colors.red),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.map_rounded,
                    color: Color(0xFF0EA5E9), size: 20),
                onPressed: _pickDropoffLocationOnMap,
                tooltip: 'اختيار من الخريطة',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption({
    required int index,
    required String title,
    required String subtitle,
    required String priceTag,
  }) {
    final isSelected = _selectedPackageSize == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedPackageSize = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0EA5E9).withValues(alpha: 0.12)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0EA5E9)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isSelected
                      ? const Color(0xFF0EA5E9)
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0EA5E9)
                      : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priceTag,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
