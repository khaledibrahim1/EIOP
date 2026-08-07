import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/food_item.dart';
import '../theme/app_colors.dart';

class FoodDetailsScreen extends StatefulWidget {
  final FoodItem food;

  const FoodDetailsScreen({super.key, required this.food});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentImageIndex = 0;
  int _quantity = 1;
  FoodOption? _selectedOption;
  late AnimationController _heartAnimController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.8,
      upperBound: 1.2,
    );

    // Default select first option if available
    if (widget.food.options.isNotEmpty) {
      _selectedOption = widget.food.options.first;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heartAnimController.dispose();
    super.dispose();
  }

  void _onFavoriteToggle() {
    _heartAnimController.forward().then((_) => _heartAnimController.reverse());
    appState.toggleFavorite(widget.food.id);
  }

  void _onAddToCart({bool directCheckout = false}) {
    appState.addToCart(
      widget.food,
      selectedOption: _selectedOption,
      quantity: _quantity,
    );

    final optionText =
        _selectedOption != null ? ' (${_selectedOption!.title})' : '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'تم إضافة ${widget.food.title}$optionText (x$_quantity) للسلة!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  double get _unitPrice =>
      widget.food.price + (_selectedOption?.priceOffset ?? 0.0);

  double get _totalPrice => _unitPrice * _quantity;

  void _openFullScreenImage(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.fastfood_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.6),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.food.allImages;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // 1. TOP HEADER CONTAINER WITH VERTICAL THUMBNAIL STACK (Matching Screenshot Layout)
                    _buildTopHeaderWithThumbnails(images),

                    // 2. BOTTOM DETAILS SHEET (Overlapping header bottom so image fills corner curves)
                    Container(
                      width: double.infinity,
                      transform: Matrix4.translationValues(0.0, -28.0, 0.0),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ROW 1: TITLE & QUANTITY STEPPER (Matching Screenshot)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.food.title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Pill Stepper: [- 01 +]
                              _buildPillQuantityStepper(),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // ROW 2: PRICE & RESTAURANT/RATING
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'السعر: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${_unitPrice.toStringAsFixed(0)} ج.م',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 18,
                                    color: AppColors.accentYellow,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.food.rating}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '• ${widget.food.restaurant}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // SECTION 3: SELECT SIZE (Horizontal Chips like Screenshot)
                          if (widget.food.options.isNotEmpty) ...[
                            _buildSizeChipsSection(),
                            const SizedBox(height: 24),
                          ],

                          // SECTION 4: DESCRIPTION
                          Text(
                            'الوصف',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.food.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. BOTTOM DUAL ACTION BUTTONS (Add to Cart & Order Now - Matching Screenshot)
            _buildBottomDualButtons(),
          ],
        ),
      ),
    );
  }

  /// Top Curved Header Box with Center Hero Image taking full area & Right-Side Vertical Thumbnails Column
  Widget _buildTopHeaderWithThumbnails(List<String> images) {
    return Container(
      height: 360,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
      ),
      child: Stack(
        children: [
          // Main Image PageView Slider taking FULL space of the header (Matching Mockup Screenshot)
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (idx) {
                setState(() {
                  _currentImageIndex = idx;
                });
              },
              itemBuilder: (context, idx) {
                final imgPath = images[idx];
                return GestureDetector(
                  onTap: () => _openFullScreenImage(imgPath),
                  child: Hero(
                    tag: 'food_hero_${widget.food.id}',
                    child: Image.asset(
                      imgPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        child: const Icon(
                          Icons.fastfood_rounded,
                          size: 120,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Top Action App Bar Floating Over Image
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Circle Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),

                  // Center Title: Details
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'تفاصيل المنتج',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  // Favorite Circle Button
                  ListenableBuilder(
                    listenable: appState,
                    builder: (context, _) {
                      final isFav = appState.isFavorite(widget.food.id);
                      return ScaleTransition(
                        scale: _heartAnimController,
                        child: GestureDetector(
                          onTap: _onFavoriteToggle,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: isFav
                                  ? AppColors.primary
                                  : AppColors.surface.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFav ? Colors.white : AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Right-Side Vertical Thumbnails Column Floating on Top Right
          Positioned(
            top: 90,
            right: 18,
            child: Column(
              children: List.generate(images.length, (idx) {
                final imgPath = images[idx];
                final isSelected = idx == _currentImageIndex;

                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      idx,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.white.withValues(alpha: 0.8),
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        imgPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.fastfood,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Pill Quantity Stepper: [- 01 +] (Matching Screenshot)
  Widget _buildPillQuantityStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus Button
          GestureDetector(
            onTap: () {
              if (_quantity > 1) {
                setState(() => _quantity--);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove_rounded,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              _quantity < 10 ? '0$_quantity' : '$_quantity',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Plus Button (Highlighted Primary Color)
          GestureDetector(
            onTap: () => setState(() => _quantity++),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Select Size Section (Horizontal Pill Chips like Screenshot)
  Widget _buildSizeChipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الخيار / المقاس',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal List of Round/Pill Size Chips
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.food.options.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, idx) {
              final option = widget.food.options[idx];
              final isSelected = _selectedOption?.id == option.id;
              final codeText = option.code ?? option.title;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOption = option;
                  });

                  if (option.imagePath != null) {
                    final imgIdx =
                        widget.food.allImages.indexOf(option.imagePath!);
                    if (imgIdx != -1) {
                      _pageController.animateToPage(
                        imgIdx,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.withValues(alpha: 0.2),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        codeText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (option.priceOffset > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '(+${option.priceOffset.toStringAsFixed(0)})',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.9)
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Bottom Dual Action Buttons Bar (Add to Cart & Order Now - Matching Screenshot)
  Widget _buildBottomDualButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Left Button: Add to Cart (Light Card / Outline Style)
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _onAddToCart(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardBg,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                      side: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'إضافة للسلة',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Right Button: Order Now (Primary Color Filled Button)
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _onAddToCart(directCheckout: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'اطلب الآن (${_totalPrice.toStringAsFixed(0)} ج.م)',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
