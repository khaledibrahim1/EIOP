import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/service_type.dart';
import '../theme/app_colors.dart';
import 'electronics_screen.dart';
import 'fashion_screen.dart';
import 'jobs_screen.dart';
import 'parcel_delivery_screen.dart';
import 'pharmacy_screen.dart';
import 'real_estate_screen.dart';
import 'restaurants_screen.dart';
import 'supermarket_screen.dart';

class CategoryCardItem {
  final ServiceCategory category;
  final String title;
  final String tagText;
  final String rating;
  final Color bgColor;
  final String imagePath;

  const CategoryCardItem({
    required this.category,
    required this.title,
    required this.tagText,
    required this.rating,
    required this.bgColor,
    required this.imagePath,
  });
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _searchQuery = '';
  final Set<ServiceCategory> _favoriteCategories = {
    ServiceCategory.food,
    ServiceCategory.pharmacy,
  };

  final List<CategoryCardItem> _categories = const [
    CategoryCardItem(
      category: ServiceCategory.food,
      title: 'مطاعم وجبات',
      tagText: 'من 20 ج.م',
      rating: '4.9',
      bgColor: Color(0xFFFFD7C4), // Peach Soft Orange
      imagePath: 'assets/images/cat_burger.png',
    ),
    CategoryCardItem(
      category: ServiceCategory.supermarket,
      title: 'سوبر ماركت',
      tagText: 'توصيل 15 د',
      rating: '4.8',
      bgColor: Color(0xFFD9F99D), // Fresh Light Lime
      imagePath: 'assets/images/cat_supermarket.png',
    ),
    CategoryCardItem(
      category: ServiceCategory.pharmacy,
      title: 'صيدليات ورعاية',
      tagText: 'خدمة 24/7',
      rating: '4.9',
      bgColor: Color(0xFFBAE6FD), // Soft Cyan Sky Blue
      imagePath: 'assets/images/cat_pharmacy.png',
    ),
    CategoryCardItem(
      category: ServiceCategory.parcelDelivery,
      title: 'مرسول طرود',
      tagText: 'توصيل سريع',
      rating: '5.0',
      bgColor: Color(0xFFBFDBFE), // Periwinkle Blue
      imagePath: 'assets/images/cat_parcel.png',
    ),
    CategoryCardItem(
      category: ServiceCategory.electronics,
      title: 'إلكترونيات',
      tagText: 'خصم 15%',
      rating: '4.9',
      bgColor: Color(0xFFDDD6FE), // Soft Lavender Purple
      imagePath: 'assets/images/cat_electronics.png',
    ),
    CategoryCardItem(
      category: ServiceCategory.fashion,
      title: 'أزياء وموضة',
      tagText: 'تشكيلة جديدة',
      rating: '4.8',
      bgColor: Color(0xFFFBCFE8), // Warm Soft Rose
      imagePath: 'assets/images/cat_fashion.png',
    ),
    CategoryCardItem(
      category: ServiceCategory.realEstate,
      title: 'عقارات وشقق',
      tagText: 'بدون وسيط',
      rating: '4.9',
      bgColor: Color(0xFFFEF08A), // Warm Golden Amber
      imagePath: 'assets/images/cat_realestate.png',
    ),
    CategoryCardItem(
      category: ServiceCategory.jobs,
      title: 'وظائف اليوم',
      tagText: 'فرص عمل',
      rating: '4.7',
      bgColor: Color(0xFFFFCDC2), // Soft Warm Coral
      imagePath: 'assets/images/cat_jobs.png',
    ),
  ];

  void _navigateToService(BuildContext context, ServiceCategory cat) {
    Widget targetScreen;
    switch (cat) {
      case ServiceCategory.food:
        targetScreen = const RestaurantsScreen();
        break;
      case ServiceCategory.supermarket:
        targetScreen = const SupermarketScreen();
        break;
      case ServiceCategory.pharmacy:
        targetScreen = const PharmacyScreen();
        break;
      case ServiceCategory.electronics:
        targetScreen = const ElectronicsScreen();
        break;
      case ServiceCategory.fashion:
        targetScreen = const FashionScreen();
        break;
      case ServiceCategory.realEstate:
        targetScreen = const RealEstateScreen();
        break;
      case ServiceCategory.jobs:
        targetScreen = const JobsScreen();
        break;
      case ServiceCategory.parcelDelivery:
        targetScreen = const ParcelDeliveryScreen();
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => targetScreen),
    );
  }

  void _toggleFavorite(ServiceCategory category) {
    setState(() {
      if (_favoriteCategories.contains(category)) {
        _favoriteCategories.remove(category);
      } else {
        _favoriteCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _categories.where((item) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return item.title.toLowerCase().contains(q) ||
          item.tagText.toLowerCase().contains(q);
    }).toList();

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                // Top Header Container (Light Lime Green Theme)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9F99D),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD9F99D).withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'أقسام الخدمات',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'استكشف أفضل العروض والخدمات بالمدينة',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: const Color(0xFF1E1E2D)
                                          .withValues(alpha: 0.75),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(9),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1E1E2D),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.grid_view_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Search Bar Input
                          Container(
                            height: 46,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search_rounded,
                                  color: Color(0xFF1E1E2D),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    onChanged: (val) {
                                      setState(() {
                                        _searchQuery = val;
                                      });
                                    },
                                    style: const TextStyle(
                                      color: Color(0xFF1E1E2D),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText:
                                          'ابحث عن قسم، مطعم، صيدلية، إلكترونيات...',
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
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
                ),

                // Grid View of Pastel Cards Matching Reference Image Design
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: AppColors.textLight,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'لم نجد نتائج تطابق "$_searchQuery"',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.82,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            final isFav = _favoriteCategories.contains(item.category);

                            return GestureDetector(
                              onTap: () =>
                                  _navigateToService(context, item.category),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: item.bgColor,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: item.bgColor.withValues(alpha: 0.5),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Top Row: Title on Left, Rating Pill on Right
                                    Positioned(
                                      top: 14,
                                      left: 14,
                                      right: 14,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Title
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFF1E1E2D),
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),

                                          // Rating Pill
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withValues(alpha: 0.65),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.star_outline_rounded,
                                                  size: 13,
                                                  color: Color(0xFF1E1E2D),
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  item.rating,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xFF1E1E2D),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Floating Favorite Heart Circle Icon
                                    Positioned(
                                      top: 52,
                                      left: 14,
                                      child: GestureDetector(
                                        onTap: () => _toggleFavorite(item.category),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.08),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isFav
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border_rounded,
                                            color: const Color(0xFFFF4B4B),
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 3D Hero Category Image (Positioned Overflowing Right/Bottom)
                                    Positioned(
                                      right: -4,
                                      bottom: 34,
                                      child: Hero(
                                        tag: 'cat_img_${item.category.name}',
                                        child: Image.asset(
                                          item.imagePath,
                                          height: 108,
                                          width: 108,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                            Icons.category_rounded,
                                            size: 60,
                                            color: Color(0xFF1E1E2D),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Bottom Glassmorphic Translucent Pill Bar
                                    Positioned(
                                      left: 12,
                                      bottom: 12,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 8,
                                            sigmaY: 8,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withValues(alpha: 0.55),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withValues(alpha: 0.8),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  item.tagText,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xFF1E1E2D),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFF1E1E2D),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.shopping_bag_outlined,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
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
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
