import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/electronics_item.dart';
import '../theme/app_colors.dart';
import '../widgets/multi_service_product_card.dart';

class ElectronicsScreen extends StatefulWidget {
  const ElectronicsScreen({super.key});

  @override
  State<ElectronicsScreen> createState() => _ElectronicsScreenState();
}

class _ElectronicsScreenState extends State<ElectronicsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  String _selectedBrand = 'الكل';
  String? _selectedStoreFilter;

  final List<String> _categories = const [
    'الكل',
    'هواتف وتابلت',
    'سماعات وصوتيات',
    'ساعات ذكية',
    'شواحن وكوابل',
    'إكسسوارات كمبيوتر',
  ];

  final List<String> _brands = const [
    'الكل',
    'Samsung',
    'Xiaomi',
    'Anker',
    'Joyroom',
    'Baseus',
    'Logitech',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ElectronicsItem> get _filteredItems {
    return sampleElectronicsItems.where((item) {
      // Category Filter
      if (_selectedCategory != 'الكل' && item.category != _selectedCategory) {
        return false;
      }
      // Brand Filter
      if (_selectedBrand != 'الكل' && item.brand != _selectedBrand) {
        return false;
      }
      // Store Filter
      if (_selectedStoreFilter != null &&
          item.storeName != _selectedStoreFilter) {
        return false;
      }
      // Search Query
      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final title = item.title.toLowerCase();
        final brand = item.brand.toLowerCase();
        final specs = item.specs.toLowerCase();
        final store = item.storeName.toLowerCase();
        return title.contains(query) ||
            brand.contains(query) ||
            specs.contains(query) ||
            store.contains(query);
      }
      return true;
    }).toList();
  }

  void _showProductDetailsModal(ElectronicsItem item) {
    int quantity = 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image & Badges
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Image.asset(
                          item.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.devices_other_rounded,
                            color: Color(0xFF6366F1),
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.brand,
                                style: const TextStyle(
                                  color: Color(0xFF818CF8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.rating} (${item.reviewsCount} تقييم)',
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
                  const SizedBox(height: 16),

                  // Specs Breakdown Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'المواصفات الفنية والمميزات:',
                          style: TextStyle(
                            color: Color(0xFF818CF8),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.specs,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        if (item.specTags.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: item.specTags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle_rounded,
                                        color: Color(0xFF10B981), size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      tag,
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 10),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Warranty & Store Banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.storefront_rounded,
                                color: Color(0xFF818CF8), size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'البائع: ${item.storeName}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                        if (item.hasWarranty)
                          const Row(
                            children: [
                              Icon(Icons.verified_user_rounded,
                                  color: Color(0xFF10B981), size: 14),
                              SizedBox(width: 4),
                              Text(
                                'ضمان معتمد',
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Price & Quantity Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'إجمالي السعر:',
                            style: TextStyle(color: Colors.white54, fontSize: 10),
                          ),
                          Row(
                            children: [
                              Text(
                                '${(item.price * quantity).toStringAsFixed(0)} ج.م',
                                style: const TextStyle(
                                  color: Color(0xFF6366F1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              if (item.oldPrice != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '${(item.oldPrice! * quantity).toStringAsFixed(0)} ج.م',
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),

                      // Quantity Selector
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_rounded,
                                  color: Colors.white, size: 18),
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_rounded,
                                  color: Colors.white, size: 18),
                              onPressed: () {
                                setModalState(() => quantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'تم إضافة ${item.title} ($quantity) للسلة بنجاح! 🛒'),
                            backgroundColor: const Color(0xFF6366F1),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'إضافة السلعة إلى السلة',
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
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.devices_other_rounded, color: Color(0xFF6366F1)),
            SizedBox(width: 8),
            Text(
              'مول الإلكترونيات والهواتف',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6366F1),
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
                    icon: Icon(Icons.shopping_cart_outlined,
                        color: AppColors.textPrimary),
                    onPressed: () {
                      // Navigate to cart or open order screen
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6366F1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
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
            // 1. TOP HERO TECH DEALS BANNER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1)
                                .withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            color: Color(0xFF818CF8),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'أحدث الأجهزة والإكسسوارات بجرجا ⚡',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'ضمان رسمي 24 شهر مع إمكانية المعاينة قبل الدفع',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _buildHeroFeatureBadge('ضمان معتمد', Icons.security_rounded),
                        const SizedBox(width: 8),
                        _buildHeroFeatureBadge('معاينة مجانية', Icons.search_rounded),
                        const SizedBox(width: 8),
                        _buildHeroFeatureBadge('توصيل فوري', Icons.electric_bolt_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 2. SEARCH INPUT BOX
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
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن هاتف، سماعة، شاحن أو الماركة...',
                    hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFF6366F1), size: 20),
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
            const SizedBox(height: 16),

            // 3. CATEGORIES CHOICE CHIPS
            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFF6366F1),
                    backgroundColor: AppColors.cardBg,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // 4. BRANDS HORIZONTAL FILTER CHIPS
            SizedBox(
              height: 34,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _brands.length,
                separatorBuilder: (context, index) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final brand = _brands[index];
                  final isSelected = _selectedBrand == brand;
                  return FilterChip(
                    label: Text(brand),
                    selected: isSelected,
                    selectedColor:
                        const Color(0xFF6366F1).withValues(alpha: 0.2),
                    checkmarkColor: const Color(0xFF6366F1),
                    backgroundColor: AppColors.cardBg,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      setState(() => _selectedBrand = val ? brand : 'الكل');
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 5. GIRGA VERIFIED ELECTRONICS STORES DIRECTORY
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'متاجر الإلكترونيات المعتمدة بجرجا',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedStoreFilter != null)
                    GestureDetector(
                      onTap: () => setState(() => _selectedStoreFilter = null),
                      child: const Text(
                        'عرض الكل',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                itemCount: girgaElectronicsStores.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final store = girgaElectronicsStores[index];
                  final isSelected = _selectedStoreFilter == store.name;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStoreFilter =
                            isSelected ? null : store.name;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0F172A)
                            : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF6366F1)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1)
                                  .withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.storefront_rounded,
                              color: Color(0xFF6366F1),
                              size: 18,
                            ),
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
                                      ? Colors.white
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
                                      color: isSelected
                                          ? Colors.white70
                                          : AppColors.textSecondary,
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

            // 6. PRODUCTS CATALOG GRID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedStoreFilter != null
                      ? 'منتجات ${_selectedStoreFilter!}:'
                      : 'أحدث المنتجات المتوفرة (${_filteredItems.length}):',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'تسليم فوري',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      const Icon(Icons.phonelink_off_rounded,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      const Text(
                        'لا توجد أجهزة مطابقة للبحث حالياً',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = 'الكل';
                            _selectedBrand = 'الكل';
                            _selectedStoreFilter = null;
                            _searchController.clear();
                          });
                        },
                        child: const Text('إعادة ضبط الفلاتر',
                            style: TextStyle(color: Color(0xFF6366F1))),
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
                      accentColor: const Color(0xFF6366F1),
                      categoryTag: item.brand,
                      rating: item.rating,
                    ),
                  );
                },
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroFeatureBadge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF818CF8), size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
