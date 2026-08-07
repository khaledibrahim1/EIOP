import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/property_item.dart';
import '../theme/app_colors.dart';
import '../widgets/property_card.dart';
import 'food_details_screen.dart';
import 'main_layout_screen.dart';

class RealEstateScreen extends StatefulWidget {
  const RealEstateScreen({super.key});

  @override
  State<RealEstateScreen> createState() => _RealEstateScreenState();
}

class _RealEstateScreenState extends State<RealEstateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  String _searchQuery = '';
  final Set<String> _favoriteIds = {'prop_1'};

  final List<String> _categories = [
    'الكل',
    'منازل',
    'مكاتب',
    'شقق',
    'محلات',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<PropertyItem> get _filteredProperties {
    return sampleProperties.where((prop) {
      bool matchesCat = true;
      if (_selectedCategory == 'منازل') {
        matchesCat = prop.type.contains('شقة') || prop.type.contains('فيلا');
      } else if (_selectedCategory == 'مكاتب') {
        matchesCat = prop.type.contains('مكتب');
      } else if (_selectedCategory == 'شقق') {
        matchesCat = prop.type.contains('شقة');
      } else if (_selectedCategory == 'محلات') {
        matchesCat = prop.type.contains('محل');
      }

      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        matchesSearch = prop.title.toLowerCase().contains(query) ||
            prop.location.toLowerCase().contains(query) ||
            prop.type.toLowerCase().contains(query);
      }

      return matchesCat && matchesSearch;
    }).toList();
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });

    final isFav = _favoriteIds.contains(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFav ? 'تم إضافة العقار إلى المفضلة ❤️' : 'تم إزالة العقار من المفضلة',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E293B),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تصفية العقارات (Filter)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'الكل';
                        _searchQuery = '';
                        _searchController.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'إعادة ضبط',
                      style: TextStyle(color: Color(0xFF8B5CF6)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'نوع العقار',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _categories
                    .map((cat) => ChoiceChip(
                          label: Text(cat),
                          selected: _selectedCategory == cat,
                          selectedColor: const Color(0xFF1E293B),
                          labelStyle: TextStyle(
                            color: _selectedCategory == cat
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = cat);
                            }
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'تطبيق النتائج',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // PROPERTY DETAILS SHEET (Matches Screen 2 & Screen 3 in Reference Image)
  void _showPropertyDetailsModal(BuildContext context, PropertyItem property) {
    final foodAdapter = FoodItem(
      id: property.id,
      title: property.title,
      restaurantId: 'real_1',
      restaurant: property.location,
      price: property.price,
      rating: property.rating,
      deliveryTime: 'معاينة فورية',
      description:
          '${property.type} • المساحة: ${property.areaSqM.toInt()}م² • ${property.bedrooms} غرف نوم • ${property.bathrooms} حمام.\n\n${property.description}',
      imagePath: property.imagePath,
      images: property.galleryPhotos.isNotEmpty
          ? property.galleryPhotos
          : [property.imagePath],
      categoryId: 'realEstate',
      options: const [
        FoodOption(
          id: 're_1',
          title: 'معاينة وحجز الإيجار',
          code: 'إيجار',
          priceOffset: 0.0,
        ),
        FoodOption(
          id: 're_2',
          title: 'عقد سنوي مفروش',
          code: 'مفروش',
          priceOffset: 1500.0,
        ),
      ],
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailsScreen(food: foodAdapter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final properties = _filteredProperties;
    final nearbyProperties = sampleProperties.reversed.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. TOP BAR (Menu / Back, Notification Bell & Profile Avatar - Matches Screen 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainLayoutScreen(),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Color(0xFF1E293B),
                                  size: 20,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                // Notification Bell Icon
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.04),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      const Icon(
                                        Icons.notifications_none_rounded,
                                        color: Color(0xFF1E293B),
                                        size: 22,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Profile Avatar
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                      'assets/images/delivery_rider.png'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 2. DISCOVER HEADLINE (Matches Screen 1 Top Heading)
                        Text(
                          'Discover',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'your new house!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 3. SEARCH BAR & DARK FILTER BUTTON (Matches Screen 1)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) {
                                    setState(() {
                                      _searchQuery = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search Places / ابحث عن مكان...',
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF8B5CF6),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => _showFilterModal(context),
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.tune_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 4. CATEGORY PILLS TABS (Matches Screen 1 Tabs: House, Office, Apartment...)
                        SizedBox(
                          height: 42,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final cat = _categories[index];
                              final isSelected = cat == _selectedCategory;
                              return ChoiceChip(
                                label: Text(cat),
                                selected: isSelected,
                                selectedColor: const Color(0xFF1E293B),
                                backgroundColor: AppColors.surface,
                                elevation: isSelected ? 4 : 0,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Colors.grey.withValues(alpha: 0.2),
                                  ),
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => _selectedCategory = cat);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 22),

                        // 5. MAIN FEATURED PROPERTIES LIST
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            final prop = properties[index];
                            return PropertyCard(
                              property: prop,
                              isFavorite: _favoriteIds.contains(prop.id),
                              onFavoriteToggle: () => _toggleFavorite(prop.id),
                              onTap: () =>
                                  _showPropertyDetailsModal(context, prop),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // 6. "PROPERTY NEARBY" HORIZONTAL CAROUSEL (Matches Screen 1 Bottom)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Property Nearby',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B5CF6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: nearbyProperties.length,
                            itemBuilder: (context, index) {
                              final prop = nearbyProperties[index];
                              return PropertyCard(
                                property: prop,
                                isCompact: true,
                                isFavorite: _favoriteIds.contains(prop.id),
                                onFavoriteToggle: () =>
                                    _toggleFavorite(prop.id),
                                onTap: () =>
                                    _showPropertyDetailsModal(context, prop),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

