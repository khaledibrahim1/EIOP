import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/cart_state.dart';
import 'location_picker_screen.dart';

class ParcelDeliveryScreen extends StatefulWidget {
  const ParcelDeliveryScreen({super.key});

  @override
  State<ParcelDeliveryScreen> createState() => _ParcelDeliveryScreenState();
}

class _ParcelDeliveryScreenState extends State<ParcelDeliveryScreen>
    with SingleTickerProviderStateMixin {
  static const String _googleApiKey = 'AIzaSyBJGpJhzzL5VqwseWSl9AwVbStK83Ztzis';

  // Map & Location state
  final MapController _mapController = MapController();
  LatLng _currentCenter = const LatLng(26.3385, 31.8912); // Girga Center
  final double _currentZoom = 15.8;
  String _mapType = 'm'; // Google Maps roadmap / hybrid

  // Service Mode: 0 = Driver / توصيل 🚗, 1 = Package / طرد 📦
  int _selectedMode = 1;

  // Service Type: 0 = ارسل طرد, 1 = اشترِ لي (مرسول), 2 = مستندات وأوراق
  final int _selectedServiceType = 0;

  // Package / Ride Option: 0 = Standard (مرسول عادي), 1 = Express (اكسبريس), 2 = Cargo (حمولات)
  int _selectedOptionIndex = 1;

  // Address Controllers
  final TextEditingController _pickupController =
      TextEditingController(text: 'شارع المحطة - بجوار البنك الأهلي (جرجا)');
  final TextEditingController _dropoffController =
      TextEditingController(text: 'ميدان النهضة - الشارع التجاري (جرجا)');
  final TextEditingController _errandDetailsController = TextEditingController();
  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _recipientPhoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Coordinates
  LatLng _pickupPoint = const LatLng(26.3385, 31.8912);
  LatLng _dropoffPoint = const LatLng(26.3420, 31.8870);

  // Accepted Order State & Route Simulation
  bool _isOrderAccepted = false;
  bool _isSearchingCaptain = false;
  Map<String, String>? _acceptedCaptain;

  late AnimationController _driverAnimController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  // Styling Constants matching dark design mockup
  static const darkBgColor = Color(0xFF0B1120);
  static const darkCardColor = Color(0xFF121A2D);
  static const vibrantLime = Color(0xFFA3E635);
  static const googleBlue = Color(0xFF4285F4);
  static const textWhite = Colors.white;
  static const textMuted = Color(0xFF94A3B8);

  // Active Available Orders Plotted on Map
  final List<Map<String, dynamic>> _mapOrders = [
    {
      'id': '#PRCL-901',
      'title': 'طرد مستندات وأوراق أمانة 📜',
      'pickupName': 'شارع المحطة (جرجا)',
      'dropoffName': 'ميدان النهضة',
      'pickup': const LatLng(26.3385, 31.8912),
      'dropoff': const LatLng(26.3420, 31.8870),
      'price': 25.0,
      'eta': '5 دقائق',
    },
    {
      'id': '#PRCL-714',
      'title': 'طلب شراء أدوية ومستلزمات 💊',
      'pickupName': 'شارع المستشفى العام',
      'dropoffName': 'شارع البحر',
      'pickup': const LatLng(26.3365, 31.8965),
      'dropoff': const LatLng(26.3390, 31.8850),
      'price': 30.0,
      'eta': '8 دقائق',
    },
    {
      'id': '#PRCL-550',
      'title': 'شحنة ملابس وأقمشة 👕',
      'pickupName': 'شارع الأهرام التجاري',
      'dropoffName': 'شارع المطار',
      'pickup': const LatLng(26.3350, 31.8950),
      'dropoff': const LatLng(26.3310, 31.8820),
      'price': 35.0,
      'eta': '10 دقائق',
    },
  ];

  // Ride & Package Option Specifications
  final List<Map<String, dynamic>> _rideOptions = const [
    {
      'title': 'Standard (مرسول عادي)',
      'subtitle': '3 min • حمولة شخصية',
      'price': 20.0,
      'tag': '',
      'icon': Icons.two_wheeler_outlined,
      'seats': 1,
    },
    {
      'title': 'Comfort (اكسبريس سريع)',
      'subtitle': '3 min • الأكثر طلبًا ⚡',
      'price': 25.0,
      'tag': 'الأسرع',
      'icon': Icons.bolt_outlined,
      'seats': 2,
    },
    {
      'title': 'Luxury (سيارة حمولات)',
      'subtitle': '5 min • حمولة كبيرة',
      'price': 35.0,
      'tag': 'كبير',
      'icon': Icons.local_shipping_outlined,
      'seats': 4,
    },
  ];

  @override
  void initState() {
    super.initState();
    _driverAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _driverAnimController.dispose();
    _sheetController.dispose();
    _mapController.dispose();
    _pickupController.dispose();
    _dropoffController.dispose();
    _errandDetailsController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _swapLocations() {
    setState(() {
      final tempText = _pickupController.text;
      _pickupController.text = _dropoffController.text;
      _dropoffController.text = tempText;

      final tempPoint = _pickupPoint;
      _pickupPoint = _dropoffPoint;
      _dropoffPoint = tempPoint;
    });
  }

  void _pickLocation(bool isPickup) async {
    final currentText =
        isPickup ? _pickupController.text : _dropoffController.text;
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          currentLocation:
              currentText.isNotEmpty ? currentText : 'شارع المحطة - جرجا',
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        if (isPickup) {
          _pickupController.text = result;
        } else {
          _dropoffController.text = result;
        }
      });
    }
  }

  void _recenterMap() {
    _mapController.move(_pickupPoint, 16.5);
  }

  void _submitParcelOrder() {
    if (_dropoffController.text.trim().isEmpty && _selectedServiceType != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('برجاء تحديد موقع تسليم الشحنة أولاً 📍'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSearchingCaptain = true;
    });

    // Simulate searching captain for 1.5s then accept & show route on map
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      final captain = {
        'name': 'كابتن محمود السوهاجي',
        'phone': '01098765432',
        'vehicle': 'Honda CRV • أسود',
        'plate': 'AB6299ZG',
        'rating': '4.9 ★',
        'eta': '3 min',
        'safety': '98% user safety rating',
      };

      appState.placeParcelOrder(
        pickup: _pickupController.text,
        dropoff: _dropoffController.text.isNotEmpty
            ? _dropoffController.text
            : 'حسب التوجيه',
        category: _rideOptions[_selectedOptionIndex]['title'],
        fee: _rideOptions[_selectedOptionIndex]['price'],
        captainName: captain['name'],
        captainPhone: captain['phone'],
      );

      setState(() {
        _isSearchingCaptain = false;
        _isOrderAccepted = true;
        _acceptedCaptain = captain;
      });

      // Move camera to fit both pickup & dropoff route
      _mapController.move(
        LatLng(
          (_pickupPoint.latitude + _dropoffPoint.latitude) / 2,
          (_pickupPoint.longitude + _dropoffPoint.longitude) / 2,
        ),
        15.2,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم قبول الطلب ورسم مسار التوصيل المباشر على الخريطة 🗺️⚡'),
          backgroundColor: vibrantLime,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  List<LatLng> get _routePoints {
    return [
      _pickupPoint,
      LatLng(
        (_pickupPoint.latitude * 0.6 + _dropoffPoint.latitude * 0.4),
        (_pickupPoint.longitude * 0.7 + _dropoffPoint.longitude * 0.3),
      ),
      LatLng(
        (_pickupPoint.latitude * 0.3 + _dropoffPoint.latitude * 0.7),
        (_pickupPoint.longitude * 0.4 + _dropoffPoint.longitude * 0.6),
      ),
      _dropoffPoint,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final googleTileUrl =
        'https://mt1.google.com/vt/lyrs=$_mapType&x={x}&y={y}&z={z}&hl=ar&key=$_googleApiKey';

    return Scaffold(
      backgroundColor: darkBgColor,
      body: Stack(
        children: [
          // =========================================================
          // 1. FULL-SCREEN ALWAYS ACTIVE GOOGLE MAP CANVAS (BACKGROUND)
          // =========================================================
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentCenter,
                initialZoom: _currentZoom,
                onPositionChanged: (pos, hasGesture) {
                  if (hasGesture) {
                    setState(() {
                      _currentCenter = pos.center;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: googleTileUrl,
                  userAgentPackageName: 'com.girga.food',
                  maxZoom: 20,
                ),

                // LIVE ROUTE POLYLINE (Drawn on Google Map when accepted!)
                if (_isOrderAccepted)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 6.0,
                        color: vibrantLime,
                        borderColor: darkBgColor,
                        borderStrokeWidth: 2.0,
                      ),
                    ],
                  ),

                // MARKERS LAYER ON MAP
                MarkerLayer(
                  markers: [
                    // PICKUP MARKER 🟢
                    Marker(
                      point: _pickupPoint,
                      width: 140,
                      height: 70,
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: darkBgColor,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: vibrantLime, width: 1.5),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.my_location_rounded,
                                    color: vibrantLime, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'الاستلام 🟢',
                                  style: TextStyle(
                                    color: textWhite,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: vibrantLime,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: darkBgColor, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black45, blurRadius: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // DROPOFF MARKER 🔴
                    Marker(
                      point: _dropoffPoint,
                      width: 140,
                      height: 70,
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: darkBgColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(0xFFEF4444), width: 1.5),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.location_on_rounded,
                                    color: Color(0xFFEF4444), size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'التسليم 🔴',
                                  style: TextStyle(
                                    color: textWhite,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: darkBgColor, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black45, blurRadius: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // LIVE DRIVER MARKER ALONG THE ROUTE WHEN ACCEPTED 🛵
                    if (_isOrderAccepted)
                      Marker(
                        point: LatLng(
                          _pickupPoint.latitude +
                              (_dropoffPoint.latitude - _pickupPoint.latitude) *
                                  _driverAnimController.value,
                          _pickupPoint.longitude +
                              (_dropoffPoint.longitude - _pickupPoint.longitude) *
                                  _driverAnimController.value,
                        ),
                        width: 120,
                        height: 60,
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: vibrantLime,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, blurRadius: 8),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.directions_car_rounded,
                                  color: darkBgColor, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'AB6299ZG • 3 min',
                                style: TextStyle(
                                  color: darkBgColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // OTHER ACTIVE PARCEL ORDERS PLOTTED ON MAP
                    if (!_isOrderAccepted)
                      ..._mapOrders.map((ord) {
                        return Marker(
                          point: ord['pickup'] as LatLng,
                          width: 130,
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _pickupController.text = ord['pickupName'];
                                _dropoffController.text = ord['dropoffName'];
                                _pickupPoint = ord['pickup'];
                                _dropoffPoint = ord['dropoff'];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: darkCardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: googleBlue.withValues(alpha: 0.8)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.inventory_2_rounded,
                                      color: googleBlue, size: 14),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${ord['id']} • ${(ord['price'] as double).toStringAsFixed(0)}ج',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: textWhite,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ],
            ),
          ),

          // Map Dark Vignette Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      darkBgColor.withValues(alpha: 0.75),
                      Colors.transparent,
                      darkBgColor.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Map Floating Control Buttons (GPS Recenter & Layer Toggle)
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 190,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'btn_gps_delivery',
                  backgroundColor: darkCardColor,
                  onPressed: _recenterMap,
                  child: const Icon(Icons.my_location_rounded,
                      color: vibrantLime),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'btn_map_layer_delivery',
                  backgroundColor: darkCardColor,
                  onPressed: () {
                    setState(() {
                      _mapType = _mapType == 'm' ? 'y' : 'm';
                    });
                  },
                  child: Icon(
                    _mapType == 'y'
                        ? Icons.satellite_alt_rounded
                        : Icons.layers_rounded,
                    color: vibrantLime,
                  ),
                ),
              ],
            ),
          ),

          // =========================================================
          // 2. TOP FLOATING BAR (Dark Mockup Header & Input Capsule)
          // =========================================================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Back button, Avatar & Header Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (Navigator.canPop(context))
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: darkCardColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_back_rounded,
                                    color: textWhite, size: 20),
                              ),
                            ),
                          const SizedBox(width: 12),
                          const Text(
                            'Where do you want to go?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: textWhite,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: vibrantLime, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFFEF08A),
                          child: Text('👦🏻', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // DUAL INPUT CAPSULE WITH SWAP ICON (MATCHING MOCKUP IMAGE)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: darkCardColor.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Pickup Location Input Row
                        GestureDetector(
                          onTap: () => _pickLocation(true),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1E293B),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on_rounded,
                                    color: vibrantLime, size: 16),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _pickupController.text.isNotEmpty
                                      ? _pickupController.text
                                      : 'Add a pick-up location',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: textWhite,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Divider with Swap Center Icon 🔄
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            const Divider(color: Colors.white12, height: 18),
                            GestureDetector(
                              onTap: _swapLocations,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: darkBgColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white24, width: 1),
                                ),
                                child: const Icon(
                                  Icons.swap_vert_rounded,
                                  color: vibrantLime,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Dropoff Location Input Row
                        GestureDetector(
                          onTap: () => _pickLocation(false),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1E293B),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on_rounded,
                                    color: Color(0xFFEF4444), size: 16),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _dropoffController.text.isNotEmpty
                                      ? _dropoffController.text
                                      : 'Add your destination',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: _dropoffController.text.isNotEmpty
                                        ? textWhite
                                        : textMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =========================================================
          // 3. DRAGGABLE BOTTOM SHEET (MATCHING MOCKUP DESIGN STATES)
          // =========================================================
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: _isOrderAccepted ? 0.46 : 0.52,
            minChildSize: 0.16,
            maxChildSize: 0.88,
            snap: true,
            snapSizes: const [0.16, 0.46, 0.88],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: darkCardColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 24,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Sheet Handle Drag Indicator
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 6),
                      width: 42,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
                        child: _isOrderAccepted
                            ? _buildAcceptedOrderSheetContent()
                            : _buildBookingSheetContent(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // UNACCEPTED STATE: BOOKING & MODE SELECTION SHEET CONTENT
  // =========================================================
  Widget _buildBookingSheetContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Selector Pills (Driver vs Package)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: darkBgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMode = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          _selectedMode == 0 ? vibrantLime : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_car_rounded,
                            color: _selectedMode == 0 ? darkBgColor : textWhite,
                            size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Driver',
                          style: TextStyle(
                            color:
                                _selectedMode == 0 ? darkBgColor : textWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMode = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          _selectedMode == 1 ? vibrantLime : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_rounded,
                            color: _selectedMode == 1 ? darkBgColor : textWhite,
                            size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Package',
                          style: TextStyle(
                            color:
                                _selectedMode == 1 ? darkBgColor : textWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // CAR & RIDE OPTION HORIZONTAL CARDS (MATCHING MOCKUP IMAGE)
        SizedBox(
          height: 125,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _rideOptions.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final opt = _rideOptions[index];
              final isSel = _selectedOptionIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedOptionIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 145,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSel ? vibrantLime : darkBgColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSel
                          ? vibrantLime
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            opt['title'].toString().split(' ')[0],
                            style: TextStyle(
                              color: isSel ? darkBgColor : textWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Icon(
                            opt['icon'] as IconData,
                            color: isSel ? darkBgColor : vibrantLime,
                            size: 20,
                          ),
                        ],
                      ),
                      Text(
                        opt['subtitle'].toString(),
                        style: TextStyle(
                          color: isSel ? darkBgColor.withValues(alpha: 0.8) : textMuted,
                          fontSize: 10,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_rounded,
                                  size: 12,
                                  color: isSel
                                      ? darkBgColor
                                      : textMuted),
                              const SizedBox(width: 2),
                              Text(
                                '${opt['seats']}',
                                style: TextStyle(
                                  color: isSel
                                      ? darkBgColor
                                      : textMuted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${(opt['price'] as double).toStringAsFixed(0)}',
                            style: TextStyle(
                              color: isSel ? darkBgColor : textWhite,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),

        // SUBMIT & CONFIRM BUTTON
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: vibrantLime,
              elevation: 4,
              shadowColor: vibrantLime.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            onPressed: _isSearchingCaptain ? null : _submitParcelOrder,
            child: _isSearchingCaptain
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: darkBgColor,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'تأكيد وحجز التوصيل ⚡',
                    style: TextStyle(
                      color: darkBgColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // ACCEPTED STATE SHEET CONTENT (MATCHING IMAGE 2 & 3 IN MOCKUP)
  // =========================================================
  Widget _buildAcceptedOrderSheetContent() {
    final cap = _acceptedCaptain ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Arrival Notification Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: vibrantLime,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'The driver will arrive in',
                style: TextStyle(
                  color: darkBgColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: darkBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  cap['eta'] ?? '3 min',
                  style: const TextStyle(
                    color: vibrantLime,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Driver Info Card (Matching Screenshot)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: darkBgColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFFEF08A),
                    child: Text('👨🏻‍✈️', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cap['name'] ?? 'كابتن محمود السوهاجي',
                          style: const TextStyle(
                            color: textWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cap['vehicle'] ?? 'Honda CRV',
                          style: const TextStyle(
                            color: textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: textWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cap['plate'] ?? 'AB6299ZG',
                      style: const TextStyle(
                        color: darkBgColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFF59E0B), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        cap['rating'] ?? '4.9 ★',
                        style: const TextStyle(
                          color: textWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$${_rideOptions[_selectedOptionIndex]['price']}',
                    style: const TextStyle(
                      color: vibrantLime,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Action Buttons Row (Chat with Driver & Call)
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vibrantLime,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('فتح الدردشة المباشرة مع الكابتن 💬'),
                        backgroundColor: googleBlue,
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_rounded,
                      color: darkBgColor, size: 18),
                  label: const Text(
                    'Chat with driver',
                    style: TextStyle(
                      color: darkBgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('جاري الاتصال بالكابتن: ${cap['phone']} 📞'),
                    backgroundColor: vibrantLime,
                  ),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: darkBgColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_rounded,
                    color: vibrantLime, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
