import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LocationPickerScreen extends StatefulWidget {
  final String currentLocation;

  const LocationPickerScreen({
    super.key,
    required this.currentLocation,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late String _selectedAddress;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  Offset _pinOffset = const Offset(0.5, 0.45); // Relative map pin position
  bool _isLocating = false;

  // Girga Popular Areas List
  final List<Map<String, String>> _girgaAreas = const [
    {
      'name': 'مار جرجس (جرجا)',
      'details': 'شارع المحطة - بجوار كنيسة مار جرجس',
      'icon': '⛪',
      'latlng': '26.3385, 31.8912',
    },
    {
      'name': 'ميدان النهضة (جرجا)',
      'details': 'الشارع التجاري - خلف المجمع الطبي',
      'icon': '🏬',
      'latlng': '26.3412, 31.8890',
    },
    {
      'name': 'شارع الأهرام (جرجا)',
      'details': 'أمام البنك الأهلي - وسط المدينة',
      'icon': '🏦',
      'latlng': '26.3350, 31.8950',
    },
    {
      'name': 'طريق الكورنيش (جرجا)',
      'details': 'كورنيش النيل - بجوار حديقة الطفل',
      'icon': '🌊',
      'latlng': '26.3450, 31.8980',
    },
    {
      'name': 'شارع البحر (جرجا)',
      'details': 'بجوار موقف المحافظات والقطار',
      'icon': '🚂',
      'latlng': '26.3390, 31.8850',
    },
  ];

  List<Map<String, String>> _filteredAreas = [];

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.currentLocation;
    _filteredAreas = List.from(_girgaAreas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _buildingController.dispose();
    super.dispose();
  }

  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAreas = List.from(_girgaAreas);
      } else {
        _filteredAreas = _girgaAreas.where((area) {
          final name = area['name']!.toLowerCase();
          final details = area['details']!.toLowerCase();
          final q = query.toLowerCase();
          return name.contains(q) || details.contains(q);
        }).toList();
      }
    });
  }

  void _useCurrentLocation() {
    setState(() {
      _isLocating = true;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isLocating = false;
        _selectedAddress = 'موقعي الحالي (شارع المحطة، جرجا)';
        _pinOffset = const Offset(0.5, 0.48);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديد موقعك الحالي بنجاح (GPS 📍)'),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // 1. INTERACTIVE VECTOR MAP CONTAINER
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  double newX =
                      (_pinOffset.dx + details.delta.dx / 400).clamp(0.15, 0.85);
                  double newY =
                      (_pinOffset.dy + details.delta.dy / 400).clamp(0.2, 0.75);
                  _pinOffset = Offset(newX, newY);
                });
              },
              onTapDown: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localPos = box.globalToLocal(details.globalPosition);
                setState(() {
                  _pinOffset = Offset(
                    (localPos.dx / box.size.width).clamp(0.15, 0.85),
                    (localPos.dy / box.size.height).clamp(0.2, 0.75),
                  );
                });
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E7EB),
                ),
                child: CustomPaint(
                  painter: _MapCanvasPainter(pinOffset: _pinOffset),
                  child: Stack(
                    children: [
                      // CENTER MAP PIN MARKER (ANIMATED)
                      Align(
                        alignment: FractionalOffset(
                          _pinOffset.dx,
                          _pinOffset.dy,
                        ),
                        child: FractionalTranslation(
                          translation: const Offset(-0.5, -1.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Floating Address Badge on Top of Pin
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  _selectedAddress,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Red Map Pin Icon
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Floating Map Action Buttons (GPS & Zoom Controls)
                      Positioned(
                        left: 16,
                        top: MediaQuery.of(context).padding.top + 70,
                        child: Column(
                          children: [
                            FloatingActionButton.small(
                              heroTag: 'btn_gps',
                              backgroundColor: Colors.white,
                              elevation: 4,
                              onPressed: _useCurrentLocation,
                              child: _isLocating
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.my_location_rounded,
                                      color: AppColors.primary,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. TOP FLOATING APP BAR & SEARCH BAR
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Input Box
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.primary,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _filterSearch,
                              decoration: const InputDecoration(
                                hintText: 'ابحث عن عنوانك في جرجا...',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.grey, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                _filterSearch('');
                              },
                            ),
                        ],
                      ),
                    ),

                    // Search Results Autocomplete Dropdown (If searching)
                    if (_searchController.text.isNotEmpty &&
                        _filteredAreas.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: _filteredAreas.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final area = _filteredAreas[index];
                            return ListTile(
                              leading: Text(
                                area['icon']!,
                                style: const TextStyle(fontSize: 20),
                              ),
                              title: Text(
                                area['name']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                area['details']!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedAddress = area['name']!;
                                  _searchController.clear();
                                  _filteredAreas = List.from(_girgaAreas);
                                  _pinOffset = Offset(
                                    0.3 + (index * 0.12),
                                    0.4 + (index * 0.05),
                                  );
                                });
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 3. BOTTOM LOCATION CONFIRMATION CARD
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar Indicator
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Selected Address Title & Info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'الموقع المحدد للتوصيل',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _selectedAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Popular Girga Quick Location Chips
                    Text(
                      'أماكن شائعة بمدينة جرجا:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _girgaAreas.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final area = _girgaAreas[index];
                          final isSelected = _selectedAddress == area['name'];
                          return ChoiceChip(
                            label: Text('${area['icon']} ${area['name']}'),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.cardBg,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _selectedAddress = area['name']!;
                                  _pinOffset = Offset(
                                    0.3 + (index * 0.12),
                                    0.4 + (index * 0.05),
                                  );
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Confirm Location Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, _selectedAddress);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'تأكيد وتعيين موقع التوصيل',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
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
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Vector Map Canvas Painter for Girga Street Grid Simulation
class _MapCanvasPainter extends CustomPainter {
  final Offset pinOffset;

  _MapCanvasPainter({required this.pinOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE5E7EB);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final mainRoadPaint = Paint()
      ..color = const Color(0xFFFDE68A)
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    final riverPaint = Paint()
      ..color = const Color(0xFF93C5FD)
      ..strokeWidth = 40
      ..style = PaintingStyle.stroke;

    // Draw Simulated Nile River Curve on the Right
    final riverPath = Path()
      ..moveTo(size.width * 0.85, 0)
      ..cubicTo(
        size.width * 0.9,
        size.height * 0.3,
        size.width * 0.8,
        size.height * 0.7,
        size.width * 0.88,
        size.height,
      );
    canvas.drawPath(riverPath, riverPaint);

    // Main Street Grid Paths (Girga Streets)
    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width, size.height * 0.45);

    final path2 = Path()
      ..moveTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.5, size.height);

    final path3 = Path()
      ..moveTo(0, size.height * 0.65)
      ..lineTo(size.width, size.height * 0.6);

    canvas.drawPath(path1, mainRoadPaint);
    canvas.drawPath(path2, roadPaint);
    canvas.drawPath(path3, roadPaint);

    // Draw Pulse Radar Ring around active pin
    final pulsePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final pinCenter = Offset(
      size.width * pinOffset.dx,
      size.height * pinOffset.dy,
    );
    canvas.drawCircle(pinCenter, 45, pulsePaint);
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) {
    return oldDelegate.pinOffset != pinOffset;
  }
}
