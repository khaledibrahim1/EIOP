import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/food_item.dart';
import '../theme/app_colors.dart';

class MultiServiceProductCard extends StatefulWidget {
  final String id;
  final String title;
  final String subtitle;
  final double price;
  final double? oldPrice;
  final String imagePath;
  final Color accentColor;
  final String categoryTag;
  final double rating;
  final VoidCallback? onTap;

  const MultiServiceProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    this.oldPrice,
    required this.imagePath,
    required this.accentColor,
    required this.categoryTag,
    required this.rating,
    this.onTap,
  });

  @override
  State<MultiServiceProductCard> createState() => _MultiServiceProductCardState();
}

class _MultiServiceProductCardState extends State<MultiServiceProductCard> {
  bool _isPressed = false;

  int? get _discountPercent {
    if (widget.oldPrice == null || widget.oldPrice! <= widget.price) return null;
    final diff = widget.oldPrice! - widget.price;
    return ((diff / widget.oldPrice!) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final discount = _discountPercent;

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.12),
              width: 1,
            ),
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
              // Top Image Container with Tags
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.06),
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(22)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(22)),
                        child: Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(
                            child: Icon(
                              Icons.devices_other_rounded,
                              color: widget.accentColor,
                              size: 42,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Brand / Category Tag
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: widget.accentColor,
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
                          widget.categoryTag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Discount Ribbon Badge
                    if (discount != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.redAccent,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '-$discount%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    // Rating Badge
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.rating}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
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

              // Content Details & Add Button
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.oldPrice != null)
                              Text(
                                '${widget.oldPrice!.toStringAsFixed(0)} ج.م',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textLight,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              '${widget.price.toStringAsFixed(0)} ج.م',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: widget.accentColor,
                              ),
                            ),
                          ],
                        ),

                        // Add to Cart Button with Instant Animation Feedback
                        GestureDetector(
                          onTap: () {
                            final item = FoodItem(
                              id: widget.id,
                              title: widget.title,
                              restaurantId: 'store_generic',
                              restaurant: widget.subtitle,
                              price: widget.price,
                              rating: widget.rating,
                              deliveryTime: '15-30 دقيقة',
                              description: widget.title,
                              imagePath: widget.imagePath,
                              categoryId: widget.categoryTag,
                            );
                            appState.addToCart(item, quantity: 1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle_rounded,
                                        color: Colors.white, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'تم إضافة "${widget.title}" إلى السلة!',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: widget.accentColor,
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: widget.accentColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.accentColor.withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
