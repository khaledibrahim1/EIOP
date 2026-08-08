import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'main_layout_screen.dart';

class StoreCategoryType {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isVendor;

  const StoreCategoryType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isVendor = true,
  });
}

const List<StoreCategoryType> allStoreCategoryTypes = [
  StoreCategoryType(
    id: 'customer',
    title: 'عميل / مشتري 👤',
    description: 'حساب شخصي لطلب وتصفح الخدمات والتوصيل بجرجا',
    icon: Icons.person_pin_circle_rounded,
    color: Color(0xFFFF5216),
    isVendor: false,
  ),
  StoreCategoryType(
    id: 'restaurant',
    title: 'مطاعم ومأكولات 🍕',
    description: 'مطعم، كافيه، أو محل مأكولات ومشروبات',
    icon: Icons.restaurant_rounded,
    color: Color(0xFFEF4444),
  ),
  StoreCategoryType(
    id: 'supermarket',
    title: 'سوبر ماركت وبقالة 🛒',
    description: 'سوبرماركت، بقالة، أو محل منتجات غذائية',
    icon: Icons.shopping_basket_rounded,
    color: Color(0xFF10B981),
  ),
  StoreCategoryType(
    id: 'pharmacy',
    title: 'صيدلية ومستلزمات طبية 💊',
    description: 'صيدلية، مستحضرات تجميل، أو مستلزمات طبية',
    icon: Icons.local_pharmacy_rounded,
    color: Color(0xFF06B6D4),
  ),
  StoreCategoryType(
    id: 'electronics',
    title: 'إلكترونيات وهواتف 📱',
    description: 'محل موبايلات، كمبيوتر، أجهزة منزلية وإكسسوارات',
    icon: Icons.devices_other_rounded,
    color: Color(0xFF6366F1),
  ),
  StoreCategoryType(
    id: 'fashion',
    title: 'أزياء وموضة وملابس 👔',
    description: 'محل ملابس رجالي/حريمي، أحذية، وإكسسوارات',
    icon: Icons.checkroom_rounded,
    color: Color(0xFFE11D48),
  ),
  StoreCategoryType(
    id: 'vegetables',
    title: 'خضروات وفواكه طازجة 🥕',
    description: 'محل خضار، فاكهة، ومنتجات زراعية طازجة',
    icon: Icons.eco_rounded,
    color: Color(0xFF84CC16),
  ),
  StoreCategoryType(
    id: 'real_estate',
    title: 'عقارات وأراضي 🏠',
    description: 'مكتب عقاري، تأجير شقق، أراضي، ومحلات',
    icon: Icons.home_work_rounded,
    color: Color(0xFF8B5CF6),
  ),
  StoreCategoryType(
    id: 'jobs',
    title: 'وظائف وخدمات وحرف 💼',
    description: 'مؤسسة خدمات، صنايعي، حرفي، أو مكتب توظيف',
    icon: Icons.work_outline_rounded,
    color: Color(0xFFF59E0B),
  ),
  StoreCategoryType(
    id: 'parcel',
    title: 'توصيل طرود وخدمات شحن 📦',
    description: 'مكتب شحن طرود، توصيل سريع، أو مندوب شحن',
    icon: Icons.local_shipping_rounded,
    color: Color(0xFFEC4899),
  ),
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _authTabController;

  StoreCategoryType _selectedCategory = allStoreCategoryTypes.first;

  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _authTabController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _businessNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitAuth() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final isRegister = _authTabController.index == 1;
      final categoryTitle = _selectedCategory.title;

      String successMessage = isRegister
          ? 'تم إنشاء حساب $categoryTitle جديد بنجاح! 🎉'
          : 'مرحباً بك مجدداً! تم تسجيل الدخول كـ $categoryTitle 🚀';

      if (_selectedCategory.isVendor) {
        final bName = _businessNameController.text.trim().isNotEmpty
            ? _businessNameController.text.trim()
            : 'متجرك بجرجا';
        successMessage =
            'تم تسجيل دخول $bName ($categoryTitle)! مرحباً بك في لوحة التاجر بجرجا 🏬✨';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            successMessage,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: _selectedCategory.color,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainLayoutScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row with Skip / Back
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: AppColors.textPrimary, size: 20),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const MainLayoutScreen()),
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const MainLayoutScreen()),
                        );
                      },
                      child: const Text(
                        'التصفح كزائر 🏃‍♂️',
                        style: TextStyle(
                          color: Color(0xFFFF5216),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Brand Hero Banner
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _selectedCategory.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: _selectedCategory.color.withValues(alpha: 0.3),
                              width: 2),
                        ),
                        child: Icon(
                          _selectedCategory.icon,
                          size: 40,
                          color: _selectedCategory.color,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                          children: [
                            const TextSpan(text: 'أهلاً بك في '),
                            TextSpan(
                              text: 'جرجا أونلاين 🚀',
                              style: TextStyle(color: _selectedCategory.color),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'اختر نوع متجرك أو حسابك وسجل دخولك بكل سهولة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 1. SELECT DROPDOWN FOR ALL STORE TYPES & ROLES (قائمة المتاجر والأنشطة)
                Text(
                  'اختر نوع المتجر / الحساب (Select):',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: _selectedCategory.color.withValues(alpha: 0.4),
                        width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<StoreCategoryType>(
                      value: _selectedCategory,
                      isExpanded: true,
                      dropdownColor: AppColors.cardBg,
                      icon: Icon(Icons.arrow_drop_down_circle_rounded,
                          color: _selectedCategory.color, size: 24),
                      onChanged: (StoreCategoryType? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        }
                      },
                      items: allStoreCategoryTypes
                          .map<DropdownMenuItem<StoreCategoryType>>((type) {
                        return DropdownMenuItem<StoreCategoryType>(
                          value: type,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: type.color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(type.icon,
                                    size: 18, color: type.color),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      type.title,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      type.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. AUTH MODE TAB (تسجيل الدخول | إنشاء حساب)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: _authTabController,
                    onTap: (_) => setState(() {}),
                    indicator: BoxDecoration(
                      color: _selectedCategory.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: 'تسجيل الدخول'),
                      Tab(text: 'حساب جديد'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. DYNAMIC FORM FIELDS
                // Field A: Business / Store Name (Only for Vendors in Register mode)
                if (_selectedCategory.isVendor &&
                    _authTabController.index == 1) ...[
                  _buildInputField(
                    controller: _businessNameController,
                    label: 'اسم متجرك بجرجا (${_selectedCategory.title})',
                    icon: Icons.storefront_rounded,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'يرجى كتابة اسم المتجر أو النشاط التجاري';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                ],

                // Field B: Owner/User Full Name (In Register Mode)
                if (_authTabController.index == 1) ...[
                  _buildInputField(
                    controller: _nameController,
                    label: _selectedCategory.isVendor
                        ? 'اسم صاحب المتجر / المسؤول'
                        : 'الاسم بالكامل',
                    icon: Icons.person_outline_rounded,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'يرجى كتابة الاسم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                ],

                // Field C: Phone Number (Always required)
                _buildInputField(
                  controller: _phoneController,
                  label: 'رقم الهاتف (مثلاً: 01012345678)',
                  icon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.trim().length < 8) {
                      return 'يرجى إدخال رقم هاتف صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Field D: Branch Address (Only for Vendors)
                if (_selectedCategory.isVendor) ...[
                  _buildInputField(
                    controller: _addressController,
                    label: 'عنوان الفرع بمدينة جرجا (مثلاً: شارع المحطة)',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 14),
                ],

                // Field E: Password (Always required)
                _buildInputField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  icon: Icons.lock_outline_rounded,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  validator: (val) {
                    if (val == null || val.length < 4) {
                      return 'كلمة المرور يجب أن تكون 4 خانات على الأقل';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // 4. SUBMIT ACTION BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedCategory.color,
                      elevation: 6,
                      shadowColor: _selectedCategory.color.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            _authTabController.index == 0
                                ? 'تسجيل الدخول - ${_selectedCategory.title}'
                                : 'إنشاء حساب - ${_selectedCategory.title}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 18),

                // Helper Terms Footer
                Center(
                  child: Text(
                    'بتسجيل الدخول أنت توافق على شروط خدمة وتوصيل جرجا أونلاين 📜',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          prefixIcon: Icon(icon, color: _selectedCategory.color, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
