import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cart_state.dart';
import '../models/food_item.dart';
import '../models/restaurant.dart';
import '../models/service_type.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_clipper.dart';
import '../widgets/dark_mode_switch.dart';
import '../widgets/food_card.dart';
import '../widgets/promo_banner.dart';
import 'cart_screen.dart';
import 'electronics_screen.dart';
import 'fashion_screen.dart';
import 'food_details_screen.dart';
import 'jobs_screen.dart';
import 'parcel_delivery_screen.dart';
import 'pharmacy_screen.dart';
import 'real_estate_screen.dart';
import 'restaurant_details_screen.dart';
import 'restaurants_screen.dart';
import 'supermarket_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCatId = '';
  String _searchQuery = '';

  late Timer _headerColorTimer;
  int _headerColorIndex = 0;

  final List<Color> _headerColors = const [
    Color(0xFFFF5216), // 🧡 البرتقالي المميز (Talabat Signature Orange)
    Color(0xFF7C3AED), // 💜 الموف الملكي الفاخر (Royal Violet Purple)
    Color(0xFF0D9488), // 💚 الزمردي التايلاندي (Emerald Teal)
    Color(0xFF2563EB), // 💙 الأزرق الياقوتي (Sapphire Electric Blue)
    Color(0xFFE11D48), // ❤️ الكورال الوردي الفاخر (Crimson Coral Rose)
  ];

  @override
  void initState() {
    super.initState();
    _headerColorTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _headerColorIndex = (_headerColorIndex + 1) % _headerColors.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _headerColorTimer.cancel();
    super.dispose();
  }

  void _onSelectServiceCategory(ServiceCategory cat) {
    switch (cat) {
      case ServiceCategory.food:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const RestaurantsScreen()));
        break;
      case ServiceCategory.supermarket:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SupermarketScreen()));
        break;
      case ServiceCategory.pharmacy:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const PharmacyScreen()));
        break;
      case ServiceCategory.electronics:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ElectronicsScreen()));
        break;
      case ServiceCategory.fashion:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const FashionScreen()));
        break;
      case ServiceCategory.realEstate:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const RealEstateScreen()));
        break;
      case ServiceCategory.jobs:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const JobsScreen()));
        break;
      case ServiceCategory.parcelDelivery:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ParcelDeliveryScreen()));
        break;
    }
  }

  // Girga Local Restaurants Directory
  final List<Restaurant> _girgaRestaurants = const [
    Restaurant(
      id: 'rest_1',
      name: 'مطعم حضرموت جرجا',
      cuisine: 'مندي • مشويات • طواجن',
      rating: 4.8,
      reviewsCount: 142,
      deliveryTime: '25-35 دقيقة',
      deliveryFee: 15.0,
      coverImagePath: 'assets/images/hadramout_cover.png',
      logoPath: 'assets/images/hadramout_cover.png',
      address: 'شارع المحطة',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_2',
      name: 'بيتزا وكريب السلطان',
      cuisine: 'بيتزا إيطالي • كريب • وافل',
      rating: 4.7,
      reviewsCount: 98,
      deliveryTime: '20-30 دقيقة',
      deliveryFee: 10.0,
      coverImagePath: 'assets/images/sultan_pizza_cover.png',
      logoPath: 'assets/images/sultan_pizza_cover.png',
      address: 'الشارع التجاري',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_3',
      name: 'برجر هاوس جرجا',
      cuisine: 'برجر ع الفحم • ساندوتشات',
      rating: 4.9,
      reviewsCount: 210,
      deliveryTime: '15-25 دقيقة',
      deliveryFee: 12.0,
      coverImagePath: 'assets/images/double_cheese_burger.png',
      logoPath: 'assets/images/double_cheese_burger.png',
      address: 'ميدان النهضة',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_4',
      name: 'أسماك المحيط جرجا',
      cuisine: 'مأكولات بحرية • طواجن سي فود',
      rating: 4.6,
      reviewsCount: 75,
      deliveryTime: '30-40 دقيقة',
      deliveryFee: 18.0,
      coverImagePath: 'assets/images/special_steak.png',
      logoPath: 'assets/images/special_steak.png',
      address: 'طريق الكورنيش',
      isOpen: true,
    ),
  ];

  // Aggregated Dishes List
  final List<FoodItem> _allDishes = const [
    FoodItem(
      id: '1',
      title: 'بيتزا ببروني فاخرة',
      restaurantId: 'rest_2',
      restaurant: 'بيتزا السلطان',
      price: 120.0,
      rating: 4.8,
      deliveryTime: '15 دقيقة',
      description:
          'بيتزا ببروني إيطالية طازجة مع صوص الصلصة الممتاز وجبنة موزاريلا سائبة ومكونات فاخرة.',
      imagePath: 'assets/images/sultan_pizza_cover.png',
      images: [
        'assets/images/sultan_pizza_cover.png',
        'assets/images/cat_pizza.png',
        'assets/images/cat_burger.png',
      ],
      options: [
        FoodOption(
          id: 'p1_s',
          title: 'حجم صغير (Small)',
          code: 'S',
          priceOffset: 0.0,
          imagePath: 'assets/images/cat_pizza.png',
        ),
        FoodOption(
          id: 'p1_m',
          title: 'حجم وسط (Medium)',
          code: 'M',
          priceOffset: 25.0,
          imagePath: 'assets/images/sultan_pizza_cover.png',
        ),
        FoodOption(
          id: 'p1_l',
          title: 'حجم كبير (Large)',
          code: 'L',
          priceOffset: 45.0,
          imagePath: 'assets/images/sultan_pizza_cover.png',
        ),
        FoodOption(
          id: 'p1_xl',
          title: 'حجم عائلي (X-Large)',
          code: 'XL',
          priceOffset: 70.0,
          imagePath: 'assets/images/cat_pizza.png',
        ),
      ],
      categoryId: 'pizza',
      isPopular: true,
    ),
    FoodItem(
      id: '2',
      title: 'دبل تشيز برجر فاخر',
      restaurantId: 'rest_3',
      restaurant: 'برجر هاوس',
      price: 110.0,
      rating: 4.9,
      deliveryTime: '20 دقيقة',
      description:
          'قطعتين لحم بقر طازج مع جبنة شيدر سائبة وساندوتش محمص ع الفحم وصوص خاص.',
      imagePath: 'assets/images/double_cheese_burger.png',
      images: [
        'assets/images/double_cheese_burger.png',
        'assets/images/cat_burger.png',
      ],
      options: [
        FoodOption(
          id: 'b2_s',
          title: 'سنجل برجر (Single)',
          code: 'S',
          priceOffset: 0.0,
          imagePath: 'assets/images/cat_burger.png',
        ),
        FoodOption(
          id: 'b2_m',
          title: 'دبل تشيز (Double)',
          code: 'M',
          priceOffset: 30.0,
          imagePath: 'assets/images/double_cheese_burger.png',
        ),
        FoodOption(
          id: 'b2_l',
          title: 'تربل تشيز (Triple)',
          code: 'L',
          priceOffset: 60.0,
          imagePath: 'assets/images/double_cheese_burger.png',
        ),
      ],
      categoryId: 'burger',
      isPopular: true,
    ),
    FoodItem(
      id: '3',
      title: 'طبق أرز مشكل شرقي',
      restaurantId: 'rest_1',
      restaurant: 'مطعم حضرموت',
      price: 85.0,
      rating: 4.7,
      deliveryTime: '25 دقيقة',
      description:
          'أرز بسمتي مبهر مع الخضار والبهارات اليمانية الأصيلة وقطع المكسرات.',
      imagePath: 'assets/images/fried_rice.png',
      images: [
        'assets/images/fried_rice.png',
        'assets/images/hadramout_cover.png',
      ],
      options: [
        FoodOption(
          id: 'r3_s',
          title: 'طبق فردي (1 شخص)',
          code: 'S',
          priceOffset: 0.0,
          imagePath: 'assets/images/fried_rice.png',
        ),
        FoodOption(
          id: 'r3_m',
          title: 'طبق وسط (2 شخص)',
          code: 'M',
          priceOffset: 40.0,
          imagePath: 'assets/images/fried_rice.png',
        ),
        FoodOption(
          id: 'r3_l',
          title: 'سرفيس عائلي (4 أشخاص)',
          code: 'L',
          priceOffset: 95.0,
          imagePath: 'assets/images/hadramout_cover.png',
        ),
      ],
      categoryId: 'dessert',
      isPopular: true,
    ),
    FoodItem(
      id: '4',
      title: 'ستيك مشوي ع الفحم',
      restaurantId: 'rest_1',
      restaurant: 'مطعم حضرموت',
      price: 190.0,
      rating: 4.9,
      deliveryTime: '30 دقيقة',
      description:
          'ستيك کندوز مشوي على الجريل مع الخضار السوتيه وصوص المشروم الفاخر.',
      imagePath: 'assets/images/special_steak.png',
      images: [
        'assets/images/special_steak.png',
        'assets/images/hadramout_cover.png',
      ],
      options: [
        FoodOption(
          id: 'st4_250',
          title: 'وجبة 250 جرام',
          code: 'M',
          priceOffset: 0.0,
          imagePath: 'assets/images/special_steak.png',
        ),
        FoodOption(
          id: 'st4_500',
          title: 'وجبة 500 جرام (دبل)',
          code: 'L',
          priceOffset: 120.0,
          imagePath: 'assets/images/special_steak.png',
        ),
      ],
      categoryId: 'food',
      isPopular: true,
    ),
    FoodItem(
      id: '5',
      title: 'سلة الخضروات والأغذية الطازجة',
      restaurantId: 'rest_super',
      restaurant: 'سوبرماركت الخير',
      price: 140.0,
      rating: 4.9,
      deliveryTime: '15 دقيقة',
      description: 'سلة متكاملة من المنتجات الغذائية الفازجة والألبان وزيت الزيتون.',
      imagePath: 'assets/images/supermarket_basket.png',
      images: ['assets/images/supermarket_basket.png'],
      options: [],
      categoryId: 'supermarket',
      isPopular: true,
    ),
    FoodItem(
      id: '6',
      title: 'فيتامين C ومستلزمات الوقاية',
      restaurantId: 'rest_pharmacy',
      restaurant: 'صيدلية الشفاء',
      price: 65.0,
      rating: 4.8,
      deliveryTime: '20 دقيقة',
      description: 'عبوة فوار فيتامين C ومستلزمات الوقاية والتوصيل الفوري.',
      imagePath: 'assets/images/pharmacy_vitamins.png',
      images: ['assets/images/pharmacy_vitamins.png'],
      options: [],
      categoryId: 'pharmacy',
      isPopular: true,
    ),
    FoodItem(
      id: '7',
      title: 'سماعة بلوتوث لاسلكية',
      restaurantId: 'rest_elec',
      restaurant: 'تكنو ستور جرجا',
      price: 850.0,
      rating: 4.9,
      deliveryTime: '25 دقيقة',
      description: 'سماعة بلوتوث أصلية بصوت مجسم وعزل الضوضاء وعمر بطارية طويل.',
      imagePath: 'assets/images/electronics_earbuds.png',
      images: ['assets/images/electronics_earbuds.png'],
      options: [],
      categoryId: 'electronics',
      isPopular: true,
    ),
    FoodItem(
      id: '8',
      title: 'قميص قطني كاجوال رجالي',
      restaurantId: 'rest_fashion',
      restaurant: 'بوتيك الأناقة جرجا',
      price: 490.0,
      rating: 4.8,
      deliveryTime: '30 دقيقة',
      description: 'قميص كاجوال رجالي قطن 100% بتصميم صيفي مريح.',
      imagePath: 'assets/images/fashion_shirt.png',
      images: ['assets/images/fashion_shirt.png'],
      options: [],
      categoryId: 'fashion',
      isPopular: true,
    ),
    FoodItem(
      id: '9',
      title: 'شقة فاخرة سوبر لوكس للإيجار',
      restaurantId: 'rest_realestate',
      restaurant: 'عقارات شارع المحطة',
      price: 3500.0,
      rating: 4.9,
      deliveryTime: 'معاينة فورية',
      description: 'شقة سكنية 140م تشطيب سوبر لوكس بوسط مدينة جرجا بدون وسيط.',
      imagePath: 'assets/images/realestate_apartment.png',
      images: ['assets/images/realestate_apartment.png'],
      options: [],
      categoryId: 'realEstate',
      isPopular: true,
    ),
    FoodItem(
      id: '10',
      title: 'وظيفة محاسب مالي ومبيعات',
      restaurantId: 'rest_jobs',
      restaurant: 'مجموعة المروة التجارية',
      price: 5000.0,
      rating: 4.8,
      deliveryTime: 'تقديم مباشر',
      description: 'فرصة عمل ممتازة بدوام كامل للمحاسبين بمدينة جرجا.',
      imagePath: 'assets/images/job_opportunity.png',
      images: ['assets/images/job_opportunity.png'],
      options: [],
      categoryId: 'jobs',
      isPopular: true,
    ),
  ];

  List<FoodItem> get _filteredDishes {
    return _allDishes.where((dish) {
      final matchesSearch = dish.title.contains(_searchQuery) ||
          dish.restaurant.contains(_searchQuery);
      final matchesCat = _selectedCatId.isEmpty ||
          dish.categoryId == _selectedCatId ||
          (_selectedCatId == 'food' &&
              (dish.categoryId == 'pizza' ||
                  dish.categoryId == 'burger' ||
                  dish.categoryId == 'dessert' ||
                  dish.categoryId == 'salad' ||
                  dish.categoryId == 'food'));
      return matchesSearch && matchesCat;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. TALABAT-STYLE BRIGHT ORANGE HEADER WITH WAVE CURVE
                    ClipPath(
                      clipper: TalabatHeaderWaveClipper(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeInOutCubic,
                        width: double.infinity,
                        color: _headerColors[_headerColorIndex],
                        child: SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 26),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row 1: Deliver To Location Dropdown & Dark/Cart Icons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'العنوان المحدد: شارع المحطة - مار جرجس، جرجا'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            'اللوكيشن: ',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          Text(
                                            'مار جرجس (جرجا)',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Dark Mode Switch & Shopping Bag
                                    Row(
                                      children: [
                                        DarkModeSwitch(
                                          headerColor: _headerColors[_headerColorIndex],
                                        ),
                                        if (appState.totalItemCount > 0) ...[
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CartScreen(),
                                                ),
                                              );
                                            },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  height: 38,
                                                  width: 38,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.shopping_bag_outlined,
                                                    color: Colors.white,
                                                    size: 19,
                                                  ),
                                                ),
                                                Positioned(
                                                  right: -2,
                                                  top: -2,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth: 16,
                                                      minHeight: 16,
                                                    ),
                                                    child: Text(
                                                      '${appState.totalItemCount}',
                                                      style: const TextStyle(
                                                        color: Color(0xFFFF5216),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // Row 2: Stadium Pill-Shaped White Search Input
                                Container(
                                  height: 46,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.08),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.search_rounded,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          onChanged: (val) => setState(
                                              () => _searchQuery = val),
                                          decoration: const InputDecoration(
                                            hintText:
                                                'ابحث عن وجبات، سوبرماركت، صيدلية، عقارات...',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                            border: InputBorder.none,
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
                      ),
                    ),

                    // 2. CITY SERVICES CAROUSEL ("ماذا تريد الآن؟" - TALABAT SQUIRCLE CARDS)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            _buildTalabatCategoryCard(
                              title: 'مطاعم',
                              imagePath: 'assets/images/cat_burger.png',
                              category: ServiceCategory.food,
                            ),
                            _buildTalabatCategoryCard(
                              title: 'سوبر ماركت',
                              imagePath: 'assets/images/cat_supermarket.png',
                              category: ServiceCategory.supermarket,
                            ),
                            _buildTalabatCategoryCard(
                              title: 'صيدليات',
                              imagePath: 'assets/images/cat_pharmacy.png',
                              category: ServiceCategory.pharmacy,
                            ),
                            _buildTalabatCategoryCard(
                              title: 'مرسول طرود',
                              imagePath: 'assets/images/cat_parcel.png',
                              category: ServiceCategory.parcelDelivery,
                            ),
                            _buildTalabatCategoryCard(
                              title: 'إلكترونيات',
                              imagePath: 'assets/images/cat_electronics.png',
                              category: ServiceCategory.electronics,
                            ),
                            _buildTalabatCategoryCard(
                              title: 'أزياء وموضة',
                              imagePath: 'assets/images/cat_fashion.png',
                              badgeText: 'خصم 15%',
                              category: ServiceCategory.fashion,
                            ),
                            _buildTalabatCategoryCard(
                              title: 'عقارات',
                              imagePath: 'assets/images/cat_realestate.png',
                              category: ServiceCategory.realEstate,
                            ),
                            _buildTalabatCategoryCard(
                              title: 'وظائف اليوم',
                              imagePath: 'assets/images/cat_jobs.png',
                              category: ServiceCategory.jobs,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 3. HERO PROMO BANNER CAROUSEL
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PromoBanner(
                        onTasteNow: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailsScreen(
                                restaurant: _girgaRestaurants[1],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. CITY FAST ACTIONS HUB ("خدمات سريعة بنقرة واحدة بالمدينة ⚡")
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'خدمات سريعة بنقرة واحدة',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF5216)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'توصيل فوري بالمدينة',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF5216),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              // Action 1: Upload Prescription
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const PharmacyScreen(),
                                      ),
                                    );
                                  },
                                  child: _buildCityFeatureCard(
                                    imagePath: 'assets/images/pharmacy_vitamins.png',
                                    title: 'رفع روشتة دواء',
                                    subtitle: 'صيدلية وتوصيل 20 د',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Action 2: Parcel Courier Express
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ParcelDeliveryScreen(),
                                      ),
                                    );
                                  },
                                  child: _buildCityFeatureCard(
                                    imagePath: 'assets/images/cat_parcel.png',
                                    title: 'طلب مرسول طرد',
                                    subtitle: 'إرسال واستلام أي شيء',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              // Action 3: Real Estate Deals
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const RealEstateScreen(),
                                      ),
                                    );
                                  },
                                  child: _buildCityFeatureCard(
                                    imagePath:
                                        'assets/images/realestate_apartment.png',
                                    title: 'عقارات بدون وسيط',
                                    subtitle: '12 شقة ومحل جديد',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Action 4: Jobs & Opportunities
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const JobsScreen(),
                                      ),
                                    );
                                  },
                                  child: _buildCityFeatureCard(
                                    imagePath:
                                        'assets/images/job_opportunity.png',
                                    title: 'وظائف اليوم',
                                    subtitle: 'تقديم مباشر فوراً',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 5. EIOP CITY EXPRESS PARCEL BANNER (HOLLOW / RECESSED BORDERED DESIGN)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ParcelDeliveryScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFFFF5216),
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF5216),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFFF5216)
                                                  .withValues(alpha: 0.35),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.two_wheeler_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'مرسول جرجا الشامل',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              'نقل طرود ومفاتيح بالمدينة',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ParcelDeliveryScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF5216),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                  ),
                                  child: const Text(
                                    'اطلب الآن',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 6. POPULAR DISHES GRID
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'أبرز خدمات ومنتجات المدينة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCatId = '';
                                    _searchQuery = '';
                                  });
                                },
                                child: const Text(
                                  'عرض الكل',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF5216),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Horizontal Category Filter Pills
                          SizedBox(
                            height: 38,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                _buildFilterChip('الكل ✨', ''),
                                _buildFilterChip('🍕 مطاعم', 'food'),
                                _buildFilterChip('🛒 سوبر ماركت', 'supermarket'),
                                _buildFilterChip('💊 صيدليات', 'pharmacy'),
                                _buildFilterChip('📱 إلكترونيات', 'electronics'),
                                _buildFilterChip('👔 أزياء', 'fashion'),
                                _buildFilterChip('🏠 عقارات', 'realEstate'),
                                _buildFilterChip('💼 وظائف', 'jobs'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.60,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemCount: _filteredDishes.length,
                            itemBuilder: (context, index) {
                              final food = _filteredDishes[index];
                              return FoodCard(
                                food: food,
                                onTap: () {
                                  switch (food.categoryId) {
                                    case 'realEstate':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const RealEstateScreen()),
                                      );
                                      break;
                                    case 'jobs':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const JobsScreen()),
                                      );
                                      break;
                                    case 'parcelDelivery':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const ParcelDeliveryScreen()),
                                      );
                                      break;
                                    case 'supermarket':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SupermarketScreen()),
                                      );
                                      break;
                                    case 'pharmacy':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const PharmacyScreen()),
                                      );
                                      break;
                                    case 'electronics':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const ElectronicsScreen()),
                                      );
                                      break;
                                    case 'fashion':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const FashionScreen()),
                                      );
                                      break;
                                    default:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FoodDetailsScreen(food: food),
                                        ),
                                      );
                                      break;
                                  }
                                },
                                onPlaceOrder: () {
                                  appState.addToCart(food, quantity: 1);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('تم إضافة "${food.title}" إلى السلة!'),
                                      backgroundColor: const Color(0xFFFF5216),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTalabatCategoryCard({
    required String title,
    required String imagePath,
    required ServiceCategory category,
    String? badgeText,
  }) {
    return GestureDetector(
      onTap: () => _onSelectServiceCategory(category),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 76,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: 64,
                      height: 64,
                    ),
                  ),
                ),
                if (badgeText != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.88),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityFeatureCard({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 115,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.88),
              Colors.black.withValues(alpha: 0.35),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String categoryId) {
    final isSelected = _selectedCatId == categoryId;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCatId = categoryId;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF5216) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF5216)
                : Colors.grey.withValues(alpha: 0.2),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF5216).withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
