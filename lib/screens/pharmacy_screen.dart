import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/food_item.dart';
import '../models/pharmacy_item.dart';
import '../models/pharmacy_store.dart';
import '../theme/app_colors.dart';
import '../widgets/promo_banner.dart';
import 'location_picker_screen.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  int _selectedViewIndex = 0; // 0 = اطلب دواؤك (روشتة), 1 = دليل الأدوية, 2 = صيدليات جرجا
  String _selectedCategory = 'all';
  String _searchQuery = '';
  String _deliveryAddress = 'شارع المحطة - مار جرجس (جرجا)';

  // Order Request Mode: 'writing', 'image', 'ai'
  String _requestMode = 'writing';

  // Dynamic Medicine Inputs
  final List<Map<String, TextEditingController>> _medicineInputs = [];
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // Image Upload Simulation State
  String? _selectedImageName;
  bool _isUploading = false;
  bool _isAnalyzingAI = false;
  List<String>? _aiDetectedMedicines;

  // Categories Filter
  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'الكل'},
    {'id': 'مسكنات وأدوية برد', 'label': 'مسكنات وبرد'},
    {'id': 'فيتامينات ومكملات', 'label': 'فيتامينات ومناعة'},
    {'id': 'مضادات حيوية', 'label': 'مضادات حيوية'},
    {'id': 'أدوية معدة وهضم', 'label': 'أدوية معدة'},
    {'id': 'أجهزة طبية', 'label': 'أجهزة طبية'},
    {'id': 'عناية وتجميل', 'label': 'عناية وتجميل'},
    {'id': 'رعاية الأطفال', 'label': 'رعاية الأطفال'},
  ];

  @override
  void initState() {
    super.initState();
    _addMedicineInput();
  }

  @override
  void dispose() {
    for (var input in _medicineInputs) {
      input['name']?.dispose();
      input['qty']?.dispose();
    }
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addMedicineInput() {
    setState(() {
      _medicineInputs.add({
        'name': TextEditingController(),
        'qty': TextEditingController(text: '1'),
      });
    });
  }

  void _removeMedicineInput(int index) {
    if (_medicineInputs.length > 1) {
      setState(() {
        _medicineInputs[index]['name']?.dispose();
        _medicineInputs[index]['qty']?.dispose();
        _medicineInputs.removeAt(index);
      });
    }
  }

  void _incrementQty(int index) {
    final qtyController = _medicineInputs[index]['qty'];
    if (qtyController != null) {
      int current = int.tryParse(qtyController.text) ?? 1;
      setState(() {
        qtyController.text = (current + 1).toString();
      });
    }
  }

  void _decrementQty(int index) {
    final qtyController = _medicineInputs[index]['qty'];
    if (qtyController != null) {
      int current = int.tryParse(qtyController.text) ?? 1;
      if (current > 1) {
        setState(() {
          qtyController.text = (current - 1).toString();
        });
      }
    }
  }

  void _simulateUploadImage(String source) {
    setState(() {
      _isUploading = true;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
        _selectedImageName = 'روشتة_علاج_طبي_$source.png';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم ارفاق صورة الروشتة من $source بنجاح 📷'),
          backgroundColor: const Color(0xFF06B6D4),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _simulateAIScan() {
    setState(() {
      _isAnalyzingAI = true;
      _aiDetectedMedicines = null;
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _isAnalyzingAI = false;
        _aiDetectedMedicines = [
          'أوجمنتين 1 جم أقراص (عدد 1 علبة)',
          'بنادول إكسترا مسكن (عدد 2 شريط)',
          'فيتامين C فوار (عدد 1 علبة)',
        ];
      });
    });
  }

  void _submitPrescriptionOrder() {
    String orderDetails = '';

    if (_requestMode == 'writing') {
      List<String> items = [];
      for (var input in _medicineInputs) {
        final name = input['name']?.text.trim();
        final qty = input['qty']?.text.trim() ?? '1';
        if (name != null && name.isNotEmpty) {
          items.add('$name (كمية: $qty)');
        }
      }
      if (items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى كتابة اسم دواء واحد على الأقل'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      orderDetails = items.join('، ');
    } else if (_requestMode == 'image') {
      if (_selectedImageName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى التقاط أو اختيار صورة الروشتة أولاً'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      orderDetails = 'طلب دواء عبر مرفق صورة الروشتة ($_selectedImageName)';
    } else if (_requestMode == 'ai') {
      if (_aiDetectedMedicines == null || _aiDetectedMedicines!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى فحص صورة الروشتة بالذكاء الاصطناعي أولاً'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      orderDetails = _aiDetectedMedicines!.join('، ');
    }

    // Convert prescription order to cart item adapter
    final rxFoodItem = FoodItem(
      id: 'rx_${DateTime.now().millisecondsSinceEpoch}',
      title: 'طلب روشتة ودواء ($orderDetails)',
      restaurantId: 'pharm_1',
      restaurant: 'صيدلية الشفاء (جرجا)',
      price: 85.0,
      rating: 4.9,
      deliveryTime: '15-25 دقيقة',
      description: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : 'طلب دواوي مخصص عبر الصيدلية',
      imagePath: 'assets/images/pharmacy_vitamins.png',
      categoryId: 'pharmacy',
    );

    appState.addToCart(rxFoodItem, quantity: 1);
    appState.placeOrder(
      areaName: 'مار جرجس (جرجا)',
      addressDetails: 'شارع المحطة - جرجا',
      phoneNumber: '01012345678',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال الروشتة لأقرب صيدلية وتفعيل التتبع المباشر! 🚀'),
        backgroundColor: Color(0xFF06B6D4),
        duration: Duration(seconds: 3),
      ),
    );
  }

  List<PharmacyItem> get _filteredMedicines {
    return samplePharmacyItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.pharmacyName.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'all' ||
          item.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showImagePreviewDialog(PharmacyItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    item.imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: AppColors.cardBg,
                      child: const Icon(Icons.local_pharmacy,
                          size: 64, color: Color(0xFF06B6D4)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06B6D4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      final foodAdapter = FoodItem(
                        id: item.id,
                        title: item.title,
                        restaurantId: 'pharm_1',
                        restaurant: item.pharmacyName,
                        price: item.price,
                        rating: item.rating,
                        deliveryTime: '15-20 دقيقة',
                        description: item.description,
                        imagePath: item.imagePath,
                        categoryId: 'pharmacy',
                      );
                      appState.addToCart(foodAdapter, quantity: 1);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم إضافة ${item.title} للسلة 🛒'),
                          backgroundColor: const Color(0xFF06B6D4),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart_rounded,
                        color: Colors.white, size: 18),
                    label: Text(
                      'إضافة لسلة الدواء • ${item.price.toStringAsFixed(0)} ج.م',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicines = _filteredMedicines;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                // 1. TOP HEADER WITH BACK BUTTON & SEARCH
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.headerFadeGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Subtitle Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    if (Navigator.canPop(context))
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF06B6D4)
                                                  .withValues(alpha: 0.12),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.arrow_back_rounded,
                                              color: Color(0xFF06B6D4),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    const Icon(Icons.local_pharmacy_rounded,
                                        color: Color(0xFF06B6D4), size: 24),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'صيدليات ورعاية جرجا',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF06B6D4),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'طلب روشتات وأدوية مع توصيل فوري',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF06B6D4)
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      '24/7 متوفر',
                                      style: TextStyle(
                                        color: Color(0xFF06B6D4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Search Bar
                          Container(
                            height: 46,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search_rounded,
                                  color: Color(0xFF06B6D4),
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (val) {
                                      setState(() {
                                        _searchQuery = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText:
                                          'ابحث باسم الدواء، المادة الفعالة، أو الصيدلية...',
                                      hintStyle: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 12,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _searchQuery = '';
                                        _searchController.clear();
                                      });
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: AppColors.textSecondary,
                                      size: 18,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // MAIN NAVIGATION TABS (3 TABS)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                _buildTabButton(
                                  index: 0,
                                  label: 'اطلب دواؤك',
                                  icon: Icons.assignment_rounded,
                                ),
                                _buildTabButton(
                                  index: 1,
                                  label: 'دليل الأدوية',
                                  icon: Icons.medication_rounded,
                                ),
                                _buildTabButton(
                                  index: 2,
                                  label: 'صيدليات جرجا',
                                  icon: Icons.storefront_rounded,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. MAIN BODY CONTENT BASED ON SELECTED TAB
                Expanded(
                  child: _selectedViewIndex == 0
                      ? _buildPrescriptionRequestTab()
                      : _selectedViewIndex == 1
                          ? _buildMedicinesCatalogTab(medicines)
                          : _buildPharmaciesListTab(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabButton({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedViewIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedViewIndex = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF06B6D4) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- TAB 0: PRESCRIPTION ORDER TAB ----------------
  Widget _buildPrescriptionRequestTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Offer
          PromoBanner(
            onTasteNow: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('خصم 15% على مستلزمات الفيتامينات والرعاية الصحية! 💊'),
                  backgroundColor: Color(0xFF06B6D4),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Request Mode Chooser (Writing vs Image vs AI)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildModeChoiceTile(
                  id: 'writing',
                  title: 'كتابة الدواء',
                  icon: Icons.edit_note_rounded,
                ),
                _buildModeChoiceTile(
                  id: 'image',
                  title: 'رفع روشتة',
                  icon: Icons.camera_alt_rounded,
                ),
                _buildModeChoiceTile(
                  id: 'ai',
                  title: 'فحص الذكاء 🤖',
                  icon: Icons.auto_awesome_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // MODE 1: WRITING MEDICINES DYNAMICALLY
          if (_requestMode == 'writing') ...[
            Text(
              'اكتب أسماء الأدوية المطلوبة:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _medicineInputs.length,
              itemBuilder: (context, index) {
                final nameController = _medicineInputs[index]['name']!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF06B6D4)
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'اسم الدواء (مثال: بنادول، أوجمنتين...)',
                              hintStyle: TextStyle(fontSize: 12),
                              prefixIcon: Icon(Icons.medication_outlined,
                                  color: Color(0xFF06B6D4), size: 20),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Quantity Selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF06B6D4)
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove,
                                  size: 16, color: Color(0xFF06B6D4)),
                              onPressed: () => _decrementQty(index),
                            ),
                            Text(
                              _medicineInputs[index]['qty']?.text ?? '1',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add,
                                  size: 16, color: Color(0xFF06B6D4)),
                              onPressed: () => _incrementQty(index),
                            ),
                          ],
                        ),
                      ),
                      if (_medicineInputs.length > 1)
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: Colors.redAccent, size: 20),
                          onPressed: () => _removeMedicineInput(index),
                        ),
                    ],
                  ),
                );
              },
            ),
            TextButton.icon(
              onPressed: _addMedicineInput,
              icon: const Icon(Icons.add_circle_outline_rounded,
                  color: Color(0xFF06B6D4), size: 18),
              label: const Text(
                'إضافة دواء آخر للقائمة',
                style: TextStyle(
                  color: Color(0xFF06B6D4),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],

          // MODE 2: UPLOAD PRESCRIPTION IMAGE
          if (_requestMode == 'image') ...[
            Text(
              'التقط أو اختر صورة الروشتة:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  if (_isUploading)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: Color(0xFF06B6D4),
                      ),
                    )
                  else if (_selectedImageName != null) ...[
                    const Icon(Icons.task_alt_rounded,
                        size: 48, color: Color(0xFF10B981)),
                    const SizedBox(height: 8),
                    Text(
                      _selectedImageName!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedImageName = null;
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded,
                          size: 16, color: Colors.red),
                      label: const Text('تغيير الصورة',
                          style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  ] else ...[
                    const Icon(Icons.cloud_upload_outlined,
                        size: 48, color: Color(0xFF06B6D4)),
                    const SizedBox(height: 10),
                    const Text(
                      'قم برفع صورة الروشتة أو علبة العلاج وسيتم قراءتها بواسطة الصيدلي',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF06B6D4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => _simulateUploadImage('الكاميرا'),
                          icon: const Icon(Icons.camera_alt_rounded,
                              size: 16, color: Colors.white),
                          label: const Text('الكاميرا',
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => _simulateUploadImage('المعرض'),
                          icon: const Icon(Icons.photo_library_rounded,
                              size: 16, color: Color(0xFF06B6D4)),
                          label: const Text('المعرض',
                              style: TextStyle(color: Color(0xFF06B6D4))),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],

          // MODE 3: AI SCANNER
          if (_requestMode == 'ai') ...[
            Text(
              'ماكينة الذكاء الاصطناعي لفحص الروشتات 🤖:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  if (_isAnalyzingAI) ...[
                    const CircularProgressIndicator(color: Color(0xFF06B6D4)),
                    const SizedBox(height: 12),
                    const Text(
                      'جاري تحليل خط الروشتة بواسطة AI...',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ] else if (_aiDetectedMedicines != null) ...[
                    const Icon(Icons.auto_awesome_rounded,
                        color: Colors.amber, size: 36),
                    const SizedBox(height: 8),
                    const Text(
                      'الأدوية المكتشفة في الروشتة:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: _aiDetectedMedicines!
                          .map(
                            (med) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded,
                                      color: Color(0xFF10B981), size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      med,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ] else ...[
                    const Icon(Icons.center_focus_strong_rounded,
                        color: Color(0xFF06B6D4), size: 48),
                    const SizedBox(height: 10),
                    const Text(
                      'اضغط للبدء بالفحص الآلي وقراءة بخاخات وأقراص الروشتة فوراً',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _simulateAIScan,
                      icon: const Icon(Icons.auto_fix_high_rounded,
                          color: Colors.white, size: 18),
                      label: const Text('فحص الروشتة بالذكاء الاصطناعي',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),

          // MAP DELIVERY LOCATION SELECTOR
          Text(
            'عنوان وموقع توصيل الدواء على الخريطة:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final newLocation = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (_) => LocationPickerScreen(
                    currentLocation: _deliveryAddress,
                  ),
                ),
              );
              if (newLocation != null && mounted) {
                setState(() {
                  _deliveryAddress = newLocation;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.map_rounded,
                      color: Color(0xFF06B6D4), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _deliveryAddress,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'اضغط لتحديد وتحديد موقعك بدقة على الخريطة 🗺️',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: Color(0xFF06B6D4)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // DELIVERY NOTES
          Text(
            'ملاحظات إضافية للصيدلي (اختياري):',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'مثال: يرجى التوصيل شقة 4، أو الاتصال قبل الوصول...',
                hintStyle: TextStyle(fontSize: 12),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // SUBMIT ORDER BUTTON
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _submitPrescriptionOrder,
              icon: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
              label: const Text(
                'إرسال الطلب لأقرب صيدلية 🚀',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeChoiceTile({
    required String id,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _requestMode == id;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _requestMode = id;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF06B6D4).withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF06B6D4)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? const Color(0xFF06B6D4)
                    : AppColors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF06B6D4)
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- TAB 1: MEDICINES & HEALTHCARE CATALOG ----------------
  Widget _buildMedicinesCatalogTab(List<PharmacyItem> medicines) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories Filter Chips Bar
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['id'];
                return ChoiceChip(
                  label: Text(cat['label']!),
                  selected: isSelected,
                  selectedColor: const Color(0xFF06B6D4),
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedCategory = cat['id']!);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Grid View of Medicines
          medicines.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 56, color: AppColors.textLight),
                        const SizedBox(height: 12),
                        Text(
                          'لا يجد أدوية تطابق البحث حالياً',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: medicines.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final item = medicines[index];
                    return _buildMedicineCard(item);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(PharmacyItem item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Image with Badges
          Stack(
            children: [
              GestureDetector(
                onTap: () => _showImagePreviewDialog(item),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.cardBg,
                        child: const Icon(Icons.local_pharmacy,
                            size: 44, color: Color(0xFF06B6D4)),
                      ),
                    ),
                  ),
                ),
              ),
              if (item.requiresPrescription)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'روشتة مطلوبة 📋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Body Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.pharmacyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF06B6D4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${item.price.toStringAsFixed(0)} ج.م',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final foodAdapter = FoodItem(
                            id: item.id,
                            title: item.title,
                            restaurantId: 'pharm_1',
                            restaurant: item.pharmacyName,
                            price: item.price,
                            rating: item.rating,
                            deliveryTime: '15-20 دقيقة',
                            description: item.description,
                            imagePath: item.imagePath,
                            categoryId: 'pharmacy',
                          );
                          appState.addToCart(foodAdapter, quantity: 1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم إضافة ${item.title} للسلة!'),
                              backgroundColor: const Color(0xFF06B6D4),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF06B6D4)
                                .withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            size: 16,
                            color: Color(0xFF06B6D4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TAB 2: LOCAL PHARMACIES DIRECTORY ----------------
  Widget _buildPharmaciesListTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: samplePharmacyStores.length,
      itemBuilder: (context, index) {
        final pharmacy = samplePharmacyStores[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  pharmacy.logoPath,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: AppColors.cardBg,
                    child: const Icon(Icons.local_pharmacy,
                        size: 32, color: Color(0xFF06B6D4)),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            pharmacy.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          '${pharmacy.rating}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '⏱️ ${pharmacy.deliveryTime}',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedViewIndex = 0;
                  });
                },
                child: const Text(
                  'اطلب الآن',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
