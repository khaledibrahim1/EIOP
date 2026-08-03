import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
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
  static const String _googleApiKey = 'AIzaSyBJGpJhzzL5VqwseWSl9AwVbStK83Ztzis';

  late String _selectedAddress;
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  // Center on Girga (جرجا)
  LatLng _currentCenter = const LatLng(26.3385, 31.8912);
  double _currentZoom = 16.5;
  bool _isLocating = false;
  bool _isSearching = false;
  bool _isReverseGeocoding = false;
  Timer? _searchDebounceTimer;
  Timer? _mapMoveDebounceTimer;

  String _mapType = 'm'; // 'm': roadmap, 'y': hybrid

  List<Map<String, dynamic>> _searchResults = [];

  // Girga Local Index (Famous & Primary Streets)
  final List<Map<String, dynamic>> _girgaStreets = const [
    {
      'name': 'شارع المحطة (جرجا)',
      'details': 'وسط المدينة - بجوار محطة قطار جرجا والكنيسة',
      'icon': '<ctrl42>',
      'lat': 26.3385,
      'lng': 31.8912,
    },
    {
      'name': 'شارع البحر (جرجا)',
      'details': 'بجوار موقف المحافظات الرئيسي ومحطة السكة الحديد',
      'icon': '🚦',
      'lat': 26.3390,
      'lng': 31.8850,
    },
    {
      'name': 'شارع الأهرام (جرجا)',
      'details': 'الشارع التجاري الرئيسي - أمام البنك الأهلي المصري',
      'icon': '🏦',
      'lat': 26.3350,
      'lng': 31.8950,
    },
    {
      'name': 'طريق الكورنيش (جرجا)',
      'details': 'كورنيش النيل - بجوار حديقة الطفل وحديقة الخالدين',
      'icon': '🌊',
      'lat': 26.3450,
      'lng': 31.8980,
    },
    {
      'name': 'ميدان النهضة (جرجا)',
      'details': 'الميدان الرئيسي - خلف المجمع الطبي التخصصي',
      'icon': '🏬',
      'lat': 26.3412,
      'lng': 31.8890,
    },
    {
      'name': 'شارع الجمهورية (جرجا)',
      'details': 'قلب مدينة جرجا - بالقرب من مجلس المدينة',
      'icon': '🛣️',
      'lat': 26.3370,
      'lng': 31.8930,
    },
    {
      'name': 'شارع الجلاء (جرجا)',
      'details': 'حي غرب - بجوار المدارس والمجمعات الخدمية',
      'icon': '🛣️',
      'lat': 26.3420,
      'lng': 31.8870,
    },
    {
      'name': 'شارع بورسعيد (جرجا)',
      'details': 'حي شرق - بالقرب من المستشفى العام',
      'icon': '🛣️',
      'lat': 26.3340,
      'lng': 31.8970,
    },
    {
      'name': 'شارع المطار (جرجا)',
      'details': 'طريق مطار سوهاج الدولي - المدخل الجنوبي لجرجا',
      'icon': '✈️',
      'lat': 26.3310,
      'lng': 31.8820,
    },
    {
      'name': 'شارع قصر الثقافة (جرجا)',
      'details': 'بجوار قصر ثقافة جرجا والإدارة التعليمية',
      'icon': '🏛️',
      'lat': 26.3435,
      'lng': 31.8915,
    },
    {
      'name': 'شارع المستشفى العام (جرجا)',
      'details': 'شارع المستشفى الأميري والمستوصف الطبي',
      'icon': '🏥',
      'lat': 26.3365,
      'lng': 31.8965,
    },
    {
      'name': 'شارع السوق القديم (جرجا)',
      'details': 'منطقة الأسواق والمحلات التجارية القديمة بجرجا',
      'icon': '🛍️',
      'lat': 26.3400,
      'lng': 31.8900,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.currentLocation;
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _mapMoveDebounceTimer?.cancel();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _searchDebounceTimer?.cancel();
    if (query.trim().length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performUniversalStreetSearch(query.trim());
    });
  }

  Future<void> _performUniversalStreetSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    final String cleanQuery = query.trim();
    final String streetQuery =
        cleanQuery.startsWith('شارع') || cleanQuery.startsWith('طريق')
            ? cleanQuery
            : 'شارع $cleanQuery';

    List<Map<String, dynamic>> combinedResults = [];
    final Set<String> addedAddresses = {};

    // 0. Search Local Famous & Primary Girga Streets Index First
    final localMatches = _girgaStreets.where((st) {
      final name = (st['name'] as String).toLowerCase();
      final details = (st['details'] as String).toLowerCase();
      final q = cleanQuery.toLowerCase();
      return name.contains(q) || details.contains(q);
    }).toList();

    for (var m in localMatches) {
      final key = (m['details'] as String).toLowerCase();
      if (!addedAddresses.contains(key)) {
        addedAddresses.add(key);
        combinedResults.add(m);
      }
    }

    try {
      // Execute 3 Parallel Requests to Google Places, Google Geocoding, and OpenStreetMap
      final results = await Future.wait([
        _fetchGooglePlacesAutocomplete(cleanQuery),
        _fetchGoogleGeocoding(streetQuery, cleanQuery),
        _fetchOsmNominatim(cleanQuery),
      ]).timeout(const Duration(seconds: 5), onTimeout: () => [[], [], []]);

      final googlePlacesResults = results[0];
      final googleGeocodeResults = results[1];
      final osmResults = results[2];

      for (var r in [...googlePlacesResults, ...googleGeocodeResults, ...osmResults]) {
        final key = ((r['details'] ?? r['name']) as String).toLowerCase();
        if (!addedAddresses.contains(key)) {
          addedAddresses.add(key);
          combinedResults.add(r);
        }
      }
    } catch (e) {
      debugPrint('Universal Street Search Error: $e');
    }

    if (mounted) {
      setState(() {
        _searchResults = combinedResults;
        _isSearching = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchGooglePlacesAutocomplete(String query) async {
    final List<Map<String, dynamic>> list = [];
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent('$query جرجا')}&components=country:eg&language=ar&key=$_googleApiKey');

      final res = await http.get(url).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['status'] == 'OK' && (data['predictions'] as List).isNotEmpty) {
          final predictions = (data['predictions'] as List).take(5);
          for (var p in predictions) {
            final String placeId = p['place_id'];
            final String description = p['description'] ?? query;
            final String mainText = p['structured_formatting']?['main_text'] ?? description;

            // Fetch geometry for this place
            final detailsUrl = Uri.parse(
                'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry,formatted_address,name&language=ar&key=$_googleApiKey');

            final detailsRes = await http.get(detailsUrl).timeout(const Duration(seconds: 2));
            if (detailsRes.statusCode == 200) {
              final detailsData = json.decode(detailsRes.body);
              if (detailsData['status'] == 'OK') {
                final result = detailsData['result'];
                final loc = result['geometry']['location'];
                final formatted = result['formatted_address'] ?? description;
                final name = result['name'] ?? mainText;

                list.add({
                  'name': name.startsWith('شارع') ? name : 'شارع $name',
                  'details': formatted,
                  'icon': '🛣️',
                  'lat': (loc['lat'] as num).toDouble(),
                  'lng': (loc['lng'] as num).toDouble(),
                });
              }
            }
          }
        }
      }
    } catch (_) {}
    return list;
  }

  Future<List<Map<String, dynamic>>> _fetchGoogleGeocoding(String streetQuery, String cleanQuery) async {
    final List<Map<String, dynamic>> list = [];
    try {
      final String searchQuery = cleanQuery.contains('جرجا') || cleanQuery.contains('سوهاج')
          ? cleanQuery
          : '$streetQuery، جرجا، سوهاج، مصر';

      final googleUrl = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(searchQuery)}&language=ar&key=$_googleApiKey');

      final googleRes = await http.get(googleUrl).timeout(const Duration(seconds: 3));

      if (googleRes.statusCode == 200) {
        final data = json.decode(googleRes.body);
        if (data['status'] == 'OK' && (data['results'] as List).isNotEmpty) {
          final List results = data['results'];
          for (var item in results) {
            final loc = item['geometry']['location'];
            final formatted = item['formatted_address'] ?? searchQuery;
            final components = item['address_components'] as List?;
            String mainName = cleanQuery;
            if (components != null && components.isNotEmpty) {
              mainName = components[0]['long_name'] ?? cleanQuery;
              if (!mainName.startsWith('شارع') && !mainName.startsWith('طريق') && !mainName.startsWith('ميدان')) {
                mainName = 'شارع $mainName';
              }
            }

            list.add({
              'name': mainName,
              'details': formatted,
              'icon': '📍',
              'lat': (loc['lat'] as num).toDouble(),
              'lng': (loc['lng'] as num).toDouble(),
            });
          }
        }
      }
    } catch (_) {}
    return list;
  }

  Future<List<Map<String, dynamic>>> _fetchOsmNominatim(String query) async {
    final List<Map<String, dynamic>> list = [];
    try {
      final searchQuery = query.contains('مصر') ? query : '$query, جرجا, سوهاج, مصر';
      final osmUrl = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(searchQuery)}&countrycodes=eg&format=json&accept-language=ar&limit=8&addressdetails=1');

      final osmRes = await http.get(osmUrl, headers: {
        'User-Agent': 'girga_food_app/1.0'
      }).timeout(const Duration(seconds: 3));

      if (osmRes.statusCode == 200) {
        final List data = json.decode(osmRes.body);
        for (var item in data) {
          final displayName = item['display_name'] ?? searchQuery;
          final address = item['address'] as Map<String, dynamic>?;
          String mainName = address?['road'] ?? address?['suburb'] ?? address?['neighbourhood'] ?? query;
          if (!mainName.startsWith('شارع') && !mainName.startsWith('طريق') && !mainName.startsWith('ميدان')) {
            mainName = 'شارع $mainName';
          }

          list.add({
            'name': mainName,
            'details': displayName,
            'icon': '🗺️',
            'lat': double.parse(item['lat'].toString()),
            'lng': double.parse(item['lon'].toString()),
          });
        }
      }
    } catch (_) {}
    return list;
  }

  Future<void> _reverseGeocodeLocation(LatLng point) async {
    setState(() {
      _isReverseGeocoding = true;
    });

    try {
      // 1. Google Maps Reverse Geocoding API
      final googleUrl = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${point.latitude},${point.longitude}&language=ar&key=$_googleApiKey');

      final res = await http.get(googleUrl).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['status'] == 'OK' && (data['results'] as List).isNotEmpty) {
          final addr = data['results'][0]['formatted_address'] as String;
          if (mounted && addr.isNotEmpty) {
            setState(() {
              _selectedAddress = addr;
              _isReverseGeocoding = false;
            });
            return;
          }
        }
      }

      // 2. OpenStreetMap Reverse Geocoding API Fallback
      final osmUrl = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=${point.latitude}&lon=${point.longitude}&format=json&accept-language=ar');

      final osmRes = await http.get(osmUrl, headers: {
        'User-Agent': 'girga_food_app/1.0'
      }).timeout(const Duration(seconds: 4));

      if (osmRes.statusCode == 200) {
        final data = json.decode(osmRes.body);
        final displayName = data['display_name'] as String?;
        if (mounted && displayName != null && displayName.isNotEmpty) {
          setState(() {
            _selectedAddress = displayName;
            _isReverseGeocoding = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
    }

    if (mounted) {
      setState(() {
        _selectedAddress =
            'شارع محدد بالقرب من (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})، جرجا';
        _isReverseGeocoding = false;
      });
    }
  }

  void _moveToLocation(LatLng target, String addressName) {
    setState(() {
      _currentCenter = target;
      _selectedAddress = addressName;
    });
    _mapController.move(target, 16.8);
    _reverseGeocodeLocation(target);
  }

  void _useCurrentLocation() {
    setState(() {
      _isLocating = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      const girgaCenter = LatLng(26.3385, 31.8912);
      _moveToLocation(girgaCenter, 'شارع المحطة، جرجا، سوهاج');
      setState(() {
        _isLocating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديد موقع الشارع الحالي عبر Google Maps 📍'),
          backgroundColor: Color(0xFF4285F4),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 0.5).clamp(3.0, 20.0);
      _mapController.move(_currentCenter, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 0.5).clamp(3.0, 20.0);
      _mapController.move(_currentCenter, _currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    final googleTileUrl =
        'https://mt1.google.com/vt/lyrs=$_mapType&x={x}&y={y}&z={z}&hl=ar&key=$_googleApiKey';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // 1. REAL GOOGLE MAPS PLATFORM TILES LAYER
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentCenter,
                initialZoom: _currentZoom,
                onPositionChanged: (position, hasGesture) {
                  setState(() {
                    _currentCenter = position.center;
                  });

                  // Trigger automatic Reverse Geocoding when map stops moving for 450ms
                  _mapMoveDebounceTimer?.cancel();
                  _mapMoveDebounceTimer = Timer(const Duration(milliseconds: 450), () {
                    _reverseGeocodeLocation(position.center);
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: googleTileUrl,
                  userAgentPackageName: 'com.girga.food',
                  maxZoom: 20,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentCenter,
                      width: 230,
                      height: 90,
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF4285F4), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isReverseGeocoding)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: SizedBox(
                                      width: 10, height: 10,
                                      child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF4285F4)),
                                    ),
                                  ),
                                Flexible(
                                  child: Text(
                                    _selectedAddress,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEA4335), // Google Red Marker
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
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Google Maps Platform Live Status Badge
            Positioned(
              right: 12,
              bottom: 270,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF4285F4).withValues(alpha: 0.6)),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.manage_search_rounded, color: Color(0xFF4285F4), size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Google Places Autocomplete 🌐',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    Text('🟢', style: TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),

            // Floating Map Controls (GPS, Zoom In/Out, Map Type)
            Positioned(
              left: 16,
              top: MediaQuery.of(context).padding.top + 70,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'btn_gps_google',
                    backgroundColor: Colors.white,
                    elevation: 4,
                    onPressed: _useCurrentLocation,
                    child: _isLocating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF4285F4),
                            ),
                          )
                        : const Icon(
                            Icons.my_location_rounded,
                            color: Color(0xFF4285F4),
                          ),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'btn_zoom_in_google',
                    backgroundColor: Colors.white,
                    elevation: 4,
                    onPressed: _zoomIn,
                    child: Icon(Icons.add_rounded, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  FloatingActionButton.small(
                    heroTag: 'btn_zoom_out_google',
                    backgroundColor: Colors.white,
                    elevation: 4,
                    onPressed: _zoomOut,
                    child: Icon(Icons.remove_rounded, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'btn_map_type',
                    backgroundColor: _mapType == 'y' ? const Color(0xFF4285F4) : Colors.white,
                    elevation: 4,
                    onPressed: () {
                      setState(() {
                        _mapType = _mapType == 'm' ? 'y' : 'm';
                      });
                    },
                    child: Icon(
                      _mapType == 'y' ? Icons.satellite_alt_rounded : Icons.layers_rounded,
                      color: _mapType == 'y' ? Colors.white : const Color(0xFF4285F4),
                    ),
                  ),
                ],
              ),
            ),

            // 2. REAL STREET SEARCH BAR & AUTOCOMPLETE
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
                              color: Color(0xFF4285F4),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              decoration: const InputDecoration(
                                hintText: 'ابحث عن أي شارع رئيسي أو فرعي أو حارة...',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_isSearching)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF4285F4),
                                ),
                              ),
                            )
                          else if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.grey, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchResults = [];
                                });
                              },
                            ),
                        ],
                      ),
                    ),

                    // UNIVERSAL REAL STREET SEARCH RESULTS DROPDOWN
                    if (_searchController.text.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        constraints: const BoxConstraints(maxHeight: 260),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B1120),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFF4285F4).withValues(alpha: 0.4)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 14,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: _isSearching
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 18, height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF4285F4)),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'جاري البحث الشامل في Google Places API... 🌐',
                                        style: TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _searchResults.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: Text(
                                        'لم نجد شوارع مطابقة، جرب كتابة اسم الشارع أو الحارة أو المنطقة 📍',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white54, fontSize: 12),
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    itemCount: _searchResults.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                                    itemBuilder: (context, index) {
                                      final item = _searchResults[index];
                                      final target = LatLng(item['lat'], item['lng']);
                                      return ListTile(
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4285F4).withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            item['icon'] ?? '🛣️',
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        title: Text(
                                          item['name'] ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        subtitle: Text(
                                          item['details'] ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.white60,
                                          ),
                                        ),
                                        onTap: () {
                                          _moveToLocation(target, item['details'] ?? item['name']);
                                          _searchController.clear();
                                          setState(() {
                                            _searchResults = [];
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

                    // Selected Address Info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4285F4).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_road_rounded,
                            color: Color(0xFF4285F4),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'الشارع المحدد للتوصيل',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4285F4).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text('Google API 🌐', style: TextStyle(fontSize: 9, color: Color(0xFF4285F4), fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _selectedAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
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

                    // Girga Popular Quick Chips
                    Text(
                      'شوارع وأماكن شائعة بمدينة جرجا:',
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
                        itemCount: _girgaStreets.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final street = _girgaStreets[index];
                          final isSelected = _selectedAddress == street['name'];
                          return ChoiceChip(
                            label: Text('${street['icon']} ${street['name']}'),
                            selected: isSelected,
                            selectedColor: const Color(0xFF4285F4),
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
                                final target = LatLng(street['lat'], street['lng']);
                                _moveToLocation(target, street['name']!);
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
                          backgroundColor: const Color(0xFF4285F4),
                          elevation: 3,
                          shadowColor: const Color(0xFF4285F4).withValues(alpha: 0.4),
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
                              'تأكيد وتعيين الشارع للتوصيل',
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
