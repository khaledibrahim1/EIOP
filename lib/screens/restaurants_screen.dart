import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/cart_state.dart';
import '../models/restaurant.dart';
import '../theme/app_colors.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details_screen.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isCategoryVisible = true;

  // Restaurant Categories
  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'الكل'},
    {'id': 'grill', 'label': 'مشويات'},
    {'id': 'burger_pizza', 'label': 'البرجرات والبيتزهات'},
    {'id': 'dessert', 'label': 'الحلويات'},
  ];

  // Girga Local Restaurants List with categories
  final List<Restaurant> _allRestaurants = const [
    Restaurant(
      id: 'rest_1',
      name: 'مطعم حضرموت جرجا',
      cuisine: 'مندي • مشويات • طواجن',
      rating: 4.8,
      reviewsCount: 142,
      deliveryTime: '25-35 دقيقة',
      deliveryFee: 15.0,
      coverImagePath: 'assets/images/hadramout_cover.png',
      logoPath: 'assets/images/hadramout_cover.png',
      address: 'شارع المحطة',
      isOpen: true,
      categoryId: 'grill',
    ),
    Restaurant(
      id: 'rest_2',
      name: 'بيتزا وكريب السلطان',
      cuisine: 'بيتزا إيطالي • كريب • وافل',
      rating: 4.7,
      reviewsCount: 98,
      deliveryTime: '20-30 دقيقة',
      deliveryFee: 10.0,
      coverImagePath: 'assets/images/sultan_pizza_cover.png',
      logoPath: 'assets/images/sultan_pizza_cover.png',
      address: 'الشارع التجاري',
      isOpen: true,
      categoryId: 'burger_pizza',
    ),
    Restaurant(
      id: 'rest_3',
      name: 'برجر هاوس جرجا',
      cuisine: 'برجر ع الفحم • ساندوتشات',
      rating: 4.9,
      reviewsCount: 210,
      deliveryTime: '15-25 دقيقة',
      deliveryFee: 12.0,
      coverImagePath: 'assets/images/double_cheese_burger.png',
      logoPath: 'assets/images/double_cheese_burger.png',
      address: 'ميدان النهضة',
      isOpen: true,
      categoryId: 'burger_pizza',
    ),
    Restaurant(
      id: 'rest_4',
      name: 'كبابجي الفرسان',
      cuisine: 'مشويات ع الفحم • كباب • كفتة',
      rating: 4.9,
      reviewsCount: 185,
      deliveryTime: '30-40 دقيقة',
      deliveryFee: 15.0,
      coverImagePath: 'assets/images/special_steak.png',
      logoPath: 'assets/images/special_steak.png',
      address: 'شارع الأهرام',
      isOpen: true,
      categoryId: 'grill',
    ),
    Restaurant(
      id: 'rest_5',
      name: 'حلويات ومعجنات عرفة',
      cuisine: 'شرقيات • حلويات فاخرة • كنافة',
      rating: 4.9,
      reviewsCount: 310,
      deliveryTime: '15-25 دقيقة',
      deliveryFee: 10.0,
      coverImagePath: 'assets/images/cat_dessert.png',
      logoPath: 'assets/images/cat_dessert.png',
      address: 'ميدان المحطة',
      isOpen: true,
      categoryId: 'dessert',
    ),
    Restaurant(
      id: 'rest_6',
      name: 'أسماك المحيط جرجا',
      cuisine: 'مأكولات بحرية • طواجن سي فود',
      rating: 4.6,
      reviewsCount: 75,
      deliveryTime: '30-40 دقيقة',
      deliveryFee: 18.0,
      coverImagePath: 'assets/images/fried_rice.png',
      logoPath: 'assets/images/fried_rice.png',
      address: 'طريق الكورنيش',
      isOpen: true,
      categoryId: 'grill',
    ),
    Restaurant(
      id: 'rest_7',
      name: 'آيس كريم وعصائر السعادة',
      cuisine: 'آيس كريم • وافل • كريب حلو',
      rating: 4.8,
      reviewsCount: 160,
      deliveryTime: '15-20 دقيقة',
      deliveryFee: 8.0,
      coverImagePath: 'assets/images/cat_icecream.png',
      logoPath: 'assets/images/cat_icecream.png',
      address: 'شارع البحر',
      isOpen: true,
      categoryId: 'dessert',
    ),
  ];

  List<Restaurant> get _filteredRestaurants {
    return _allRestaurants.where((restaurant) {
      final matchesSearch = _searchQuery.isEmpty ||
          restaurant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          restaurant.cuisine.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'all' ||
          restaurant.categoryId == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = _filteredRestaurants;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                // 1. TOP APP BAR & SEARCH HEADER
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Subtitle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'المطاعم',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'اختر مطعمك المفضل في جرجا',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${restaurants.length} مطعم',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Search Input Field
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search_rounded,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    onChanged: (val) {
                                      setState(() {
                                        _searchQuery = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'بحث باسم المطعم أو نوع الأكل...',
                                      hintStyle: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: AppColors.textSecondary,
                                      size: 18,
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

                // 2. CATEGORIES FILTER BAR (Collapsible on Scroll)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: _isCategoryVisible ? 54.0 : 0.0,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isCategoryVisible ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = _selectedCategory == cat['id'];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = cat['id']!;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? AppColors.primaryGradient
                                    : null,
                                color: isSelected ? null : AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.03),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                              ),
                              child: Text(
                                cat['label']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // 3. RESTAURANTS LIST VIEW WITH SCROLL DIRECTION DETECTION
                Expanded(
                  child: NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      if (notification.direction == ScrollDirection.reverse) {
                        if (_isCategoryVisible) {
                          setState(() {
                            _isCategoryVisible = false;
                          });
                        }
                      } else if (notification.direction == ScrollDirection.forward) {
                        if (!_isCategoryVisible) {
                          setState(() {
                            _isCategoryVisible = true;
                          });
                        }
                      }
                      return true;
                    },
                    child: restaurants.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.storefront_outlined,
                                  size: 64,
                                  color: AppColors.textLight
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'لم نجد مطاعم بهذا الاسم',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                            physics: const BouncingScrollPhysics(),
                            itemCount: restaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant = restaurants[index];

                              return TweenAnimationBuilder<double>(
                                key: ValueKey(
                                    '${restaurant.id}_$_selectedCategory'),
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration:
                                    Duration(milliseconds: 300 + (index * 80)),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, (1 - value) * 30),
                                    child: Opacity(
                                      opacity: value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: RestaurantCard(
                                  restaurant: restaurant,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RestaurantDetailsScreen(
                                          restaurant: restaurant,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
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
}
