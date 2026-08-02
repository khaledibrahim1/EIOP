import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/fashion_item.dart';
import '../theme/app_colors.dart';
import '../widgets/multi_service_product_card.dart';

// ───────────────────────────────────────────────────────────────
//  FASHION SCREEN – full featured, matching ElectronicsScreen style
// ───────────────────────────────────────────────────────────────

class FashionScreen extends StatefulWidget {
  const FashionScreen({super.key});

  @override
  State<FashionScreen> createState() => _FashionScreenState();
}

class _FashionScreenState extends State<FashionScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'الكل';
  String _selectedBrand = 'الكل';
  String? _selectedStoreFilter;
  int _selectedViewTab = 0; // 0 = Products, 1 = Stores & Menus

  final List<String> _categories = const [
    'الكل',
    'قمصان',
    'بناطيل',
    'جاكيتات',
    'أحذية رجالية',
    'أحذية نسائية',
    'رياضي',
    'كلاسيك',
    'ملابس أطفال',
    'ملابس محتشمة',
    'إكسسوارات',
  ];

  final List<String> _brands = const [
    'الكل',
    'Zara',
    'H&M',
    "Levi's",
    'Nike',
    'Adidas',
    'Clarks',
    'Aldo',
    'Gap',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FashionItem> get _filteredItems {
    return sampleFashionItems.where((item) {
      if (_selectedCategory != 'الكل' && item.category != _selectedCategory) {
        return false;
      }
      if (_selectedBrand != 'الكل' && !item.brand.contains(_selectedBrand)) {
        return false;
      }
      if (_selectedStoreFilter != null && item.storeName != _selectedStoreFilter) {
        return false;
      }
      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        return item.title.toLowerCase().contains(query) ||
            item.brand.toLowerCase().contains(query) ||
            item.specs.toLowerCase().contains(query) ||
            item.storeName.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  // ── Product Detail Bottom Sheet ──────────────────────────────
  void _showProductDetailsModal(FashionItem item) {
    int quantity = 1;
    String? selectedSize;
    String? selectedColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Handle
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Hero
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              height: 200,
                              color: const Color(0xFF1E293B),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      item.imagePath,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, e, st) => const Icon(
                                        Icons.checkroom_rounded,
                                        size: 80,
                                        color: Color(0xFFEC4899),
                                      ),
                                    ),
                                  ),
                                  if (item.isNew)
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Text('جديد',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  if (item.isBestSeller)
                                    Positioned(
                                      top: 12,
                                      left: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEC4899),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Text('الأكثر مبيعاً',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Title + Brand
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFEC4899).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.brand,
                                  style: const TextStyle(
                                    color: Color(0xFFEC4899),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 14),
                              const SizedBox(width: 3),
                              Text(
                                '${item.rating} (${item.reviewCount} تقييم)',
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Price
                          Row(
                            children: [
                              Text(
                                '${item.price.toStringAsFixed(0)} ج.م',
                                style: const TextStyle(
                                  color: Color(0xFFEC4899),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              if (item.oldPrice != null) ...[
                                const SizedBox(width: 10),
                                Text(
                                  '${item.oldPrice!.toStringAsFixed(0)} ج.م',
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEC4899)
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '-${(((item.oldPrice! - item.price) / item.oldPrice!) * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: Color(0xFFEC4899),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'من ${item.storeName}',
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 11),
                          ),
                          const SizedBox(height: 16),

                          // Specs
                          if (item.specs.isNotEmpty) ...[
                            const Text(
                              'المواصفات:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.specs,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Colors
                          if (item.availableColors.isNotEmpty) ...[
                            const Text(
                              'الألوان المتاحة:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: item.availableColors.map((color) {
                                final isSel = selectedColor == color;
                                return GestureDetector(
                                  onTap: () =>
                                      setModalState(() => selectedColor = color),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isSel
                                          ? const Color(0xFFEC4899)
                                          : const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSel
                                            ? const Color(0xFFEC4899)
                                            : Colors.white24,
                                      ),
                                    ),
                                    child: Text(
                                      color,
                                      style: TextStyle(
                                        color: isSel
                                            ? Colors.white
                                            : Colors.white70,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Sizes
                          const Text(
                            'المقاسات المتاحة:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: item.availableSizes.map((size) {
                              final isSel = selectedSize == size;
                              return GestureDetector(
                                onTap: () =>
                                    setModalState(() => selectedSize = size),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 52,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSel
                                        ? const Color(0xFFEC4899)
                                        : const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSel
                                          ? const Color(0xFFEC4899)
                                          : Colors.white24,
                                    ),
                                  ),
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color: isSel
                                          ? Colors.white
                                          : Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          // Quantity + Add
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_rounded,
                                          color: Colors.white70, size: 20),
                                      onPressed: () {
                                        if (quantity > 1) {
                                          setModalState(() => quantity--);
                                        }
                                      },
                                    ),
                                    Text(
                                      '$quantity',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_rounded,
                                          color: Color(0xFFEC4899), size: 20),
                                      onPressed: () =>
                                          setModalState(() => quantity++),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEC4899),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'تمت إضافة ${item.title} ($quantity قطعة) للسلة! 🛍️',
                                        ),
                                        backgroundColor:
                                            const Color(0xFFEC4899),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shopping_bag_rounded,
                                          color: Colors.white, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'أضف للسلة',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Store Menu Bottom Sheet ──────────────────────────────────
  void _openStoreMenuModal(FashionStoreModel store) {
    String selectedStoreCategory = 'الكل';
    final TextEditingController storeSearchCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final storeProducts = sampleFashionItems.where((item) {
              if (item.storeName != store.name) return false;
              if (selectedStoreCategory != 'الكل' &&
                  item.category != selectedStoreCategory) {
                return false;
              }
              final q = storeSearchCtrl.text.trim().toLowerCase();
              if (q.isNotEmpty) {
                return item.title.toLowerCase().contains(q) ||
                    item.brand.toLowerCase().contains(q);
              }
              return true;
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Store Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEC4899)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.storefront_rounded,
                              color: Color(0xFFEC4899),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        store.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified_rounded,
                                        color: Color(0xFF10B981), size: 16),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  store.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white60, fontSize: 11),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: Colors.amber, size: 14),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${store.rating} • ${store.deliveryTime}',
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 11),
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
                  const SizedBox(height: 12),

                  // Search inside store
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: storeSearchCtrl,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13),
                        onChanged: (_) => setModalState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'ابحث في منيو المحل...',
                          hintStyle:
                              TextStyle(color: Colors.white38, fontSize: 12),
                          prefixIcon: Icon(Icons.search_rounded,
                              color: Color(0xFFEC4899), size: 18),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category chips
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: ['الكل', ...store.categories].length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final cat =
                            ['الكل', ...store.categories][index];
                        final isSel = selectedStoreCategory == cat;
                        return FilterChip(
                          label: Text(cat),
                          selected: isSel,
                          selectedColor: const Color(0xFFEC4899),
                          backgroundColor: const Color(0xFF1E293B),
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : Colors.white70,
                            fontSize: 11,
                            fontWeight: isSel
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (val) => setModalState(
                              () => selectedStoreCategory =
                                  val ? cat : 'الكل'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Products grid
                  Expanded(
                    child: storeProducts.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد منتجات مطابقة في هذا المحل',
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 13),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            itemCount: storeProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.64,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              final item = storeProducts[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  _showProductDetailsModal(item);
                                },
                                child: MultiServiceProductCard(
                                  id: item.id,
                                  title: item.title,
                                  subtitle:
                                      '${item.brand} • ${item.storeName}',
                                  price: item.price,
                                  oldPrice: item.oldPrice,
                                  imagePath: item.imagePath,
                                  accentColor: const Color(0xFFEC4899),
                                  categoryTag: item.brand,
                                  rating: item.rating,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── BUILD ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.checkroom_rounded, color: Color(0xFFEC4899)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'أزياء وموضة',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEC4899),
                ),
              ),
            ),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: appState,
            builder: (context, _) {
              final count = appState.totalItemCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_rounded,
                        color: Color(0xFFEC4899)),
                    onPressed: () {},
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEC4899),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PROMO BANNER
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: FashionPromoBanner(),
            ),

            // 2. SEARCH
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3)),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن ملابس، أحذية، ماركة أو محل...',
                    hintStyle:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFFEC4899), size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                size: 18, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),

            // 3. VIEW MODE TAB SWITCHER
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedViewTab = 0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedViewTab == 0
                              ? const Color(0xFFEC4899)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.checkroom_rounded,
                                size: 16,
                                color: _selectedViewTab == 0
                                    ? Colors.white
                                    : AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              'كافة الأزياء',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _selectedViewTab == 0
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedViewTab = 1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedViewTab == 1
                              ? const Color(0xFFEC4899)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.storefront_rounded,
                                size: 16,
                                color: _selectedViewTab == 1
                                    ? Colors.white
                                    : AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              'المحلات والمنيو',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _selectedViewTab == 1
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _selectedViewTab == 1
                ? _buildStoresListView()
                : _buildProductsSection(),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          final count = appState.totalItemCount;
          final total = appState.grandTotal;
          if (count == 0) return const SizedBox.shrink();
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEC4899).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEC4899).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.shopping_bag_rounded,
                          color: Color(0xFFEC4899), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('السلة الحالية',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 11)),
                        Text(
                          '${total.toStringAsFixed(0)} ج.م',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC4899),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Text('إتمام الطلب',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Products Section ─────────────────────────────────────────
  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category chips
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: const Color(0xFFEC4899),
                backgroundColor: AppColors.cardBg,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (val) {
                  if (val) setState(() => _selectedCategory = cat);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // Brand chips
        SizedBox(
          height: 34,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _brands.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: 6),
            itemBuilder: (context, index) {
              final brand = _brands[index];
              final isSelected = _selectedBrand == brand;
              return FilterChip(
                label: Text(brand),
                selected: isSelected,
                selectedColor:
                    const Color(0xFFEC4899).withValues(alpha: 0.2),
                checkmarkColor: const Color(0xFFEC4899),
                backgroundColor: AppColors.cardBg,
                labelStyle: TextStyle(
                  color: isSelected
                      ? const Color(0xFFEC4899)
                      : AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (val) {
                  setState(
                      () => _selectedBrand = val ? brand : 'الكل');
                },
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        // Stores preview strip
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'محلات الأزياء المعتمدة بجرجا',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              if (_selectedStoreFilter != null)
                GestureDetector(
                  onTap: () =>
                      setState(() => _selectedStoreFilter = null),
                  child: const Text('عرض الكل',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFEC4899),
                          fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 72,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: girgaFashionStores.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final store = girgaFashionStores[index];
              final isSelected = _selectedStoreFilter == store.name;
              return GestureDetector(
                onTap: () => _openStoreMenuModal(store),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1E0512)
                        : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFEC4899)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEC4899)
                              .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.storefront_rounded,
                            color: Color(0xFFEC4899), size: 18),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            store.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? const Color(0xFFEC4899)
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 12),
                              const SizedBox(width: 3),
                              Text(
                                '${store.rating} • ${store.deliveryTime}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        // Products heading
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedStoreFilter != null
                    ? 'منتجات ${_selectedStoreFilter!}:'
                    : 'أحدث الأزياء المتوفرة (${_filteredItems.length}):',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text('تسليم في نفس اليوم',
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 12),

        if (_filteredItems.isEmpty)
          Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.checkroom_outlined,
                      size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'لا توجد أزياء مطابقة للبحث',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedCategory = 'الكل';
                      _selectedBrand = 'الكل';
                      _selectedStoreFilter = null;
                      _searchController.clear();
                    }),
                    child: const Text('إعادة ضبط الفلاتر',
                        style:
                            TextStyle(color: Color(0xFFEC4899))),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredItems.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.64,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return GestureDetector(
                onTap: () => _showProductDetailsModal(item),
                child: MultiServiceProductCard(
                  id: item.id,
                  title: item.title,
                  subtitle: '${item.brand} • ${item.storeName}',
                  price: item.price,
                  oldPrice: item.oldPrice,
                  imagePath: item.imagePath,
                  accentColor: const Color(0xFFEC4899),
                  categoryTag: item.brand,
                  rating: item.rating,
                ),
              );
            },
          ),
        const SizedBox(height: 30),
      ],
    );
  }

  // ── Stores Directory Section ──────────────────────────────────
  Widget _buildStoresListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'محلات أزياء جرجا (${girgaFashionStores.length}):',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Text('تغطية كاملة',
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: girgaFashionStores.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final store = girgaFashionStores[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEC4899)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.storefront_rounded,
                            color: Color(0xFFEC4899), size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    store.name,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded,
                                    color: Color(0xFF10B981),
                                    size: 16),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              store.location,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Colors.amber, size: 14),
                                const SizedBox(width: 3),
                                Text(
                                  '${store.rating} • التوصيل ${store.deliveryTime}',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: store.categories.map((cat) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEC4899)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          cat,
                          style: const TextStyle(
                            color: Color(0xFFEC4899),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEC4899),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => _openStoreMenuModal(store),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.style_rounded,
                              color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'تصفح تشكيلة المحل 👗',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ── Fashion Promo Banner ─────────────────────────────────────────
class _FashionPromoOffer {
  final String badgeText;
  final String title;
  final String subtitleText;
  final String discountNum;
  final String footerNote;
  final String buttonText;

  const _FashionPromoOffer({
    required this.badgeText,
    required this.title,
    required this.subtitleText,
    required this.discountNum,
    required this.footerNote,
    required this.buttonText,
  });
}

class FashionPromoBanner extends StatefulWidget {
  const FashionPromoBanner({super.key});

  @override
  State<FashionPromoBanner> createState() => _FashionPromoBannerState();
}

class _FashionPromoBannerState extends State<FashionPromoBanner> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  final List<_FashionPromoOffer> _offers = const [
    _FashionPromoOffer(
      badgeText: 'عروض الموسم! 🌟',
      title: 'تشكيلة الخريف الجديدة من أرقى الماركات',
      subtitleText: 'خصم يصل حتى',
      discountNum: '40',
      footerNote: 'بوتيك الأناقة جرجا • كود: STYLE40',
      buttonText: 'تسوقي الآن',
    ),
    _FashionPromoOffer(
      badgeText: 'أحذية بأسعار مذهلة! 👟',
      title: 'Nike • Adidas • Clarks – تخفيضات حصرية',
      subtitleText: 'خصم يبدأ من',
      discountNum: '30',
      footerNote: 'سنتر المدينة للأحذية • ضمان 6 أشهر',
      buttonText: 'اكتشف العروض',
    ),
    _FashionPromoOffer(
      badgeText: 'الملابس المحتشمة الأنيقة! 👗',
      title: 'عباءات وأزياء محتشمة بتصاميم عصرية',
      subtitleText: 'وفر حتى',
      discountNum: '35',
      footerNote: 'نيو ستايل جرجا • تسليم بالبيت',
      buttonText: 'استعرض التشكيلة',
    ),
  ];

  // Gradient pairs per slide
  final List<List<Color>> _gradients = const [
    [Color(0xFF831843), Color(0xFFBE185D), Color(0xFFEC4899)],
    [Color(0xFF1E3A5F), Color(0xFF2563EB), Color(0xFF60A5FA)],
    [Color(0xFF3B1F5F), Color(0xFF7C3AED), Color(0xFFA78BFA)],
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % _offers.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 175,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) =>
                setState(() => _currentPage = index),
            itemCount: _offers.length,
            itemBuilder: (context, index) =>
                _buildCard(_offers[index], _gradients[index]),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_offers.length, (index) {
            final isSel = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isSel ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSel
                    ? const Color(0xFFEC4899)
                    : Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCard(
      _FashionPromoOffer offer, List<Color> gradientColors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Decorative circles
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Badge
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        offer.badgeText,
                        style: TextStyle(
                          color: gradientColors[0],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Title + discount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${offer.subtitleText} ',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            offer.discountNum,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Text('%',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Footer
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          offer.footerNote,
                          style: TextStyle(
                            color: Colors.white
                                .withValues(alpha: 0.75),
                            fontSize: 9,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: gradientColors[0],
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          minimumSize: const Size(0, 30),
                        ),
                        child: Text(
                          offer.buttonText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: gradientColors[0],
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
    );
  }
}
