import 'package:flutter/material.dart';
import 'main_layout_screen.dart';
import 'vendor/vendor_dashboard_screen.dart';

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
    color: Color(0xFF1B3B2B),
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

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignUpMode = false;
  StoreCategoryType _selectedCategory = allStoreCategoryTypes.first;

  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _businessNameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  void _submitAuth() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final categoryTitle = _selectedCategory.title;

      String successMessage = _isSignUpMode
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
          backgroundColor: const Color(0xFF1B3B2B),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );

      if (_selectedCategory.isVendor) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => VendorDashboardScreen(category: _selectedCategory),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainLayoutScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Theme Colors matching the image exactly
    const pageBgColor = Color(0xFFF7F8F3);
    const darkGreenColor = Color(0xFF1B3B2B);
    const limeGreenColor = Color(0xFF86E562);
    const buttonLightBg = Color(0xFFEFF3EA);
    const textSubtleColor = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: pageBgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. TOP ILLUSTATION / BRAND LOGO ICON
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: buttonLightBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: Icon(
                      _selectedCategory.icon,
                      size: 36,
                      color: darkGreenColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. PAGE TITLE ("Login" / "تسجيل الدخول")
                  Text(
                    _isSignUpMode ? 'إنشاء حساب جديد' : 'Login',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: darkGreenColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isSignUpMode
                        ? 'أدخل بياناتك للانضمام لتطبيق جرجا أونلاين'
                        : 'أهلاً بك مجدداً! أدخل بيانات الحساب للدخول',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: textSubtleColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. STORE / ROLE SELECT DROPDOWN (PILL SHAPED)
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<StoreCategoryType>(
                        value: _selectedCategory,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: darkGreenColor, size: 22),
                        onChanged: (StoreCategoryType? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          }
                        },
                        items: allStoreCategoryTypes.map((type) {
                          return DropdownMenuItem<StoreCategoryType>(
                            value: type,
                            child: Row(
                              children: [
                                Icon(type.icon, size: 18, color: darkGreenColor),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    type.title,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: darkGreenColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 4. DYNAMIC BUSINESS NAME (If Vendor & Sign Up)
                  if (_selectedCategory.isVendor && _isSignUpMode) ...[
                    _buildPillInputField(
                      controller: _businessNameController,
                      hintText: 'اسم المتجر / النشاط بجرجا',
                      icon: Icons.storefront_outlined,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'يرجى إدخال اسم المتجر';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                  ],

                  // 5. FULL NAME (If Sign Up)
                  if (_isSignUpMode) ...[
                    _buildPillInputField(
                      controller: _nameController,
                      hintText: 'الاسم بالكامل',
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

                  // 6. EMAIL / PHONE FIELD (PILL SHAPED)
                  _buildPillInputField(
                    controller: _emailPhoneController,
                    hintText: 'Email or Phone Number',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'يرجى إدخال البريد أو رقم الهاتف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // 7. PASSWORD FIELD (PILL SHAPED)
                  _buildPillInputField(
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: textSubtleColor,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: (val) {
                      if (val == null || val.length < 4) {
                        return 'كلمة المرور 4 خانات على الأقل';
                      }
                      return null;
                    },
                  ),

                  // 8. FORGOT PASSWORD LINK
                  if (!_isSignUpMode)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم إرسال رابط استعادة كلمة المرور لبريدك 📩'),
                              backgroundColor: darkGreenColor,
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: textSubtleColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),

                  // 9. PRIMARY LOGIN BUTTON (DARK GREEN CAPSULE)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitAuth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreenColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
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
                              _isSignUpMode ? 'Sign Up' : 'Login',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 10. DIVIDER ("or")
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                              color: Colors.black.withValues(alpha: 0.1), thickness: 1)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'or',
                          style: TextStyle(
                            color: textSubtleColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                              color: Colors.black.withValues(alpha: 0.1), thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 11. CONTINUE WITH GOOGLE (LIGHT CAPSULE BUTTON)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _submitAuth(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonLightBg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_mobiledata_rounded,
                              color: Color(0xFFDB4437), size: 28),
                          SizedBox(width: 8),
                          Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: darkGreenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 12. CONTINUE WITH APPLE / ROLE (LIME GREEN CAPSULE BUTTON)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _submitAuth(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: limeGreenColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.apple_rounded,
                              color: darkGreenColor, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Continue with Apple',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: darkGreenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 13. CONTINUE AS GUEST (LIGHT CAPSULE BUTTON)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const MainLayoutScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonLightBg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_pin_rounded,
                              color: darkGreenColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Continue As Guest',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: darkGreenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 14. BOTTOM ACCOUNT SWITCHER LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSignUpMode
                            ? 'Already have an account? '
                            : 'Need an account? ',
                        style: const TextStyle(
                          color: textSubtleColor,
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSignUpMode = !_isSignUpMode;
                          });
                        },
                        child: Text(
                          _isSignUpMode ? 'Log in' : 'Sign up',
                          style: const TextStyle(
                            color: darkGreenColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    const darkGreenColor = Color(0xFF1B3B2B);
    const textSubtleColor = Color(0xFF94A3B8);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(
          color: darkGreenColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: textSubtleColor,
            fontSize: 13,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Icon(icon, color: textSubtleColor, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
