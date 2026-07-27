import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/food_item.dart';
import '../theme/app_colors.dart';
import 'food_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const List<FoodItem> _allFoods = [
    FoodItem(
      id: '1',
      title: 'دبل تشيز برجر فاخر',
      restaurantId: 'rest_3',
      restaurant: 'برجر هاوس جرجا',
      description:
          'شريحتين من لحم البقر الصافي مع جبنة شيدر مائبة، صوص خاص، ومخلل، مع بطاطس مقرمشة.',
      price: 135.0,
      rating: 4.9,
      imagePath: 'assets/images/double_cheese_burger.png',
      deliveryTime: '15-25 دقيقة',
      categoryId: 'burger',
      isPopular: true,
    ),
    FoodItem(
      id: '2',
      title: 'بيتزا سوبر سوبريم',
      restaurantId: 'rest_1',
      restaurant: 'بيتزا السلطان جرجا',
      description:
          'خليط غني من اللحم المفروم، البيبروني، الفلفل الأخضر، الزيتون، وجبنة الموزاريلا الفاخرة.',
      price: 160.0,
      rating: 4.8,
      imagePath: 'assets/images/sultan_pizza_cover.png',
      deliveryTime: '25-35 دقيقة',
      categoryId: 'pizza',
      isPopular: true,
    ),
    FoodItem(
      id: '3',
      title: 'وجبة كباب وكفتة ضاني',
      restaurantId: 'rest_2',
      restaurant: 'حضرموت شيخ العرب',
      description:
          'مشويات مشكلة على الفحم مع أرز بسمتي بالسمن البلدي، سلطات، وطحينة، وعيش بلدي.',
      price: 240.0,
      rating: 4.9,
      imagePath: 'assets/images/hadramout_cover.png',
      deliveryTime: '20-30 دقيقة',
      categoryId: 'soup',
      isPopular: true,
    ),
    FoodItem(
      id: '4',
      title: 'ستيك ريب آي بصوص المشروم',
      restaurantId: 'rest_4',
      restaurant: 'أسماك المحيط جرجا',
      description:
          'قطعة ستيك طازجة مشوية بصلصة المشروم الكريمة مع خضار سوتيه وبطاطس بيوريه.',
      price: 290.0,
      rating: 4.7,
      imagePath: 'assets/images/special_steak.png',
      deliveryTime: '30-40 دقيقة',
      categoryId: 'salad',
      isPopular: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final favIds = appState.favoriteIds;
        final favItems =
            _allFoods.where((food) => favIds.contains(food.id)).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                // Top Header Container matching Home & Restaurants pages
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
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'المفضلة',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'وجباتك المفضلة والمحفوظة',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Main Body
                Expanded(
                  child: favItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border_rounded,
                                size: 80,
                                color: AppColors.textLight.withValues(alpha: 0.6),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'لا توجد وجبات مفضلة حتى الآن',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'اضغط على القلب في أي وجبة لحفظها في المفضلة!',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(20),
                  itemCount: favItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final food = favItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailsScreen(food: food),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Image
                            Container(
                              width: 70,
                              height: 70,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.cardBg,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Image.asset(
                                food.imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.fastfood,
                                        color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Food Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    food.restaurant,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${food.price.toStringAsFixed(0)} ج.م',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Heart Toggle
                            IconButton(
                              icon: const Icon(
                                Icons.favorite_rounded,
                                color: AppColors.primary,
                              ),
                              onPressed: () => appState.toggleFavorite(food.id),
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
