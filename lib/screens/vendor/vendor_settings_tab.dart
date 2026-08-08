import 'package:flutter/material.dart';
import '../main_layout_screen.dart';
import '../onboarding_screen.dart';

class VendorSettingsTab extends StatelessWidget {
  final String storeName;
  final String categoryTitle;

  const VendorSettingsTab({
    super.key,
    required this.storeName,
    required this.categoryTitle,
  });

  static const darkForestGreen = Color(0xFF0D2B1D);
  static const vibrantLimeGreen = Color(0xFFA3E635);
  static const lightBgColor = Color(0xFFF6F8F5);
  static const cardWhite = Colors.white;
  static const textDark = Color(0xFF0F172A);
  static const textSubtle = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. STORE PROFILE HEADER CARD (DARK FOREST GREEN CARD MATCHING DASHBOARD)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: darkForestGreen,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: darkForestGreen.withValues(alpha: 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: vibrantLimeGreen.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: vibrantLimeGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              storeName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.verified_rounded,
                              color: vibrantLimeGreen, size: 16),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'شريك معتمد بجرجا • $categoryTitle',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. SETTINGS TILES SECTION
          const Text(
            'إعدادات الملف التجاري:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 12),

          _buildSettingsTile(
            icon: Icons.edit_note_rounded,
            title: 'تعديل بيانات المتجر وساعات العمل',
            subtitle: 'اسم المتجر، ساعات العمل، والفرع بجرجا',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('صفحة تعديل معلومات المتجر 📝')),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.location_on_outlined,
            title: 'موقع الفرع وخريطة جرجا',
            subtitle: 'شارع المحطة - سوهاج - جرجا',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.notifications_none_rounded,
            title: 'تنبيهات الطلبات الجديدة',
            subtitle: 'إشعارات صوتية فورية للطلبات الواردة',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.share_rounded,
            title: 'مشاركة رابط منيو متجرك',
            subtitle: 'انسخ رابط المنيو وشاركه مع عملائك بجرجا',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('تم نسخ رابط متجرك بجرجا بنجاح! 📋🔗')),
              );
            },
          ),

          const SizedBox(height: 14),

          // 3. ACCOUNT SWITCHERS & LOGOUT
          _buildSettingsTile(
            icon: Icons.shopping_cart_outlined,
            title: 'التبديل إلى حساب المشتري 🛒',
            subtitle: 'التصفح والشراء كعميل عادي للتطبيق',
            iconColor: darkForestGreen,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MainLayoutScreen()),
              );
            },
          ),

          _buildSettingsTile(
            icon: Icons.logout_rounded,
            title: 'تسجيل الخروج من لوحة التاجر',
            subtitle: 'العودة لصفحة الترحيب الرئيسية',
            iconColor: Colors.redAccent,
            titleColor: Colors.redAccent,
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                (route) => false,
              );
            },
          ),

          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    final color = iconColor ?? darkForestGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: titleColor ?? textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: textSubtle,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: textSubtle,
        ),
        ),
      ),
    );
  }
}
