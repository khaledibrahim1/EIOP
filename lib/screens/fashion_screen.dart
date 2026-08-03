import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/fashion_item.dart';
import '../theme/app_colors.dart';
import '../widgets/multi_service_product_card.dart';

class FashionScreen extends StatefulWidget {
  const FashionScreen({super.key});

  @override
  State<FashionScreen> createState() => _FashionScreenState();
}

class _FashionScreenState extends State<FashionScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'الكل';
  String _selectedAudience = 'الكل'; // 'الكل', 'رجالي', 'حريمي', 'أطفال'
  String _selectedSort = 'الافتراضي';
  int _selectedViewTab = 0; // 0: All Products, 1: Boutiques & Stores

  final Set<String> _favoriteItemIds = {};

  final List<Map<String, dynamic>> _audienceOptions = const [
    {'name': 'الكل', 'icon': Icons.grid_view_rounded},
    {'name': 'رجالي', 'icon': Icons.man_rounded},
    {'name': 'حريمي', 'icon': Icons.woman_rounded},
    {'name': 'أطفال', 'icon': Icons.child_friendly_rounded},
  ];

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'الكل', 'icon': Icons.grid_view_rounded},
    {'name': 'قمصان', 'icon': Icons.checkroom_rounded},
    {'name': 'بناطيل', 'icon': Icons.dry_cleaning_rounded},
    {'name': 'جاكيتات', 'icon': Icons.shield_rounded},
    {'name': 'أحذية رجالية', 'icon': Icons.roller_skating_rounded},
    {'name': 'أحذية نسائية', 'icon': Icons.do_not_step_rounded},
    {'name': 'رياضي', 'icon': Icons.sports_soccer_rounded},
    {'name': 'كلاسيك', 'icon': Icons.work_rounded},
    {'name': 'ملابس أطفال', 'icon': Icons.child_care_rounded},
    {'name': 'ملابس محتشمة', 'icon': Icons.face_3_rounded},
    {'name': 'إكسسوارات', 'icon': Icons.watch_rounded},
  ];

  final List<String> _sortOptions = const [
    'الافتراضي', 'الأحدث', 'الأعلى تقييماً', 'السعر: من الأقل للأعلى', 'السعر: من الأعلى للأقل',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteItemIds.contains(id)) {
        _favoriteItemIds.remove(id);
      } else {
        _favoriteItemIds.add(id);
      }
    });
  }

  bool _matchesAudience(FashionItem item, String audience) {
    if (audience == 'الكل') return true;
    final cat = item.category.toLowerCase();
    final title = item.title.toLowerCase();
    final specs = item.specs.toLowerCase();

    if (audience == 'رجالي') {
      return cat.contains('رجالي') ||
          cat.contains('قمصان') ||
          cat.contains('بناطيل') ||
          cat.contains('جاكيتات') ||
          cat.contains('كلاسيك') ||
          title.contains('رجالي') ||
          specs.contains('رجالي');
    }
    if (audience == 'حريمي') {
      return cat.contains('نسائ') ||
          cat.contains('حريم') ||
          cat.contains('محتشمة') ||
          cat.contains('عباءة') ||
          title.contains('نسائ') ||
          title.contains('عباءة') ||
          title.contains('حريم');
    }
    if (audience == 'أطفال') {
      return cat.contains('أطفال') ||
          title.contains('أطفال') ||
          title.contains('طفل') ||
          specs.contains('أطفال');
    }
    return true;
  }

  List<FashionItem> get _filteredItems {
    List<FashionItem> items = sampleFashionItems.where((item) {
      if (_selectedCategory != 'الكل' && item.category != _selectedCategory) {
        return false;
      }
      if (!_matchesAudience(item, _selectedAudience)) {
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

    if (_selectedSort == 'الأحدث') {
      items.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
    } else if (_selectedSort == 'الأعلى تقييماً') {
      items.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_selectedSort == 'السعر: من الأقل للأعلى') {
      items.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'السعر: من الأعلى للأقل') {
      items.sort((a, b) => b.price.compareTo(a.price));
    }

    return items;
  }

  void _showProductDetailsModal(FashionItem item) {
    int quantity = 1;
    String? selectedSize = item.availableSizes.isNotEmpty ? item.availableSizes.first : null;
    String? selectedColor = item.availableColors.isNotEmpty ? item.availableColors.first : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final bool isFav = _favoriteItemIds.contains(item.id);
            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: Color(0xFF0B1120),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(top: BorderSide(color: Color(0xFFE11D48), width: 2)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 48, height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Hero Showcase
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              height: 240,
                              color: const Color(0xFF1E293B),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      item.imagePath,
                                      height: 240,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, e, st) => Container(
                                        color: const Color(0xFF1E293B),
                                        child: const Center(
                                          child: Icon(
                                            Icons.checkroom_rounded,
                                            size: 90, color: Color(0xFFE11D48),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Gradient Overlay
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.7),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Favorite Button
                                  Positioned(
                                    top: 14, right: 14,
                                    child: GestureDetector(
                                      onTap: () {
                                        _toggleFavorite(item.id);
                                        setModalState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white24),
                                        ),
                                        child: Icon(
                                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                          color: isFav ? const Color(0xFFE11D48) : Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Badges
                                  Positioned(
                                    bottom: 14, right: 14,
                                    child: Row(
                                      children: [
                                        if (item.isNew)
                                          Container(
                                            margin: const EdgeInsets.only(left: 6),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                                            ),
                                            child: const Text('جديد 🌟',
                                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                          ),
                                        if (item.isBestSeller)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFE11D48), Color(0xFFBE185D)],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                                            ),
                                            child: const Text('الأكثر مبيعاً 🔥',
                                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Title & Brand
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE11D48).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFE11D48).withValues(alpha: 0.4)),
                                ),
                                child: Text(item.brand,
                                    style: const TextStyle(color: Color(0xFFE11D48), fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Rating & Store
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text('${item.rating}',
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              Text('(${item.reviewCount} تقييم)',
                                  style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(width: 12),
                              const Text('•', style: TextStyle(color: Colors.white38)),
                              const SizedBox(width: 12),
                              const Icon(Icons.storefront_rounded, color: Colors.white54, size: 15),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(item.storeName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Price Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('السعر النهائي:',
                                        style: TextStyle(color: Colors.white54, fontSize: 11)),
                                    const SizedBox(height: 2),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text('${item.price.toStringAsFixed(0)} ',
                                            style: const TextStyle(color: Color(0xFFE11D48), fontSize: 26, fontWeight: FontWeight.w900)),
                                        const Text('ج.م',
                                            style: TextStyle(color: Color(0xFFE11D48), fontSize: 14, fontWeight: FontWeight.bold)),
                                        if (item.oldPrice != null) ...[
                                          const SizedBox(width: 10),
                                          Text('${item.oldPrice!.toStringAsFixed(0)} ج.م',
                                              style: const TextStyle(color: Colors.white38, fontSize: 13, decoration: TextDecoration.lineThrough)),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                                if (item.oldPrice != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE11D48),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'خصم ${(((item.oldPrice! - item.price) / item.oldPrice!) * 100).toStringAsFixed(0)}%',
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Specs
                          if (item.specs.isNotEmpty) ...[
                            const Text('مواصفات المنتج:',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(item.specs,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.6)),
                            ),
                            const SizedBox(height: 18),
                          ],
                          // Available Colors
                          if (item.availableColors.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('اللون:',
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                if (selectedColor != null)
                                  Text(selectedColor!,
                                      style: const TextStyle(color: Color(0xFFE11D48), fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10, runSpacing: 10,
                              children: item.availableColors.map((color) {
                                final isSel = selectedColor == color;
                                return GestureDetector(
                                  onTap: () => setModalState(() => selectedColor = color),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSel ? const Color(0xFFE11D48) : const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSel ? const Color(0xFFE11D48) : Colors.white24,
                                      ),
                                      boxShadow: isSel ? [
                                        BoxShadow(color: const Color(0xFFE11D48).withValues(alpha: 0.4), blurRadius: 8)
                                      ] : null,
                                    ),
                                    child: Text(color,
                                        style: TextStyle(
                                          color: isSel ? Colors.white : Colors.white70,
                                          fontSize: 12, fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 18),
                          ],
                          // Sizes
                          if (item.availableSizes.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('المقاس:',
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                if (selectedSize != null)
                                  Text(selectedSize!,
                                      style: const TextStyle(color: Color(0xFFE11D48), fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10, runSpacing: 10,
                              children: item.availableSizes.map((size) {
                                final isSel = selectedSize == size;
                                return GestureDetector(
                                  onTap: () => setModalState(() => selectedSize = size),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    constraints: const BoxConstraints(minWidth: 54), height: 42,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: isSel ? const Color(0xFFE11D48) : const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isSel ? const Color(0xFFE11D48) : Colors.white24,
                                      ),
                                      boxShadow: isSel ? [
                                        BoxShadow(color: const Color(0xFFE11D48).withValues(alpha: 0.4), blurRadius: 8)
                                      ] : null,
                                    ),
                                    child: Text(size,
                                        style: TextStyle(
                                          color: isSel ? Colors.white : Colors.white70,
                                          fontSize: 12, fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Add to Cart Bar
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_rounded, color: Colors.white70, size: 20),
                                      onPressed: () {
                                        if (quantity > 1) setModalState(() => quantity--);
                                      },
                                    ),
                                    Text('$quantity',
                                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: const Icon(Icons.add_rounded, color: Color(0xFFE11D48), size: 20),
                                      onPressed: () => setModalState(() => quantity++),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE11D48),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    elevation: 6,
                                    shadowColor: const Color(0xFFE11D48).withValues(alpha: 0.4),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تمت إضافة ${item.title} ($quantity قطعة) للسلة! 🛍️'),
                                        backgroundColor: const Color(0xFFE11D48),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'أضف للسلة (${(item.price * quantity).toStringAsFixed(0)} ج.م)',
                                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
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
              if (selectedStoreCategory != 'الكل' && item.category != selectedStoreCategory) {
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
                color: Color(0xFF0B1120),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(top: BorderSide(color: Color(0xFFE11D48), width: 2)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 48, height: 5,
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60, height: 60,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE11D48), Color(0xFFBE185D)],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                            ),
                            child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(store.name,
                                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 18),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(store.location, maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white60, fontSize: 11)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                    const SizedBox(width: 4),
                                    Text('${store.rating} • التوصيل ${store.deliveryTime}',
                                        style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: TextField(
                        controller: storeSearchCtrl,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (v) => setModalState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'ابحث في تشكيلة المحل...',
                          hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFFE11D48), size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: ['الكل', ...store.categories].length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = ['الكل', ...store.categories][index];
                        final isSel = selectedStoreCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSel,
                          selectedColor: const Color(0xFFE11D48),
                          backgroundColor: const Color(0xFF1E293B),
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (val) => setModalState(() => selectedStoreCategory = val ? cat : 'الكل'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: storeProducts.isEmpty
                        ? const Center(
                            child: Text('لا توجد منتجات مطابقة في هذا المحل',
                                style: TextStyle(color: Colors.white54, fontSize: 13)),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            itemCount: storeProducts.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.62,
                              crossAxisSpacing: 14, mainAxisSpacing: 14,
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
                                  subtitle: '${item.brand} • ${item.storeName}',
                                  price: item.price,
                                  oldPrice: item.oldPrice,
                                  imagePath: item.imagePath,
                                  accentColor: const Color(0xFFE11D48),
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
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE11D48).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.checkroom_rounded, color: Color(0xFFE11D48), size: 18),
            ),
            const SizedBox(width: 8),
            const Text('أزياء وموضة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE11D48))),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: appState,
            builder: (context, child) {
              final count = appState.totalItemCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_rounded, color: Color(0xFFE11D48)),
                    onPressed: () {},
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6, top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFFE11D48), shape: BoxShape.circle),
                        child: Text('$count',
                            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
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
            // 1. SEARCH BAR AT TOP OF PAGE
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() {}),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن ملابس، أحذية، عروض في جرجا...',
                    hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFE11D48), size: 22),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  ),
                ),
              ),
            ),

            // 2. PROMO BANNER
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: FashionPromoBanner(),
            ),

            // 3. VIEW MODE SWITCHER TABS (كافة الأزياء vs المحلات والمنيو)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedViewTab = 0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedViewTab == 0 ? const Color(0xFFE11D48) : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: _selectedViewTab == 0 ? [
                            BoxShadow(color: const Color(0xFFE11D48).withValues(alpha: 0.3), blurRadius: 8)
                          ] : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.checkroom_rounded, size: 18,
                                color: _selectedViewTab == 0 ? Colors.white : AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text('كافة الأزياء',
                                style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold,
                                  color: _selectedViewTab == 0 ? Colors.white : AppColors.textSecondary,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedViewTab = 1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedViewTab == 1 ? const Color(0xFFE11D48) : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: _selectedViewTab == 1 ? [
                            BoxShadow(color: const Color(0xFFE11D48).withValues(alpha: 0.3), blurRadius: 8)
                          ] : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.storefront_rounded, size: 18,
                                color: _selectedViewTab == 1 ? Colors.white : AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text('المحلات والمنيو',
                                style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold,
                                  color: _selectedViewTab == 1 ? Colors.white : AppColors.textSecondary,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 4. AUDIENCE FILTER STRIP (رجالي ، حريمي ، أطفال)
            if (_selectedViewTab == 0) ...[
              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _audienceOptions.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final aud = _audienceOptions[index];
                    final String name = aud['name'];
                    final IconData icon = aud['icon'];
                    final isSelected = _selectedAudience == name;

                    return ChoiceChip(
                      avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFFE11D48)),
                      label: Text(name),
                      selected: isSelected,
                      selectedColor: const Color(0xFFE11D48),
                      backgroundColor: AppColors.cardBg,
                      elevation: isSelected ? 4 : 0,
                      shadowColor: const Color(0xFFE11D48).withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 12, fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) { if (val) setState(() => _selectedAudience = name); },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],

            // 5. PRODUCTS SECTION OR STORES SECTION
            _selectedViewTab == 1 ? _buildStoresListView() : _buildProductsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Chips with Icons
        SizedBox(
          height: 42,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final String name = cat['name'];
              final IconData icon = cat['icon'];
              final isSelected = _selectedCategory == name;

              return ChoiceChip(
                avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFFE11D48)),
                label: Text(name),
                selected: isSelected,
                selectedColor: const Color(0xFFE11D48),
                backgroundColor: AppColors.cardBg,
                elevation: isSelected ? 4 : 0,
                shadowColor: const Color(0xFFE11D48).withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontSize: 12, fontWeight: FontWeight.bold,
                ),
                onSelected: (val) { if (val) setState(() => _selectedCategory = name); },
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Section Header & Sort Menu
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أحدث الأزياء المتوفرة (${_filteredItems.length}):',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              // Sort Popup Menu
              PopupMenuButton<String>(
                initialValue: _selectedSort,
                onSelected: (val) => setState(() => _selectedSort = val),
                color: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sort_rounded, color: Color(0xFFE11D48), size: 16),
                      const SizedBox(width: 4),
                      Text(_selectedSort,
                          style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                itemBuilder: (ctx) => _sortOptions.map((opt) {
                  return PopupMenuItem<String>(
                    value: opt,
                    child: Text(opt, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Product Grid View
        if (_filteredItems.isEmpty)
          Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.checkroom_outlined, size: 54, color: Colors.grey),
                  const SizedBox(height: 14),
                  const Text('لا توجد أزياء مطابقة للبحث أو التصفية',
                      style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedCategory = 'الكل';
                      _selectedAudience = 'الكل';
                      _selectedSort = 'الافتراضي';
                      _searchController.clear();
                    }),
                    child: const Text('إعادة ضبط الفلاتر',
                        style: TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.bold)),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.62,
              crossAxisSpacing: 14, mainAxisSpacing: 14,
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
                  accentColor: const Color(0xFFE11D48),
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

  Widget _buildStoresListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('بوتيكات ومحلات أزياء جرجا (${girgaFashionStores.length}):',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Row(
                children: [
                  Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 16),
                  SizedBox(width: 4),
                  Text('مضمونة ومعتمدة',
                      style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: girgaFashionStores.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final store = girgaFashionStores[index];
            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE11D48), Color(0xFFBE185D)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFFE11D48).withValues(alpha: 0.3), blurRadius: 8),
                          ],
                        ),
                        child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(store.name,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 18),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(store.location,
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text('${store.rating} • التوصيل ${store.deliveryTime}',
                                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8, runSpacing: 6,
                    children: store.categories.map((cat) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE11D48).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE11D48).withValues(alpha: 0.2)),
                        ),
                        child: Text(cat,
                            style: const TextStyle(color: Color(0xFFE11D48), fontSize: 11, fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity, height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE11D48),
                        elevation: 4,
                        shadowColor: const Color(0xFFE11D48).withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => _openStoreMenuModal(store),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.style_rounded, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'تصفح تشكيلة وتصاميم المحل 👗',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
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

// ─────────────────────────────────────────────────────────────────
//  FASHION PROMO BANNER  –  real photo background
// ─────────────────────────────────────────────────────────────────
class _FashionPromoOffer {
  final String badgeText;
  final String title;
  final String subtitleText;
  final String discountNum;
  final String footerNote;
  final String buttonText;
  final String imagePath;
  final List<Color> overlayColors;

  const _FashionPromoOffer({
    required this.badgeText,
    required this.title,
    required this.subtitleText,
    required this.discountNum,
    required this.footerNote,
    required this.buttonText,
    required this.imagePath,
    required this.overlayColors,
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
      imagePath: 'assets/images/fashion_banner_1.png',
      overlayColors: [Color(0xDD831843), Color(0x99BE185D)],
    ),
    _FashionPromoOffer(
      badgeText: 'أحذية بأسعار مذهلة! 👟',
      title: 'Nike • Adidas • Clarks – تخفيضات حصرية',
      subtitleText: 'خصم يبدأ من',
      discountNum: '30',
      footerNote: 'سنتر المدينة للأحذية • ضمان 6 أشهر',
      buttonText: 'اكتشف العروض',
      imagePath: 'assets/images/fashion_banner_2.png',
      overlayColors: [Color(0xDD1E3A5F), Color(0x992563EB)],
    ),
    _FashionPromoOffer(
      badgeText: 'الملابس المحتشمة الأنيقة! 👗',
      title: 'عباءات وأزياء محتشمة بتصاميم عصرية',
      subtitleText: 'وفر حتى',
      discountNum: '35',
      footerNote: 'نيو ستايل جرجا • تسليم بالبيت',
      buttonText: 'استعرض التشكيلة',
      imagePath: 'assets/images/fashion_banner_3.png',
      overlayColors: [Color(0xDD3B1F5F), Color(0x997C3AED)],
    ),
  ];

  final List<List<Color>> _fallbackGradients = const [
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
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _offers.length,
            itemBuilder: (context, index) =>
                _buildCard(_offers[index], _fallbackGradients[index]),
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
              width: isSel ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSel
                    ? const Color(0xFFE11D48)
                    : Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCard(_FashionPromoOffer offer, List<Color> gradientColors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.5),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              offer.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (ctx, e, st) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      offer.overlayColors[0],
                      offer.overlayColors[1],
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0x88000000), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6)],
                      ),
                      child: Text(
                        offer.badgeText,
                        style: TextStyle(
                          color: gradientColors[0], fontSize: 10, fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          offer.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white, fontSize: 13,
                            fontWeight: FontWeight.bold, height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${offer.subtitleText} ',
                            style: const TextStyle(
                              color: Colors.white, fontSize: 11,
                              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                          ),
                          Text(
                            offer.discountNum,
                            style: const TextStyle(
                              color: Colors.white, fontSize: 32,
                              fontWeight: FontWeight.w900, height: 1.0,
                              shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
                            ),
                          ),
                          const SizedBox(width: 3),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Text('%',
                                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          offer.footerNote,
                          style: const TextStyle(
                            color: Colors.white70, fontSize: 9,
                            shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.95),
                          foregroundColor: gradientColors[0],
                          elevation: 6,
                          shadowColor: Colors.black.withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          minimumSize: const Size(0, 30),
                        ),
                        child: Text(
                          offer.buttonText,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold, color: gradientColors[0]),
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
