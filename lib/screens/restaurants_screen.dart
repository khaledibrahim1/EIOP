import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/food_item.dart';
import '../models/restaurant.dart';
import '../theme/app_colors.dart';
import '../widgets/food_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/restaurant_card.dart';
import 'food_details_screen.dart';
import 'restaurant_details_screen.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  int _selectedViewIndex = 0; // 0 = المطاعم, 1 = جميع الأكلات والوجبات
  String _selectedCategory = 'all';
  String _searchQuery = '';

  // Restaurant Categories
  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'الكل'},
    {'id': 'grill', 'label': 'مشويات'},
    {'id': 'burger_pizza', 'label': 'برجر وبيتزا'},
    {'id': 'dessert', 'label': 'حلويات وتسلية'},
  ];

  // Girga Local Restaurants List
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

  // Aggregated Popular Dishes List Across Girga Restaurants
  final List<FoodItem> _allDishes = const [
    FoodItem(
      id: 'dish_1',
      title: 'دبل تشيز برجر فاخر',
      restaurantId: 'rest_3',
      restaurant: 'برجر هاوس جرجا',
      price: 135.0,
      rating: 4.9,
      deliveryTime: '15-25 دقيقة',
      description:
          'شريحتين من لحم البقر الصافي مع جبنة شيدر مائبة وصوص خاص مع بطاطس.',
      imagePath: 'assets/images/double_cheese_burger.png',
      categoryId: 'burger',
      isPopular: true,
    ),
    FoodItem(
      id: 'dish_2',
      title: 'بيتزا سوبر سوبريم',
      restaurantId: 'rest_2',
      restaurant: 'بيتزا السلطان',
      price: 160.0,
      rating: 4.8,
      deliveryTime: '20-30 دقيقة',
      description:
          'خليط غني من اللحم المفروم والبيبروني والفلفل والزيتون والموزاريلا.',
      imagePath: 'assets/images/sultan_pizza_cover.png',
      categoryId: 'pizza',
      isPopular: true,
    ),
    FoodItem(
      id: 'dish_3',
      title: 'وجبة كباب وكفتة ضاني',
      restaurantId: 'rest_1',
      restaurant: 'مطعم حضرموت',
      price: 240.0,
      rating: 4.9,
      deliveryTime: '25-35 دقيقة',
      description:
          'مشويات مشكلة ع الفحم مع أرز بسمتي فاخر وطحينة وسلطات.',
      imagePath: 'assets/images/hadramout_cover.png',
      categoryId: 'food',
      isPopular: true,
    ),
    FoodItem(
      id: 'dish_4',
      title: 'ستيك ريب آي بصوص المشروم',
      restaurantId: 'rest_4',
      restaurant: 'كبابجي الفرسان',
      price: 290.0,
      rating: 4.7,
      deliveryTime: '30-40 دقيقة',
      description: 'ستيك كندوز مشوي على الجريل مع صوص المشروم الكريمة.',
      imagePath: 'assets/images/special_steak.png',
      categoryId: 'food',
      isPopular: true,
    ),
    FoodItem(
      id: 'dish_5',
      title: 'أرز مقلي بالجمبري',
      restaurantId: 'rest_6',
      restaurant: 'أسماك المحيط',
      price: 145.0,
      rating: 4.6,
      deliveryTime: '30-40 دقيقة',
      description: 'أرز بسمتي مقلي مع جمبري طازج وخضروات مشكلة.',
      imagePath: 'assets/images/fried_rice.png',
      categoryId: 'food',
      isPopular: true,
    ),
    FoodItem(
      id: 'dish_6',
      title: 'كنافة بالمكسرات والقشطة',
      restaurantId: 'rest_5',
      restaurant: 'حلويات عرفة',
      price: 85.0,
      rating: 4.9,
      deliveryTime: '15-25 دقيقة',
      description: 'كنافة بلدي بالسمنة البلدي محشوة قشطة فاخرة ومكسرات.',
      imagePath: 'assets/images/cat_dessert.png',
      categoryId: 'dessert',
      isPopular: true,
    ),
    FoodItem(
      id: 'dish_7',
      title: 'وافل بالموز والشوكولاتة',
      restaurantId: 'rest_7',
      restaurant: 'آيس كريم السعادة',
      price: 65.0,
      rating: 4.8,
      deliveryTime: '15-20 دقيقة',
      description: 'وافل ذهبي مقرمش مع قطع الموز وخص السكر وصوص النوتيلا.',
      imagePath: 'assets/images/cat_icecream.png',
      categoryId: 'dessert',
      isPopular: true,
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

  List<FoodItem> get _filteredDishes {
    return _allDishes.where((dish) {
      final matchesSearch = _searchQuery.isEmpty ||
          dish.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dish.restaurant.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'all' ||
          (_selectedCategory == 'grill' && dish.categoryId == 'food') ||
          (_selectedCategory == 'burger_pizza' &&
              (dish.categoryId == 'burger' || dish.categoryId == 'pizza')) ||
          (_selectedCategory == 'dessert' && dish.categoryId == 'dessert');

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = _filteredRestaurants;
    final dishes = _filteredDishes;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                // 1. TOP APP BAR & SEARCH HEADER WITH BACK BUTTON
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
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Subtitle Header
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
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.12),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.arrow_back_rounded,
                                              color: AppColors.primary,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'مطاعم وأكلات جرجا',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'اختر مطعمك المفضل أو الأكلة التي تشتهيها',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
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
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${_allRestaurants.length} مطعم',
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
                            height: 46,
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
                                      hintText:
                                          'ابحث باسم المطعم أو نوع الوجبة...',
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
                          const SizedBox(height: 14),

                          // VIEW SWITCHER TABS (المطاعم VS كل الأكلات والوجبات)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => _selectedViewIndex = 0);
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        gradient: _selectedViewIndex == 0
                                            ? AppColors.primaryGradient
                                            : null,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: _selectedViewIndex == 0
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.storefront_rounded,
                                              size: 16,
                                              color: _selectedViewIndex == 0
                                                  ? Colors.white
                                                  : AppColors.textSecondary,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'جميع المطاعم',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: _selectedViewIndex == 0
                                                    ? Colors.white
                                                    : AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => _selectedViewIndex = 1);
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        gradient: _selectedViewIndex == 1
                                            ? AppColors.primaryGradient
                                            : null,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: _selectedViewIndex == 1
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.restaurant_menu_rounded,
                                              size: 16,
                                              color: _selectedViewIndex == 1
                                                  ? Colors.white
                                                  : AppColors.textSecondary,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'جميع الوجبات والأكلات',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: _selectedViewIndex == 1
                                                    ? Colors.white
                                                    : AppColors.textSecondary,
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
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. MAIN BODY CONTENT (RESTAURANTS LIST OR DISHES GRID)
                Expanded(
                  child: _selectedViewIndex == 0
                      ? _buildRestaurantsListView(restaurants)
                      : _buildDishesGridView(dishes),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- RESTAURANTS LIST VIEW ----------------
  Widget _buildRestaurantsListView(List<Restaurant> restaurants) {
    if (restaurants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 64,
              color: AppColors.textLight.withValues(alpha: 0.5),
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
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      physics: const BouncingScrollPhysics(),
      itemCount: restaurants.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PromoBanner(
              onTasteNow: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantDetailsScreen(
                      restaurant: _allRestaurants[0],
                    ),
                  ),
                );
              },
            ),
          );
        }

        final restaurant = restaurants[index - 1];
        return RestaurantCard(
          restaurant: restaurant,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantDetailsScreen(
                  restaurant: restaurant,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------------- DISHES GRID VIEW ----------------
  Widget _buildDishesGridView(List<FoodItem> dishes) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Promo Banner
          PromoBanner(
            onTasteNow: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تفعيل عروض الطعام الفاخرة! 🍔'),
                  backgroundColor: AppColors.primary,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Categories Chips Filter
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['id'];
                return ChoiceChip(
                  label: Text(cat['label']!),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedCategory = cat['id']!);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Grid View of All Food Item Dishes
          dishes.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 56, color: AppColors.textLight),
                        const SizedBox(height: 12),
                        Text(
                          'لا يوجد وجبات تطابق البحث',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dishes.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.64,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final food = dishes[index];
                    return FoodCard(
                      food: food,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailsScreen(food: food),
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
        ],
      ),
    );
  }
}
