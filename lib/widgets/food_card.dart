import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/food_item.dart';
import '../theme/app_colors.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;
  final VoidCallback onPlaceOrder;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Full-Bleed Image with Floating Badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                  child: SizedBox(
                    height: 115,
                    width: double.infinity,
                    child: Hero(
                      tag: 'food_hero_${food.id}',
                      child: Image.asset(
                        food.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          color: AppColors.cardBg,
                          child: const Icon(
                            Icons.fastfood,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Top-Right Category Badge Tag
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(food.categoryId),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _getCategoryTag(food.categoryId),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Top-Left Floating Heart Circle (Red/Grey Heart)
                Positioned(
                  top: 8,
                  left: 8,
                  child: ListenableBuilder(
                    listenable: appState,
                    builder: (context, _) {
                      final isFav = appState.isFavorite(food.id);
                      return GestureDetector(
                        onTap: () => appState.toggleFavorite(food.id),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFav
                                ? const Color(0xFFEF4444)
                                : Colors.grey.shade600,
                            size: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom-Right Overlapping Delivery Time Tag (⏱ 15 دقيقة)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: Color(0xFF10B981),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          food.deliveryTime,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card Body Info Padding
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title & Rating
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFF59E0B),
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${food.rating}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                '(350 تقييم)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Price Pill & Action Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Green Price Badge Pill (like screenshot `$11.90`)
                        GestureDetector(
                          onTap: onPlaceOrder,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${food.price.toStringAsFixed(0)} ج.م',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Action Button (↗ icon like screenshot)
                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Icon(
                              Icons.north_east_rounded,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
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

  String _getCategoryTag(String categoryId) {
    switch (categoryId) {
      case 'food':
      case 'pizza':
      case 'burger':
      case 'dessert':
      case 'salad':
        return '🍕 مطاعم';
      case 'supermarket':
        return '🛒 سوبر ماركت';
      case 'pharmacy':
        return '💊 صيدلية';
      case 'electronics':
        return '📱 إلكترونيات';
      case 'fashion':
        return '👔 أزياء';
      case 'realEstate':
        return '🏠 عقارات';
      case 'jobs':
        return '💼 وظائف';
      case 'parcelDelivery':
        return '🛵 مرسول';
      default:
        return '✨ مميز';
    }
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'food':
      case 'pizza':
      case 'burger':
      case 'dessert':
      case 'salad':
        return const Color(0xFFFF5216);
      case 'supermarket':
        return const Color(0xFF10B981);
      case 'pharmacy':
        return const Color(0xFF06B6D4);
      case 'electronics':
        return const Color(0xFF6366F1);
      case 'fashion':
        return const Color(0xFFEC4899);
      case 'realEstate':
        return const Color(0xFF8B5CF6);
      case 'jobs':
        return const Color(0xFFF59E0B);
      case 'parcelDelivery':
        return const Color(0xFF0EA5E9);
      default:
        return const Color(0xFFFF5216);
    }
  }
}
