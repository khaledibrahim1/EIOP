import 'package:flutter/material.dart';
import '../models/service_type.dart';
import '../theme/app_colors.dart';

class QuickShortcutsBar extends StatefulWidget {
  final Function(ServiceCategory category) onSelectCategory;

  const QuickShortcutsBar({
    super.key,
    required this.onSelectCategory,
  });

  @override
  State<QuickShortcutsBar> createState() => _QuickShortcutsBarState();
}

class _QuickShortcutsBarState extends State<QuickShortcutsBar> {
  int? _hoveredIndex;

  final List<_ShortcutItem> _shortcuts = [
    _ShortcutItem(
      title: 'طلب مرسول طرد',
      subtitle: 'توصيل فوري بالمدينة',
      badgeText: 'سريع 🚀',
      icon: Icons.two_wheeler_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glowColor: const Color(0xFF0EA5E9),
      category: ServiceCategory.parcelDelivery,
    ),
    _ShortcutItem(
      title: 'رفع روشتة صيدلية',
      subtitle: 'توصيل الدواء فوراً',
      badgeText: 'روشتة 💊',
      icon: Icons.camera_alt_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glowColor: const Color(0xFF06B6D4),
      category: ServiceCategory.pharmacy,
    ),
    _ShortcutItem(
      title: 'عقارات بدون وسيط',
      subtitle: 'شقق ومحلات للبيع والفرق',
      badgeText: 'مباشر 🏡',
      icon: Icons.domain_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glowColor: const Color(0xFF8B5CF6),
      category: ServiceCategory.realEstate,
    ),
    _ShortcutItem(
      title: 'وظائف اليوم بالمدينة',
      subtitle: 'تقديم مباشر فوراً',
      badgeText: 'فرص عمل 💼',
      icon: Icons.badge_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glowColor: const Color(0xFFF59E0B),
      category: ServiceCategory.jobs,
    ),
    _ShortcutItem(
      title: 'سوبر ماركت وسريع',
      subtitle: 'مؤن وبقالة طازجة',
      badgeText: '20 دقيقة 🛒',
      icon: Icons.shopping_cart_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glowColor: const Color(0xFF10B981),
      category: ServiceCategory.supermarket,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'الخدمات السريعة ⚡',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'اختصارات فائقة السرعة',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Horizontal Professional Animated Cards Strip
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _shortcuts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = _shortcuts[index];
              final isHovered = _hoveredIndex == index;

              return MouseRegion(
                onEnter: (_) => setState(() => _hoveredIndex = index),
                onExit: (_) => setState(() => _hoveredIndex = null),
                child: GestureDetector(
                  onTap: () => widget.onSelectCategory(item.category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    width: 195,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isHovered
                            ? item.glowColor
                            : item.glowColor.withValues(alpha: 0.2),
                        width: isHovered ? 1.8 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: item.glowColor
                              .withValues(alpha: isHovered ? 0.25 : 0.08),
                          blurRadius: isHovered ? 14 : 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left Glowing Icon Container
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: item.gradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: item.glowColor.withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            item.icon,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Right Content & Badge
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: item.glowColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.badgeText,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: item.glowColor,
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
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ShortcutItem {
  final String title;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final LinearGradient gradient;
  final Color glowColor;
  final ServiceCategory category;

  _ShortcutItem({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.icon,
    required this.gradient,
    required this.glowColor,
    required this.category,
  });
}
