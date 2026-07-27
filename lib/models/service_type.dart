import 'package:flutter/material.dart';

enum ServiceCategory {
  food,
  supermarket,
  pharmacy,
  electronics,
  fashion,
  realEstate,
  jobs,
  parcelDelivery,
}

class ServiceTypeItem {
  final ServiceCategory category;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final Color badgeColor;
  final String? badgeText;

  const ServiceTypeItem({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.badgeColor,
    this.badgeText,
  });
}

final List<ServiceTypeItem> allCityServices = [
  const ServiceTypeItem(
    category: ServiceCategory.food,
    title: 'مطاعم ومأكولات',
    subtitle: 'أشهر المطاعم والوجبات',
    icon: Icons.restaurant_rounded,
    primaryColor: Color(0xFFFF5216),
    badgeColor: Color(0xFFFFEFEB),
    badgeText: 'خصم 20%',
  ),
  const ServiceTypeItem(
    category: ServiceCategory.supermarket,
    title: 'سوبر ماركت',
    subtitle: 'خضار، ألبان، ومؤن منزلية',
    icon: Icons.shopping_cart_rounded,
    primaryColor: Color(0xFF10B981),
    badgeColor: Color(0xFFE6F4EA),
    badgeText: 'توصيل سريع',
  ),
  const ServiceTypeItem(
    category: ServiceCategory.pharmacy,
    title: 'صيدليات ومستلزمات',
    subtitle: 'أدوية ورعاية صحية',
    icon: Icons.local_pharmacy_rounded,
    primaryColor: Color(0xFF06B6D4),
    badgeColor: Color(0xFFE0F7FA),
    badgeText: 'رفع روشتة',
  ),
  const ServiceTypeItem(
    category: ServiceCategory.electronics,
    title: 'إلكترونيات وهواتف',
    subtitle: 'موبايلات وإكسسوارات',
    icon: Icons.devices_other_rounded,
    primaryColor: Color(0xFF6366F1),
    badgeColor: Color(0xFFEEF2FF),
    badgeText: 'أحدث الموديلات',
  ),
  const ServiceTypeItem(
    category: ServiceCategory.fashion,
    title: 'أزياء وموضة',
    subtitle: 'ملابس رجالي، حريمي وأطفال',
    icon: Icons.checkroom_rounded,
    primaryColor: Color(0xFFEC4899),
    badgeColor: Color(0xFFFCE7F3),
    badgeText: 'تشكيلة جديدة',
  ),
  const ServiceTypeItem(
    category: ServiceCategory.realEstate,
    title: 'عقارات وأملاك',
    subtitle: 'شقق ومحلات بيع وإيجار',
    icon: Icons.domain_rounded,
    primaryColor: Color(0xFF8B5CF6),
    badgeColor: Color(0xFFF3E8FF),
    badgeText: 'بدون وسيط',
  ),
  const ServiceTypeItem(
    category: ServiceCategory.jobs,
    title: 'وظائف وفرص عمل',
    subtitle: 'فرص عمل محلية بالمدينة',
    icon: Icons.work_rounded,
    primaryColor: Color(0xFFF59E0B),
    badgeColor: Color(0xFFFEF3C7),
    badgeText: 'فرص اليوم',
  ),
  const ServiceTypeItem(
    category: ServiceCategory.parcelDelivery,
    title: 'توصيل طرود ومرسول',
    subtitle: 'إرسال واستلام أي شيء فوراً',
    icon: Icons.two_wheeler_rounded,
    primaryColor: Color(0xFF0EA5E9),
    badgeColor: Color(0xFFE0F2FE),
    badgeText: 'مرسول السريع',
  ),
];
