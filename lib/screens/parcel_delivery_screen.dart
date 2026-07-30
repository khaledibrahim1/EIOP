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
  // Service Type: 0 = ارسل طرد, 1 = اشترِ لي (مرسول), 2 = مستندات وأوراق
  int _selectedServiceType = 0;

  // Package / Ride Option: 0 = مرسول عادي, 1 = اكسبريس سريع, 2 = سيارة حمولات
  int _selectedOptionIndex = 1;

  final TextEditingController _pickupController =
      TextEditingController(text: 'شارع المحطة - بجوار البنك الأهلي (جرجا)');
  final TextEditingController _dropoffController =
      TextEditingController(text: 'ميدان النهضة - الشارع التجاري (جرجا)');
  final TextEditingController _errandDetailsController = TextEditingController();
  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _recipientPhoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();

  // Options & Flags
  bool _isFragile = false;
  bool _payOnDelivery = false;
  bool _showMoreDetails = false;
  String? _attachedPhotoName;
  bool _isUploadingPhoto = false;
  double _discount = 0.0;

  // Option Specifications
  final List<Map<String, dynamic>> _rideOptions = const [
    {
      'title': 'مرسول عادي',
      'subtitle': '12-15 دقيقة • حمولة صغيرة',
      'price': 20.0,
      'tag': '',
      'icon': Icons.two_wheeler_outlined,
    },
    {
      'title': 'اكسبريس سريع',
      'subtitle': '5-10 دقائق • الأكثر طلباً',
      'price': 25.0,
      'tag': 'الأسرع',
      'icon': Icons.bolt_outlined,
    },
    {
      'title': 'سيارة حمولات',
      'subtitle': '15-20 دقيقة • حمولة كبيرة',
      'price': 35.0,
      'tag': 'كبير',
      'icon': Icons.local_shipping_outlined,
    },
  ];

  double get _calculatedFee {
    double baseFee = _rideOptions[_selectedOptionIndex]['price'] as double;
    if (_selectedServiceType == 1) baseFee += 5.0; // اشترِ لي
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
        _attachedPhotoName = 'صورة_الشحنة_المرفقة.jpg';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرفاق صورة الشحنة بنجاح'),
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
          content: Text('تم تطبيق خصم 10 جنيهات بنجاح'),
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
          content: Text('برجاء تحديد عنوان تسليم الشحنة أولاً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final categoryDesc = _selectedServiceType == 1
        ? 'مرسول: ${_errandDetailsController.text.isNotEmpty ? _errandDetailsController.text : "طلب شراء خاص"}'
        : _rideOptions[_selectedOptionIndex]['title'];

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
            Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 26),
            SizedBox(width: 10),
            Text(
              'تم تأكيد وحجز المرسول!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تم توجيه الكابتن الموصى به بمدينة جرجا واستلام الأمانة والتوصيل.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0EA5E9).withValues(alpha: 0.08),
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
              backgroundColor: const Color(0xFFD4FF00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'متابعة التتبع المباشر',
              style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
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
        child: Stack(
          children: [
            // 1. TOP INTERACTIVE VECTOR MAP CANVAS (HEADER)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Stack(
                children: [
                  // Vector Map Canvas Painter
                  CustomPaint(
                    size: Size.infinite,
                    painter: _ParcelRouteMapPainter(),
                  ),

                  // Map Dark Overlay Gradient
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.5),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // TOP FLOATING BAR (BACK BUTTON & STATUS)
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (Navigator.canPop(context))
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 10),
                              const Text(
                                'حجز وتأكيد التوصيل',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
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
                                const SizedBox(width: 6),
                                const Text(
                                  'مندوبون متوفرون',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // FLOATING ADDRESS CARD ON TOP OF MAP
                  Positioned(
                    top: 80,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Pickup Row
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD4FF00),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _pickupController.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _pickPickupLocationOnMap,
                                child: const Text(
                                  'تغيير',
                                  style: TextStyle(
                                    color: Color(0xFFD4FF00),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Divider(color: Colors.white12, height: 1),
                          ),
                          // Dropoff Row
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _dropoffController.text.isNotEmpty
                                      ? _dropoffController.text
                                      : 'حدد موقع تسليم الشحنة...',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _dropoffController.text.isNotEmpty
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _pickDropoffLocationOnMap,
                                child: const Text(
                                  'تحديد',
                                  style: TextStyle(
                                    color: Color(0xFF0EA5E9),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. SLIDING BOTTOM SHEET CONTAINER WITH STICKY CTA BUTTON
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.36,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // A. SCROLLABLE CONTENT
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Sheet Handle Indicator Bar
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // SERVICE TYPE SWITCHER TABS
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.cardBg,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  _buildServiceTypeTab(
                                      0, 'ارسل طرد', Icons.inventory_2_outlined),
                                  _buildServiceTypeTab(
                                      1, 'اشترِ لي (مرسول)', Icons.shopping_bag_outlined),
                                  _buildServiceTypeTab(
                                      2, 'مستندات وأوراق', Icons.article_outlined),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ERRAND SPECIAL FIELD IF SELECTED
                            if (_selectedServiceType == 1) ...[
                              Text(
                                'تفاصيل طلب الشراء وقضاء الحاجة:',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.cardBg,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: TextField(
                                  controller: _errandDetailsController,
                                  maxLines: 2,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'اكتب الأغراض المطلوب شراؤها والمحل المراد الشراء منه...',
                                    hintStyle: TextStyle(fontSize: 12),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // RIDE / PARCEL OPTION SELECTION CARDS
                            Text(
                              'خيارات المرسول وسرعة التوصيل:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Column(
                              children: List.generate(_rideOptions.length, (index) {
                                final option = _rideOptions[index];
                                final isSelected = _selectedOptionIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() => _selectedOptionIndex = index);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF0F172A)
                                          : AppColors.cardBg,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFD4FF00)
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xFFD4FF00)
                                                    .withValues(alpha: 0.15)
                                                : Colors.grey.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            option['icon'] as IconData,
                                            color: isSelected
                                                ? const Color(0xFFD4FF00)
                                                : AppColors.textSecondary,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    option['title'] as String,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  if ((option['tag'] as String)
                                                      .isNotEmpty) ...[
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 6,
                                                              vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFD4FF00),
                                                        borderRadius:
                                                            BorderRadius.circular(6),
                                                      ),
                                                      child: Text(
                                                        option['tag'] as String,
                                                        style: const TextStyle(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF0F172A),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                option['subtitle'] as String,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: isSelected
                                                      ? Colors.white60
                                                      : AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${(option['price'] as double).toStringAsFixed(0)} ج.م',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: isSelected
                                                ? const Color(0xFFD4FF00)
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 14),

                            // CAPTAIN RECOMMENDATION & TRIP METRICS CARD (MOCKUP STYLE)
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD4FF00)
                                              .withValues(alpha: 0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.person_rounded,
                                          color: Color(0xFFD4FF00),
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'الكابتن الموصى به: أحمد علي',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              children: [
                                                Icon(Icons.star_rounded,
                                                    color: Colors.amber, size: 14),
                                                SizedBox(width: 4),
                                                Text(
                                                  '4.9 • 140 رحلة ناجحة',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.white12, height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildMetricItem('المسافة', '3.2 كم'),
                                      Container(
                                          width: 1, height: 20, color: Colors.white12),
                                      _buildMetricItem('الوقت', '12 دقيقة'),
                                      Container(
                                          width: 1, height: 20, color: Colors.white12),
                                      _buildMetricItem(
                                          'السعر', '${_calculatedFee.toStringAsFixed(0)} ج.م'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // COLLAPSIBLE RECIPIENT & OPTIONS EXPANDER
                            GestureDetector(
                              onTap: () {
                                setState(() => _showMoreDetails = !_showMoreDetails);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBg,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'بيانات المستلم والشحنة (اختياري)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Icon(
                                      _showMoreDetails
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            if (_showMoreDetails) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.cardBg,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: TextField(
                                        controller: _recipientNameController,
                                        decoration: const InputDecoration(
                                          hintText: 'اسم المستلم',
                                          hintStyle: TextStyle(fontSize: 11),
                                          prefixIcon: Icon(Icons.person_outline_rounded,
                                              size: 18),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.cardBg,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: TextField(
                                        controller: _recipientPhoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                          hintText: 'رقم هاتف المستلم',
                                          hintStyle: TextStyle(fontSize: 11),
                                          prefixIcon: Icon(
                                              Icons.phone_android_rounded,
                                              size: 18),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Notes field
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.cardBg,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: TextField(
                                  controller: _notesController,
                                  maxLines: 2,
                                  decoration: const InputDecoration(
                                    hintText: 'ملاحظات إضافية للمندوب (اختياري)...',
                                    hintStyle: TextStyle(fontSize: 11),
                                    prefixIcon: Icon(Icons.notes_rounded, size: 18),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Photo upload & Promo Coupon Row
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: _simulatePhotoUpload,
                                      icon: _isUploadingPhoto
                                          ? const SizedBox(
                                              width: 14,
                                              height: 14,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                          : Icon(
                                              _attachedPhotoName != null
                                                  ? Icons.check_circle_rounded
                                                  : Icons.add_a_photo_outlined,
                                              size: 16,
                                              color: const Color(0xFF0EA5E9),
                                            ),
                                      label: Text(
                                        _attachedPhotoName ?? 'إرفاق صورة الشحنة',
                                        style: const TextStyle(
                                            color: Color(0xFF0EA5E9), fontSize: 10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 38,
                                            decoration: BoxDecoration(
                                              color: AppColors.cardBg,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: TextField(
                                              controller: _couponController,
                                              decoration: const InputDecoration(
                                                hintText: 'كوبون الخصم',
                                                hintStyle: TextStyle(fontSize: 10),
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF0EA5E9),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: _applyCoupon,
                                          child: const Text('تطبيق',
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 10)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('قابل للكسر / التعامل بحذر',
                                    style: TextStyle(fontSize: 11)),
                                value: _isFragile,
                                activeColor: const Color(0xFF0EA5E9),
                                onChanged: (val) {
                                  setState(() => _isFragile = val ?? false);
                                },
                              ),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('طلب الدفع عند الاستلام (COD)',
                                    style: TextStyle(fontSize: 11)),
                                value: _payOnDelivery,
                                activeColor: const Color(0xFF0EA5E9),
                                onChanged: (val) {
                                  setState(() => _payOnDelivery = val ?? false);
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // B. FIXED STICKY ELECTRIC NEON LIME CTA BUTTON BAR
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.1),
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false,
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4FF00),
                              elevation: 4,
                              shadowColor:
                                  const Color(0xFFD4FF00).withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            onPressed: _submitParcelOrder,
                            child: const Text(
                              'تأكيد وحجز التوصيل',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
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
            color: isSelected ? const Color(0xFF0F172A) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected
                      ? const Color(0xFFD4FF00)
                      : AppColors.textSecondary,
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

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white54),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// Custom Map Canvas Painter for Parcel Delivery Screen Header
class _ParcelRouteMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Light Map Ground
    final bgPaint = Paint()..color = const Color(0xFFE2E8F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Minor Streets
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    // Main Avenue
    final mainRoadPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 22
      ..style = PaintingStyle.stroke;

    // Nile River Curve
    final riverPaint = Paint()
      ..color = const Color(0xFFBFDBFE)
      ..strokeWidth = 36
      ..style = PaintingStyle.stroke;

    // Draw Nile River on the right edge
    final riverPath = Path()
      ..moveTo(size.width * 0.88, 0)
      ..cubicTo(
        size.width * 0.95,
        size.height * 0.4,
        size.width * 0.82,
        size.height * 0.7,
        size.width * 0.9,
        size.height,
      );
    canvas.drawPath(riverPath, riverPaint);

    // Draw Girga Street Network
    final path1 = Path()
      ..moveTo(0, size.height * 0.35)
      ..lineTo(size.width, size.height * 0.42);

    final path2 = Path()
      ..moveTo(size.width * 0.45, 0)
      ..lineTo(size.width * 0.52, size.height);

    final path3 = Path()
      ..moveTo(0, size.height * 0.7)
      ..lineTo(size.width, size.height * 0.65);

    canvas.drawPath(path1, mainRoadPaint);
    canvas.drawPath(path2, roadPaint);
    canvas.drawPath(path3, roadPaint);

    // DRAW ROUTE POLYLINE (From Pickup to Dropoff)
    final routePath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.38)
      ..lineTo(size.width * 0.45, size.height * 0.38)
      ..lineTo(size.width * 0.45, size.height * 0.62)
      ..lineTo(size.width * 0.72, size.height * 0.62);

    final routeLinePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(routePath, routeLinePaint);

    // DRAW PICKUP GREEN DOT 🟢
    final startOffset = Offset(size.width * 0.25, size.height * 0.38);
    final startCirclePaint = Paint()
      ..color = const Color(0xFFD4FF00)
      ..style = PaintingStyle.fill;
    final startBorderPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(startOffset, 9, startCirclePaint);
    canvas.drawCircle(startOffset, 9, startBorderPaint);

    // DRAW DROPOFF RED DOT 🔴
    final endOffset = Offset(size.width * 0.72, size.height * 0.62);
    final endCirclePaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(endOffset, 9, endCirclePaint);
    canvas.drawCircle(endOffset, 9, startBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
