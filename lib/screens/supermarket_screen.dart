import 'package:flutter/material.dart';
import '../models/supermarket_item.dart';
import '../theme/app_colors.dart';
import '../widgets/multi_service_product_card.dart';

class SupermarketScreen extends StatefulWidget {
  const SupermarketScreen({super.key});

  @override
  State<SupermarketScreen> createState() => _SupermarketScreenState();
}

class _SupermarketScreenState extends State<SupermarketScreen> {
  String _selectedCat = 'الكل';

  final List<String> _categories = [
    'الكل',
    'ألبان واحتياجات',
    'بقالة ومؤن',
    'مشروبات وعصائر',
    'خضروات وفواكه',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = sampleSupermarketItems.where((item) {
      return _selectedCat == 'الكل' || item.category == _selectedCat;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_rounded, color: Color(0xFF10B981)),
            SizedBox(width: 8),
            Text(
              'سوبر ماركت ومؤن المدينة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF10B981),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Promo Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.local_offer_rounded,
                      color: Colors.white, size: 32),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'توصيل البقالة والمؤن خلال 20 دقيقة!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'خصومات حصرية على جميع المنتجات الطازجة',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Horizontal Categories Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCat == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFF10B981),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedCat = cat);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Products Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return MultiServiceProductCard(
                  id: item.id,
                  title: item.title,
                  subtitle: '${item.storeName} • ${item.unit}',
                  price: item.price,
                  oldPrice: item.oldPrice,
                  imagePath: item.imagePath,
                  accentColor: const Color(0xFF10B981),
                  categoryTag: item.category,
                  rating: item.rating,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
