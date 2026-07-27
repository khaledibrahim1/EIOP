import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/food_item.dart';
import '../models/restaurant.dart';
import '../theme/app_colors.dart';
import '../widgets/food_card.dart';
import 'food_details_screen.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  // Mock dishes specific to this restaurant
  late List<FoodItem> _restaurantDishes;

  @override
  void initState() {
    super.initState();
    // Default dishes generated for this Girga restaurant
    _restaurantDishes = [
      FoodItem(
        id: '${widget.restaurant.id}_1',
        title: 'دبل تشيز برجر فاخر',
        restaurantId: widget.restaurant.id,
        restaurant: widget.restaurant.name,
        price: 135.0,
        rating: 4.9,
        deliveryTime: widget.restaurant.deliveryTime,
        description:
            'شريحتين من لحم البقر الصافي مع جبنة شيدر مائبة، صوص خاص، ومخلل، مع بطاطس مقرمشة.',
        imagePath: 'assets/images/double_cheese_burger.png',
        images: [
          'assets/images/double_cheese_burger.png',
          'assets/images/cat_burger.png',
        ],
        options: const [
          FoodOption(
            id: 'res_b1_s',
            title: 'حجم عادي (Single)',
            code: 'S',
            priceOffset: 0.0,
            imagePath: 'assets/images/cat_burger.png',
          ),
          FoodOption(
            id: 'res_b1_m',
            title: 'حجم دبل (Double)',
            code: 'M',
            priceOffset: 35.0,
            imagePath: 'assets/images/double_cheese_burger.png',
          ),
          FoodOption(
            id: 'res_b1_l',
            title: 'حجم عائلي (Triple)',
            code: 'L',
            priceOffset: 70.0,
            imagePath: 'assets/images/double_cheese_burger.png',
          ),
        ],
        categoryId: 'burger',
        isPopular: true,
      ),
      FoodItem(
        id: '${widget.restaurant.id}_2',
        title: 'بيتزا سوبر سوبريم',
        restaurantId: widget.restaurant.id,
        restaurant: widget.restaurant.name,
        price: 160.0,
        rating: 4.8,
        deliveryTime: widget.restaurant.deliveryTime,
        description:
            'خليط غني من اللحم المفروم، البيبروني، الفلفل الأخضر، الزيتون، وجبنة الموزاريلا الفاخرة.',
        imagePath: 'assets/images/sultan_pizza_cover.png',
        images: [
          'assets/images/sultan_pizza_cover.png',
          'assets/images/cat_pizza.png',
        ],
        options: const [
          FoodOption(
            id: 'res_p2_s',
            title: 'حجم صغير (Small)',
            code: 'S',
            priceOffset: 0.0,
            imagePath: 'assets/images/cat_pizza.png',
          ),
          FoodOption(
            id: 'res_p2_m',
            title: 'حجم وسط (Medium)',
            code: 'M',
            priceOffset: 30.0,
            imagePath: 'assets/images/sultan_pizza_cover.png',
          ),
          FoodOption(
            id: 'res_p2_l',
            title: 'حجم كبير (Large)',
            code: 'L',
            priceOffset: 55.0,
            imagePath: 'assets/images/sultan_pizza_cover.png',
          ),
        ],
        categoryId: 'pizza',
        isPopular: true,
      ),
      FoodItem(
        id: '${widget.restaurant.id}_3',
        title: 'وجبة كباب وكفتة ضاني',
        restaurantId: widget.restaurant.id,
        restaurant: widget.restaurant.name,
        price: 240.0,
        rating: 4.9,
        deliveryTime: widget.restaurant.deliveryTime,
        description:
            'مشويات مشكلة على الفحم مع أرز بسمتي بالسمن البلدي، سلطات، وطحينة، وعيش بلدي.',
        imagePath: 'assets/images/hadramout_cover.png',
        images: [
          'assets/images/hadramout_cover.png',
          'assets/images/special_steak.png',
        ],
        options: const [
          FoodOption(
            id: 'res_k3_1',
            title: 'وجبة 1/4 كيلو',
            code: 'S',
            priceOffset: 0.0,
            imagePath: 'assets/images/hadramout_cover.png',
          ),
          FoodOption(
            id: 'res_k3_2',
            title: 'وجبة 1/2 كيلو',
            code: 'M',
            priceOffset: 120.0,
            imagePath: 'assets/images/hadramout_cover.png',
          ),
          FoodOption(
            id: 'res_k3_3',
            title: 'سرفيس 1 كيلو كامل',
            code: 'L',
            priceOffset: 320.0,
            imagePath: 'assets/images/hadramout_cover.png',
          ),
        ],
        categoryId: 'soup',
        isPopular: true,
      ),
      FoodItem(
        id: '${widget.restaurant.id}_4',
        title: 'ستيك ريب آي بصوص المشروم',
        restaurantId: widget.restaurant.id,
        restaurant: widget.restaurant.name,
        price: 290.0,
        rating: 4.7,
        deliveryTime: widget.restaurant.deliveryTime,
        description:
            'قطعة ستيك طازجة مشوية بصلصة المشروم الكريمة مع خضار سوتيه وبطاطس بيوريه.',
        imagePath: 'assets/images/special_steak.png',
        images: [
          'assets/images/special_steak.png',
        ],
        options: const [
          FoodOption(
            id: 'res_st4_1',
            title: 'ستيك سينجل 250جم',
            code: 'M',
            priceOffset: 0.0,
            imagePath: 'assets/images/special_steak.png',
          ),
          FoodOption(
            id: 'res_st4_2',
            title: 'ستيك دبل 500جم',
            code: 'L',
            priceOffset: 150.0,
            imagePath: 'assets/images/special_steak.png',
          ),
        ],
        categoryId: 'salad',
        isPopular: true,
      ),
      FoodItem(
        id: '${widget.restaurant.id}_5',
        title: 'طبق أرز مقلي بالجمبري',
        restaurantId: widget.restaurant.id,
        restaurant: widget.restaurant.name,
        price: 145.0,
        rating: 4.6,
        deliveryTime: widget.restaurant.deliveryTime,
        description:
            'أرز بسمتي فاخر مقلي على الطريقة الآسيوية مع جمبري طازج وخضروات مشكلة.',
        imagePath: 'assets/images/fried_rice.png',
        images: [
          'assets/images/fried_rice.png',
        ],
        options: const [
          FoodOption(
            id: 'res_r5_1',
            title: 'حجم عادي (1 شخص)',
            code: 'S',
            priceOffset: 0.0,
            imagePath: 'assets/images/fried_rice.png',
          ),
          FoodOption(
            id: 'res_r5_2',
            title: 'حجم كبير (2 أفراد)',
            code: 'L',
            priceOffset: 65.0,
            imagePath: 'assets/images/fried_rice.png',
          ),
        ],
        categoryId: 'salad',
        isPopular: true,
      ),
      FoodItem(
        id: '${widget.restaurant.id}_6',
        title: 'وجبة برجر دجاج كرسبي',
        restaurantId: widget.restaurant.id,
        restaurant: widget.restaurant.name,
        price: 115.0,
        rating: 4.8,
        deliveryTime: widget.restaurant.deliveryTime,
        description:
            'صدور دجاج كرسبي حارة مع جبنة موزاريلا مقرمشة وصوص مايونيز الثوم.',
        imagePath: 'assets/images/cat_burger.png',
        images: [
          'assets/images/cat_burger.png',
        ],
        options: const [
          FoodOption(
            id: 'res_bc6_1',
            title: 'سندوتش كرسبي فردي',
            code: 'S',
            priceOffset: 0.0,
            imagePath: 'assets/images/cat_burger.png',
          ),
          FoodOption(
            id: 'res_bc6_2',
            title: 'وجبة دبل + بطاطس وكانز',
            code: 'M',
            priceOffset: 45.0,
            imagePath: 'assets/images/cat_burger.png',
          ),
        ],
        categoryId: 'burger',
        isPopular: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // Sliver App Bar with Cover Image & Center Overlapping Badge
              SliverAppBar(
                expandedHeight: 220.0,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: 'rest_cover_${widget.restaurant.id}',
                          child: Image.asset(
                            widget.restaurant.coverImagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.primary,
                              child: const Icon(Icons.restaurant,
                                  size: 80, color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      // Bottom Gradient Shadow Overlay for header image
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.4),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),

                      // Center Curved Pill Badge at Bottom of Header Cover Image (matching screenshot)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, -3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.stars_rounded,
                                color: AppColors.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.restaurant.name} - أشهى الوجبات',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
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

              // Restaurant Metadata Header Card
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.restaurant.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.accentYellow.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: AppColors.accentYellow, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.restaurant.rating}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.restaurant.cuisine} • ${widget.restaurant.address}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _buildBadge(
                            icon: Icons.timer_outlined,
                            label: widget.restaurant.deliveryTime,
                          ),
                          const SizedBox(width: 12),
                          _buildBadge(
                            icon: Icons.delivery_dining_rounded,
                            label:
                                'التوصيل: ${widget.restaurant.deliveryFee.toStringAsFixed(0)} ج.م',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Menu Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'قائمة الطعام (المنيو) 🍕',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${_restaurantDishes.length} وجبات',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Professional 2-Column Menu Grid (Matching Screenshot)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.60,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final food = _restaurantDishes[index];
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
                    childCount: _restaurantDishes.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
