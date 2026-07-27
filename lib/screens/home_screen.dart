import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/category_item.dart';
import '../models/food_item.dart';
import '../models/restaurant.dart';
import '../models/service_type.dart';
import '../theme/app_colors.dart';
import '../widgets/category_chip.dart';
import '../widgets/dark_mode_switch.dart';
import '../widgets/food_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/what_do_you_need_grid.dart';
import 'cart_screen.dart';
import 'electronics_screen.dart';
import 'fashion_screen.dart';
import 'food_details_screen.dart';
import 'jobs_screen.dart';
import 'parcel_delivery_screen.dart';
import 'pharmacy_screen.dart';
import 'real_estate_screen.dart';
import 'restaurant_details_screen.dart';
import 'supermarket_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCatId = '';
  String _searchQuery = '';

  void _onSelectServiceCategory(ServiceCategory cat) {
    switch (cat) {
      case ServiceCategory.food:
        setState(() => _selectedCatId = '');
        break;
      case ServiceCategory.supermarket:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SupermarketScreen()));
        break;
      case ServiceCategory.pharmacy:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const PharmacyScreen()));
        break;
      case ServiceCategory.electronics:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ElectronicsScreen()));
        break;
      case ServiceCategory.fashion:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const FashionScreen()));
        break;
      case ServiceCategory.realEstate:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const RealEstateScreen()));
        break;
      case ServiceCategory.jobs:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const JobsScreen()));
        break;
      case ServiceCategory.parcelDelivery:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ParcelDeliveryScreen()));
        break;
    }
  }

  // Realistic Categories with Photo Assets
  final List<CategoryItem> _categories = [
    CategoryItem(
      id: 'dessert',
      title: 'حلويات',
      imagePath: 'assets/images/cat_dessert.png',
      bgColor: AppColors.catBurgerBg,
      activeColor: AppColors.primary,
    ),
    CategoryItem(
      id: 'icecream',
      title: 'آيس كريم',
      imagePath: 'assets/images/cat_icecream.png',
      bgColor: AppColors.catPizzaBg,
      activeColor: AppColors.primary,
    ),
    CategoryItem(
      id: 'pizza',
      title: 'بيتزا',
      imagePath: 'assets/images/cat_pizza.png',
      bgColor: AppColors.catPizzaBg,
      activeColor: AppColors.primary,
    ),
    CategoryItem(
      id: 'coffee',
      title: 'مشروبات',
      imagePath: 'assets/images/cat_coffee.png',
      bgColor: AppColors.catSoupBg,
      activeColor: AppColors.primary,
    ),
    CategoryItem(
      id: 'burger',
      title: 'برجر',
      imagePath: 'assets/images/cat_burger.png',
      bgColor: AppColors.catBurgerBg,
      activeColor: AppColors.primary,
    ),
  ];

  // Girga Local Restaurants Directory
  final List<Restaurant> _girgaRestaurants = const [
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
    ),
    Restaurant(
      id: 'rest_4',
      name: 'أسماك المحيط جرجا',
      cuisine: 'مأكولات بحرية • طواجن سي فود',
      rating: 4.6,
      reviewsCount: 75,
      deliveryTime: '30-40 دقيقة',
      deliveryFee: 18.0,
      coverImagePath: 'assets/images/special_steak.png',
      logoPath: 'assets/images/special_steak.png',
      address: 'طريق الكورنيش',
      isOpen: true,
    ),
  ];

  // Aggregated Dishes List
  final List<FoodItem> _allDishes = const [
    FoodItem(
      id: '1',
      title: 'بيتزا ببروني فاخرة',
      restaurantId: 'rest_2',
      restaurant: 'بيتزا السلطان',
      price: 120.0,
      rating: 4.8,
      deliveryTime: '15 دقيقة',
      description:
          'بيتزا ببروني إيطالية طازجة مع صوص الصلصة الممتاز وجبنة موزاريلا سائبة ومكونات فاخرة.',
      imagePath: 'assets/images/sultan_pizza_cover.png',
      images: [
        'assets/images/sultan_pizza_cover.png',
        'assets/images/cat_pizza.png',
        'assets/images/cat_burger.png',
      ],
      options: [
        FoodOption(
          id: 'p1_s',
          title: 'حجم صغير (Small)',
          code: 'S',
          priceOffset: 0.0,
          imagePath: 'assets/images/cat_pizza.png',
        ),
        FoodOption(
          id: 'p1_m',
          title: 'حجم وسط (Medium)',
          code: 'M',
          priceOffset: 25.0,
          imagePath: 'assets/images/sultan_pizza_cover.png',
        ),
        FoodOption(
          id: 'p1_l',
          title: 'حجم كبير (Large)',
          code: 'L',
          priceOffset: 45.0,
          imagePath: 'assets/images/sultan_pizza_cover.png',
        ),
        FoodOption(
          id: 'p1_xl',
          title: 'حجم عائلي (X-Large)',
          code: 'XL',
          priceOffset: 70.0,
          imagePath: 'assets/images/cat_pizza.png',
        ),
      ],
      categoryId: 'pizza',
      isPopular: true,
    ),
    FoodItem(
      id: '2',
      title: 'دبل تشيز برجر فاخر',
      restaurantId: 'rest_3',
      restaurant: 'برجر هاوس',
      price: 110.0,
      rating: 4.9,
      deliveryTime: '20 دقيقة',
      description:
          'قطعتين لحم بقر طازج مع جبنة شيدر سائبة وساندوتش محمص ع الفحم وصوص خاص.',
      imagePath: 'assets/images/double_cheese_burger.png',
      images: [
        'assets/images/double_cheese_burger.png',
        'assets/images/cat_burger.png',
      ],
      options: [
        FoodOption(
          id: 'b2_s',
          title: 'سنجل برجر (Single)',
          code: 'S',
          priceOffset: 0.0,
          imagePath: 'assets/images/cat_burger.png',
        ),
        FoodOption(
          id: 'b2_m',
          title: 'دبل تشيز (Double)',
          code: 'M',
          priceOffset: 30.0,
          imagePath: 'assets/images/double_cheese_burger.png',
        ),
        FoodOption(
          id: 'b2_l',
          title: 'تربل تشيز (Triple)',
          code: 'L',
          priceOffset: 60.0,
          imagePath: 'assets/images/double_cheese_burger.png',
        ),
      ],
      categoryId: 'burger',
      isPopular: true,
    ),
    FoodItem(
      id: '3',
      title: 'طبق أرز مشكل شرقي',
      restaurantId: 'rest_1',
      restaurant: 'مطعم حضرموت',
      price: 85.0,
      rating: 4.7,
      deliveryTime: '25 دقيقة',
      description:
          'أرز بسمتي مبهر مع الخضار والبهارات اليمانية الأصيلة وقطع المكسرات.',
      imagePath: 'assets/images/fried_rice.png',
      images: [
        'assets/images/fried_rice.png',
        'assets/images/hadramout_cover.png',
      ],
      options: [
        FoodOption(
          id: 'r3_s',
          title: 'طبق فردي (1 شخص)',
          code: 'S',
          priceOffset: 0.0,
          imagePath: 'assets/images/fried_rice.png',
        ),
        FoodOption(
          id: 'r3_m',
          title: 'طبق وسط (2 شخص)',
          code: 'M',
          priceOffset: 40.0,
          imagePath: 'assets/images/fried_rice.png',
        ),
        FoodOption(
          id: 'r3_l',
          title: 'سرفيس عائلي (4 أشخاص)',
          code: 'L',
          priceOffset: 95.0,
          imagePath: 'assets/images/hadramout_cover.png',
        ),
      ],
      categoryId: 'dessert',
      isPopular: true,
    ),
    FoodItem(
      id: '4',
      title: 'ستيك مشوي ع الفحم',
      restaurantId: 'rest_1',
      restaurant: 'مطعم حضرموت',
      price: 190.0,
      rating: 4.9,
      deliveryTime: '30 دقيقة',
      description:
          'ستيك کندوز مشوي على الجريل مع الخضار السوتيه وصوص المشروم الفاخر.',
      imagePath: 'assets/images/special_steak.png',
      images: [
        'assets/images/special_steak.png',
        'assets/images/hadramout_cover.png',
      ],
      options: [
        FoodOption(
          id: 'st4_250',
          title: 'وجبة 250 جرام',
          code: 'M',
          priceOffset: 0.0,
          imagePath: 'assets/images/special_steak.png',
        ),
        FoodOption(
          id: 'st4_500',
          title: 'وجبة 500 جرام (دبل)',
          code: 'L',
          priceOffset: 120.0,
          imagePath: 'assets/images/special_steak.png',
        ),
      ],
      categoryId: 'salad',
      isPopular: true,
    ),
  ];

  List<FoodItem> get _filteredDishes {
    return _allDishes.where((dish) {
      final matchesSearch = dish.title.contains(_searchQuery) ||
          dish.restaurant.contains(_searchQuery);
      final matchesCat =
          _selectedCatId.isEmpty || dish.categoryId == _selectedCatId;
      return matchesSearch && matchesCat;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TOP HEADER WITH SMOOTH FADING GRADIENT
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.headerFadeGradient,
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             // Row 1: App Title & Animated Dark Mode Switch
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.all_inclusive_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'EIOP Super App',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const Text(
                                          'كل خدمات المدينة في مكان واحد 📍',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Animated Dark Mode Switch Button
                                const DarkModeSwitch(),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Row 2: Search Input Field & Cart Shortcut Button
                            Row(
                              children: [
                                // Search Box Container
                                Expanded(
                                  child: Container(
                                    height: 48,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.search_rounded,
                                          color: AppColors.textLight,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: TextField(
                                            onChanged: (val) =>
                                                setState(() => _searchQuery = val),
                                            decoration: InputDecoration(
                                              hintText: 'ابحث عن أي خدمة، منتج، أو محل...',
                                              hintStyle: TextStyle(
                                                color: AppColors.textLight,
                                                fontSize: 12,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Cart Shortcut Button with Badge Count
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CartScreen(),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.06),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.shopping_bag_outlined,
                                          color: AppColors.primary,
                                          size: 22,
                                        ),
                                      ),
                                      if (appState.totalItemCount > 0)
                                        Positioned(
                                          right: -2,
                                          top: -2,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 18,
                                              minHeight: 18,
                                            ),
                                            child: Text(
                                              '${appState.totalItemCount}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
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
                    ),
                  ),

              // 2. MAIN CONTENT AREA
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FEATURED HUB: "ماذا تريد الآن؟"
                    WhatDoYouNeedGrid(
                      onSelectCategory: _onSelectServiceCategory,
                    ),
                    const SizedBox(height: 28),

                    // ORDER 1: ONGOING PROMO OFFERS BANNER
                    Text(
                      'العروض المتاحة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    PromoBanner(
                      onTasteNow: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantDetailsScreen(
                              restaurant: _girgaRestaurants[1],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // ORDER 2: CATEGORIES SLIDER SECOND
                    Text(
                      'الأقسام',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 124,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          return CategoryChip(
                            category: cat,
                            isSelected: _selectedCatId == cat.id,
                            onTap: () {
                              setState(() {
                                if (_selectedCatId == cat.id) {
                                  _selectedCatId = '';
                                } else {
                                  _selectedCatId = cat.id;
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ORDER 3: SECTION LISTINGS (Dishes Grid)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الأكلات الشائعة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCatId = '';
                              _searchQuery = '';
                            });
                          },
                          child: const Text(
                            'عرض الكل',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.60,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: _filteredDishes.length,
                      itemBuilder: (context, index) {
                        final food = _filteredDishes[index];
                        return FoodCard(
                          food: food,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FoodDetailsScreen(food: food),
                              ),
                            );
                          },
                          onPlaceOrder: () {
                            appState.addToCart(food, quantity: 1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('تم إضافة ${food.title} لطلبك!'),
                                backgroundColor: AppColors.primary,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
);
  }
}
