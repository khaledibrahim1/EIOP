import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../theme/app_colors.dart';
import 'location_picker_screen.dart';

class ParcelDeliveryScreen extends StatefulWidget {
  const ParcelDeliveryScreen({super.key});

  @override
  State<ParcelDeliveryScreen> createState() => _ParcelDeliveryScreenState();
}

class _ParcelDeliveryScreenState extends State<ParcelDeliveryScreen>
    with SingleTickerProviderStateMixin {
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

  // Interactive Map Animation & Pan/Zoom Controls
  late AnimationController _driverAnimController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  Offset _mapPanOffset = Offset.zero;
  double _mapZoomScale = 1.0;
  bool _isLocatingMap = false;

  // Options & Flags
  bool _isFragile = false;
  bool _payOnDelivery = false;
  bool _showMoreDetails = false;
  String? _attachedPhotoName;
  bool _isUploadingPhoto = false;
  double _discount = 0.0;

  @override
  void initState() {
    super.initState();
    _driverAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _driverAnimController.dispose();
    _sheetController.dispose();
    _pickupController.dispose();
    _dropoffController.dispose();
    _errandDetailsController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _notesController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  void _recenterMap() {
    setState(() => _isLocatingMap = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isLocatingMap = false;
        _mapPanOffset = Offset.zero;
        _mapZoomScale = 1.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم ضبط التمركز على موقعك في جرجا 🎯'),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

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

  final List<Map<String, String>> _availableCaptains = const [
    {
      'name': 'كابتن محمود السوهاجي',
      'phone': '01098765432',
      'vehicle': 'دراجة نارية هوائية سريعة',
      'rating': '4.9 ★ (140 رحلة)',
      'eta': 'خلال 5 دقائق',
    },
    {
      'name': 'كابتن أحمد علي عبد الرحيم',
      'phone': '01123456789',
      'vehicle': 'سكوتير مرسول اكسبريس',
      'rating': '4.95 ★ (230 رحلة)',
      'eta': 'خلال 4 دقائق',
    },
    {
      'name': 'كابتن مصطفى طه الفولي',
      'phone': '01234567890',
      'vehicle': 'دراجة نارية سوداء',
      'rating': '4.85 ★ (95 رحلة)',
      'eta': 'خلال 7 دقائق',
    },
    {
      'name': 'كابتن كريم حسن (جرجا)',
      'phone': '01512345678',
      'vehicle': 'تروسيكل شحنات أمانات',
      'rating': '4.9 ★ (310 رحلة)',
      'eta': 'خلال 8 دقائق',
    },
  ];

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

    final randomCaptain = _availableCaptains[
        DateTime.now().millisecondsSinceEpoch % _availableCaptains.length];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFF0F172A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FutureBuilder(
                  future: Future.delayed(const Duration(milliseconds: 1400)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          const SizedBox(
                            width: 46,
                            height: 46,
                            child: CircularProgressIndicator(
                              color: Color(0xFFD4FF00),
                              strokeWidth: 3,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'جاري البحث عن أقرب كابتن مرسول...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'إرسال الطلب لكافة الكباتن القريبين بمدينة جرجا',
                            style:
                                TextStyle(color: Colors.white60, fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }

                    // MATCHED & ACCEPTED BY CAPTAIN
                    appState.placeParcelOrder(
                      pickup: _pickupController.text,
                      dropoff: _dropoffController.text.isNotEmpty
                          ? _dropoffController.text
                          : 'حسب توجيه العميل',
                      category: categoryDesc,
                      fee: _calculatedFee,
                      captainName: randomCaptain['name'],
                      captainPhone: randomCaptain['phone'],
                    );

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'تم قبول طلبك وتأكيد الكابتن!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ACCEPTED CAPTAIN DETAILS CARD
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFD4FF00)
                                  .withValues(alpha: 0.3),
                            ),
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          randomCaptain['name']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${randomCaptain['vehicle']} • ${randomCaptain['rating']}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white12, height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time_rounded,
                                          color: Color(0xFFD4FF00), size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        'وصول للاستلام ${randomCaptain['eta']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${_calculatedFee.toStringAsFixed(0)} ج.م',
                                    style: const TextStyle(
                                      color: Color(0xFFD4FF00),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4FF00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'متابعة وتتبع الكابتن مباشرة',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
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
            // 1. FULL-SCREEN INTERACTIVE VECTOR MAP CANVAS (BACKGROUND)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 65,
              child: GestureDetector(
                onScaleUpdate: (details) {
                  setState(() {
                    _mapPanOffset += details.focalPointDelta;
                    if (details.scale != 1.0) {
                      _mapZoomScale =
                          (_mapZoomScale * details.scale).clamp(0.7, 2.8);
                    }
                  });
                },
                child: Stack(
                  children: [
                    // Animated Interactive Vector Map Canvas Painter
                    AnimatedBuilder(
                      animation: _driverAnimController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size.infinite,
                          painter: _ParcelRouteMapPainter(
                            driverProgress: _driverAnimController.value,
                            panOffset: _mapPanOffset,
                            zoomScale: _mapZoomScale,
                          ),
                        );
                      },
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
                              Colors.black.withValues(alpha: 0.25),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // FLOATING MAP ZOOM & GPS CONTROLS (RIGHT SIDE)
                    Positioned(
                      left: 14,
                      bottom: 85,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Zoom In (+) Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _mapZoomScale =
                                    (_mapZoomScale + 0.25).clamp(0.7, 2.8);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.add_rounded,
                                  color: Color(0xFFD4FF00), size: 18),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Zoom Out (-) Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _mapZoomScale =
                                    (_mapZoomScale - 0.25).clamp(0.7, 2.8);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.remove_rounded,
                                  color: Color(0xFFD4FF00), size: 18),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // GPS Recenter Button
                          GestureDetector(
                            onTap: _recenterMap,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: _isLocatingMap
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFD4FF00),
                                      ),
                                    )
                                  : const Icon(Icons.my_location_rounded,
                                      color: Color(0xFFD4FF00), size: 18),
                            ),
                          ),
                        ],
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
          ),

            // 2. DRAGGABLE & PULLABLE SLIDING BOTTOM SHEET
            DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.64,
              minChildSize: 0.14,
              maxChildSize: 0.92,
              snap: true,
              snapSizes: const [0.14, 0.64, 0.92],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 20,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // A. SCROLLABLE CONTENT WITH CONTROLLER
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Sheet Handle Indicator Bar (Tap to toggle pull-down)
                              GestureDetector(
                                onTap: () {
                                  if (_sheetController.isAttached) {
                                    final target = _sheetController.size > 0.3
                                        ? 0.14
                                        : 0.64;
                                    _sheetController.animateTo(
                                      target,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.transparent,
                                  width: double.infinity,
                                  child: Center(
                                    child: Container(
                                      width: 48,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.grey.withValues(alpha: 0.4),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

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
                                              .withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.radar_rounded,
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
                                              '12 كابتن مرسول متوفرون بجرجا ⚡',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              'يتم تأكيد وتحديد السائق فور طلبك مباشرة',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white70,
                                              ),
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
              );
            },
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
// Custom Map Canvas Painter for Parcel Delivery Screen Header
class _ParcelRouteMapPainter extends CustomPainter {
  final double driverProgress;
  final Offset panOffset;
  final double zoomScale;

  _ParcelRouteMapPainter({
    required this.driverProgress,
    required this.panOffset,
    required this.zoomScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Apply pan & zoom relative to center
    canvas.translate(size.width / 2 + panOffset.dx, size.height / 2 + panOffset.dy);
    canvas.scale(zoomScale);
    canvas.translate(-size.width / 2, -size.height / 2);

    // Light Map Ground
    final bgPaint = Paint()..color = const Color(0xFFE2E8F0);
    canvas.drawRect(
        Rect.fromLTWH(
            -size.width * 0.5, -size.height * 0.5, size.width * 2, size.height * 2),
        bgPaint);

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
      ..strokeWidth = 38
      ..style = PaintingStyle.stroke;

    final riverPath = Path()
      ..moveTo(size.width * 0.88, -50)
      ..cubicTo(
        size.width * 0.95,
        size.height * 0.4,
        size.width * 0.82,
        size.height * 0.7,
        size.width * 0.9,
        size.height + 50,
      );
    canvas.drawPath(riverPath, riverPaint);

    // Draw Girga Street Network
    final path1 = Path()
      ..moveTo(-50, size.height * 0.35)
      ..lineTo(size.width + 50, size.height * 0.42);

    final path2 = Path()
      ..moveTo(size.width * 0.45, -50)
      ..lineTo(size.width * 0.52, size.height + 50);

    final path3 = Path()
      ..moveTo(-50, size.height * 0.7)
      ..lineTo(size.width + 50, size.height * 0.65);

    canvas.drawPath(path1, mainRoadPaint);
    canvas.drawPath(path2, roadPaint);
    canvas.drawPath(path3, roadPaint);

    // DRAW STREET NAMES & LANDMARKS
    _drawText(canvas, 'شارع المحطة', Offset(size.width * 0.12, size.height * 0.30),
        Colors.black54, 10, true);
    _drawText(canvas, 'ميدان النهضة', Offset(size.width * 0.60, size.height * 0.68),
        Colors.black54, 10, true);
    _drawText(canvas, 'شارع الأهرام', Offset(size.width * 0.48, size.height * 0.15),
        Colors.black45, 9, false);
    _drawText(canvas, 'طريق الكورنيش', Offset(size.width * 0.78, size.height * 0.45),
        Colors.blue.shade700, 9, true);

    // DRAW ROUTE POLYLINE (From Pickup to Dropoff)
    final routePath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.38)
      ..lineTo(size.width * 0.45, size.height * 0.38)
      ..lineTo(size.width * 0.45, size.height * 0.62)
      ..lineTo(size.width * 0.72, size.height * 0.62);

    final routeLinePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(routePath, routeLinePaint);

    // PICKUP GREEN DOT 🟢 & BADGE
    final startOffset = Offset(size.width * 0.25, size.height * 0.38);
    final startCirclePaint = Paint()..color = const Color(0xFFD4FF00);
    final startBorderPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(startOffset, 10, startCirclePaint);
    canvas.drawCircle(startOffset, 10, startBorderPaint);
    _drawBadge(canvas, 'الاستلام 🟢', Offset(startOffset.dx, startOffset.dy - 22),
        const Color(0xFF0F172A), Colors.white);

    // DROPOFF RED DOT 🔴 & BADGE
    final endOffset = Offset(size.width * 0.72, size.height * 0.62);
    final endCirclePaint = Paint()..color = const Color(0xFFEF4444);

    canvas.drawCircle(endOffset, 10, endCirclePaint);
    canvas.drawCircle(endOffset, 10, startBorderPaint);
    _drawBadge(canvas, 'التسليم 🔴', Offset(endOffset.dx, endOffset.dy - 22),
        const Color(0xFFEF4444), Colors.white);

    // LIVE MOVING COURIER MOTORCYCLE MARKER 🛵
    final pathMetrics = routePath.computeMetrics().first;
    final currentDistance = pathMetrics.length * driverProgress;
    final tangent = pathMetrics.getTangentForOffset(currentDistance);
    if (tangent != null) {
      final currentPos = tangent.position;

      // Pulse ring around driver position
      final pulsePaint = Paint()
        ..color = const Color(0xFF0EA5E9).withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPos, 22, pulsePaint);

      // Driver icon circle background
      final driverBgPaint = Paint()..color = const Color(0xFF0F172A);
      canvas.drawCircle(currentPos, 14, driverBgPaint);
      final driverBorderPaint = Paint()
        ..color = const Color(0xFFD4FF00)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(currentPos, 14, driverBorderPaint);

      // Draw Driver Badge
      _drawBadge(canvas, 'كابتن مرسول 🛵',
          Offset(currentPos.dx, currentPos.dy + 24), const Color(0xFF0EA5E9), Colors.white);
    }

    canvas.restore();
  }

  void _drawBadge(
      Canvas canvas, String text, Offset center, Color bg, Color textColor) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: textColor,
        fontSize: 9,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();

    final bgRect = Rect.fromCenter(
      center: center,
      width: textPainter.width + 12,
      height: textPainter.height + 6,
    );
    final bgPaint = Paint()..color = bg;
    canvas.drawRRect(
        RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), bgPaint);
    textPainter.paint(
        canvas,
        Offset(
            center.dx - textPainter.width / 2, center.dy - textPainter.height / 2));
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color,
      double fontSize, bool bold) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _ParcelRouteMapPainter oldDelegate) {
    return oldDelegate.driverProgress != driverProgress ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.zoomScale != zoomScale;
  }
}
