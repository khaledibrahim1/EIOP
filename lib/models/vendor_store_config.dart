import 'package:flutter/material.dart';

class VendorStoreConfig {
  final String categoryId;
  final String storeTypeTitle;
  final Color primaryColor;
  final IconData categoryIcon;
  final String storeBadgeText;
  final String productTerm;
  final String salesStatLabel;
  final String orderActionLabel;
  final String addProductTitle;
  final String fieldLabelTitle;
  final String extraField1Label;
  final String extraField2Label;
  final List<String> quickCategoryTags;
  final bool hasPrescriptionFeature;
  final bool hasWarrantyFeature;
  final bool hasSizeColorFeature;
  final bool hasExpiryFeature;

  const VendorStoreConfig({
    required this.categoryId,
    required this.storeTypeTitle,
    required this.primaryColor,
    required this.categoryIcon,
    required this.storeBadgeText,
    required this.productTerm,
    required this.salesStatLabel,
    required this.orderActionLabel,
    required this.addProductTitle,
    required this.fieldLabelTitle,
    required this.extraField1Label,
    required this.extraField2Label,
    required this.quickCategoryTags,
    this.hasPrescriptionFeature = false,
    this.hasWarrantyFeature = false,
    this.hasSizeColorFeature = false,
    this.hasExpiryFeature = false,
  });

  static VendorStoreConfig fromCategoryId(String categoryId) {
    switch (categoryId) {
      case 'pharmacy':
        return const VendorStoreConfig(
          categoryId: 'pharmacy',
          storeTypeTitle: 'صيدلية ومستلزمات طبية',
          primaryColor: Color(0xFF06B6D4),
          categoryIcon: Icons.medical_services_rounded,
          storeBadgeText: 'صيدلية مرخصة 💊',
          productTerm: 'الأدوية والمستحضرات الطبية',
          salesStatLabel: 'روشتة ودواء',
          orderActionLabel: 'تجهيز الدواء والروشتة الطبية 💊',
          addProductTitle: 'إضافة دواء / مستحضر طبي',
          fieldLabelTitle: 'اسم الدواء / المستحضر',
          extraField1Label: 'الجرعة والمادة الفعالة (مثلاً 500 ملغم)',
          extraField2Label: 'يلزم روشتة طبية؟ (نعم / لا)',
          quickCategoryTags: ['الكل', 'أدوية ومسكنات', 'مضادات حيوية', 'فيتامينات', 'مستلزمات', 'روشتات 📜'],
          hasPrescriptionFeature: true,
          hasExpiryFeature: true,
        );

      case 'supermarket':
        return const VendorStoreConfig(
          categoryId: 'supermarket',
          storeTypeTitle: 'سوبر ماركت وبقالة',
          primaryColor: Color(0xFF10B981),
          categoryIcon: Icons.shopping_cart_rounded,
          storeBadgeText: 'سوبرماركت شامل 🛒',
          productTerm: 'السلع والمنتجات الغذائية',
          salesStatLabel: 'سلعة مباعة',
          orderActionLabel: 'تجميع السلع وتغليف الطلب 📦',
          addProductTitle: 'إضافة سلعة غذائية للمخزن',
          fieldLabelTitle: 'اسم السلعة / المنتج',
          extraField1Label: 'الوزن أو الحجم (مثلاً 1 كجم / لتر)',
          extraField2Label: 'الكمية والمخزون المتوفر (مثلاً 50 عبوة)',
          quickCategoryTags: ['الكل', 'ألبان ومشروبات', 'حبوب وبقوليات', 'زيوت وسمن', 'منظفات', 'معلبات'],
          hasExpiryFeature: true,
        );

      case 'electronics':
        return const VendorStoreConfig(
          categoryId: 'electronics',
          storeTypeTitle: 'إلكترونيات وهواتف',
          primaryColor: Color(0xFF6366F1),
          categoryIcon: Icons.devices_rounded,
          storeBadgeText: 'معرض إلكترونيات 📱',
          productTerm: 'الأجهزة والإلكترونيات',
          salesStatLabel: 'جهاز مباع',
          orderActionLabel: 'فحص الجهاز والتأكد من الضمان 🛡️',
          addProductTitle: 'إضافة جهاز إلكتروني جديد',
          fieldLabelTitle: 'اسم الجهاز / الهاتف',
          extraField1Label: 'فترة الضمان (مثلاً سنة ضمان معتمد 🛡️)',
          extraField2Label: 'المواصفات الفنية (الرام / الذاكرة)',
          quickCategoryTags: ['الكل', 'هواتف ذكية', 'سماعات وإكسسوارات', 'أجهزة منزلية', 'كمبيوتر وتطبيقات'],
          hasWarrantyFeature: true,
        );

      case 'fashion':
        return const VendorStoreConfig(
          categoryId: 'fashion',
          storeTypeTitle: 'أزياء وموضة وملابس',
          primaryColor: Color(0xFFE11D48),
          categoryIcon: Icons.checkroom_rounded,
          storeBadgeText: 'بوتيك أزياء 👗',
          productTerm: 'المنتجات والملابس',
          salesStatLabel: 'قطعة ملابس',
          orderActionLabel: 'تجهيز وتغليف قطعة الملابس 👔',
          addProductTitle: 'إضافة قطعة أزياء جديدة',
          fieldLabelTitle: 'اسم قطعة الملابس / الموديل',
          extraField1Label: 'المقاسات المتاحة (S, M, L, XL, XXL)',
          extraField2Label: 'الألوان المتاحة وخامة القماش',
          quickCategoryTags: ['الكل', 'ملابس رجالي', 'ملابس حريمي', 'أطفال', 'أحذية', 'إكسسوارات أزياء'],
          hasSizeColorFeature: true,
        );

      case 'real_estate':
      case 'realEstate':
        return const VendorStoreConfig(
          categoryId: 'real_estate',
          storeTypeTitle: 'عقارات وأراضي',
          primaryColor: Color(0xFF8B5CF6),
          categoryIcon: Icons.landscape_rounded,
          storeBadgeText: 'مكتب عقارات وأراضي 🏗️',
          productTerm: 'العقارات والأراضي',
          salesStatLabel: 'معاينة وطلب',
          orderActionLabel: 'تأكيد موعد المعاينة 🏠',
          addProductTitle: 'إضافة عقار / قطعة أرض جديدة',
          fieldLabelTitle: 'عنوان وصف العقار/الأرض بجرجا',
          extraField1Label: 'المساحة (م² / قراريط)',
          extraField2Label: 'نوع العقد (إيجار / بيع / مباني / زراعي)',
          quickCategoryTags: ['الكل', 'أراضي مباني', 'أراضي زراعية', 'شقق تمليك', 'شقق إيجار', 'محلات تجارية'],
        );

      case 'jobs':
        return const VendorStoreConfig(
          categoryId: 'jobs',
          storeTypeTitle: 'وظائف وخدمات',
          primaryColor: Color(0xFFF59E0B),
          categoryIcon: Icons.work_outline_rounded,
          storeBadgeText: 'مركز توظيف 💼',
          productTerm: 'الوظائف والخدمات',
          salesStatLabel: 'طلب توظيف',
          orderActionLabel: 'مراجعة طلب التقديم للوظيفة 💼',
          addProductTitle: 'إضافة فرصة عمل جديدة',
          fieldLabelTitle: 'المسمى الوظيفي / الخدمة',
          extraField1Label: 'الراتب / التكلفة المتوقعة',
          extraField2Label: 'نوع الدوام والشروط المطلوب',
          quickCategoryTags: ['الكل', 'وظائف كاملة', 'دوام جزئي', 'خدمات مهنية', 'عمل حر'],
        );

      case 'parcel':
        return const VendorStoreConfig(
          categoryId: 'parcel',
          storeTypeTitle: 'توصيل طرود وشحن',
          primaryColor: Color(0xFFEC4899),
          categoryIcon: Icons.local_shipping_rounded,
          storeBadgeText: 'مركز شحن 🚚',
          productTerm: 'خدمات الطرود والشحن',
          salesStatLabel: 'طرد مشحون',
          orderActionLabel: 'تسليم الطرد للمندوب 🚚',
          addProductTitle: 'إضافة خط شحن / خدمة طرود',
          fieldLabelTitle: 'اسم خدمة الشحن / التوصيل',
          extraField1Label: 'نطاق التغطية والحد الأقصى',
          extraField2Label: 'تكلفة الكيلو / المنطقة',
          quickCategoryTags: ['الكل', 'نقل طرود', 'شحن سريع', 'توصيل مستندات', 'محافظات'],
        );

      case 'restaurant':
      default:
        return const VendorStoreConfig(
          categoryId: 'restaurant',
          storeTypeTitle: 'مطعم / كافيه',
          primaryColor: Color(0xFFEF4444),
          categoryIcon: Icons.restaurant_rounded,
          storeBadgeText: 'مطعم وجبات 🍳',
          productTerm: 'الوجبات والأطباق',
          salesStatLabel: 'وجبة مباعة',
          orderActionLabel: 'بدء طهي وتحضير الوجبة 🍳',
          addProductTitle: 'إضافة وجبة جديدة للمنيو',
          fieldLabelTitle: 'اسم الوجبة / الطبق',
          extraField1Label: 'وقت التحضير (مثلاً 20-30 دقيقة ⏱️)',
          extraField2Label: 'المكونات والإضافات المتاحة',
          quickCategoryTags: ['الكل', 'وجبات رئيسية', 'بيتزا وفطائر', 'ساندوتشات', 'مشويات', 'مشروبات وحلو'],
        );
    }
  }

  List<Map<String, dynamic>> getInitialSampleProducts() {
    switch (categoryId) {
      case 'pharmacy':
        return [
          {
            'id': 'ph1',
            'title': 'بندول إكسترا مسكن آلام (24 قرص)',
            'price': 36.0,
            'oldPrice': null,
            'category': 'أدوية ومسكنات',
            'badge': 'بدون روشتة 🟢 • 500 ملغم',
            'isAvailable': true,
            'imagePath': 'assets/images/pharmacy_panadol.png',
          },
          {
            'id': 'ph2',
            'title': 'مضاد حيوي أوجمنتين 1 جرام',
            'price': 98.0,
            'oldPrice': 110.0,
            'category': 'مضادات حيوية',
            'badge': 'يلزم روشتة طبية 📜',
            'isAvailable': true,
            'imagePath': 'assets/images/cat_pharmacy.png',
          },
          {
            'id': 'ph3',
            'title': 'فيتامين C سبيشال فورفيل 1000 ملغم',
            'price': 65.0,
            'oldPrice': 75.0,
            'category': 'فيتامينات',
            'badge': 'صلاحية حتى 12/2027 🟢',
            'isAvailable': true,
            'imagePath': 'assets/images/pharmacy_panadol.png',
          },
        ];

      case 'supermarket':
        return [
          {
            'id': 's1',
            'title': 'حليب جهينة كامل الدسم 1 لتر',
            'price': 42.0,
            'oldPrice': 46.0,
            'category': 'ألبان ومشروبات',
            'badge': 'المخزون: 65 عبوة 📦 • 1 لتر',
            'isAvailable': true,
            'imagePath': 'assets/images/supermarket_milk.png',
          },
          {
            'id': 's2',
            'title': 'أرز الضحى الفاخر 1 كجم',
            'price': 35.0,
            'oldPrice': null,
            'category': 'حبوب وبقوليات',
            'badge': 'المخزون: 120 كجم ⚖️',
            'isAvailable': true,
            'imagePath': 'assets/images/cat_supermarket.png',
          },
          {
            'id': 's3',
            'title': 'زيت عافية عباد الشمس 2.25 لتر',
            'price': 165.0,
            'oldPrice': 180.0,
            'category': 'زيوت وسمن',
            'badge': 'المخزون: 40 عبوة 📦',
            'isAvailable': true,
            'imagePath': 'assets/images/cat_supermarket.png',
          },
        ];

      case 'electronics':
        return [
          {
            'id': 'e1',
            'title': 'سماعات أبل إيربودز برو الأصلي',
            'price': 4200.0,
            'oldPrice': 4800.0,
            'category': 'سماعات وإكسسوارات',
            'badge': 'ضمان 12 شهراً معتمد 🛡️',
            'isAvailable': true,
            'imagePath': 'assets/images/electronics_earbuds.png',
          },
          {
            'id': 'e2',
            'title': 'هاتف سامسونج جالاكسي A54 رام 8G',
            'price': 14500.0,
            'oldPrice': 15200.0,
            'category': 'هواتف ذكية',
            'badge': 'ضمان سنة 🛡️ • ذاكرة 256G',
            'isAvailable': true,
            'imagePath': 'assets/images/cat_electronics.png',
          },
        ];

      case 'fashion':
        return [
          {
            'id': 'f1',
            'title': 'قميص كاجوال قطن 100% أنيق',
            'price': 380.0,
            'oldPrice': 450.0,
            'category': 'ملابس رجالي',
            'badge': 'المقاسات: M, L, XL 📏 • أسود وكحلي',
            'isAvailable': true,
            'imagePath': 'assets/images/fashion_shirt.png',
          },
          {
            'id': 'f2',
            'title': 'فستان سهرة أنيق عالي الجودة',
            'price': 850.0,
            'oldPrice': null,
            'category': 'ملابس حريمي',
            'badge': 'المقاسات: S, M, L 📏',
            'isAvailable': true,
            'imagePath': 'assets/images/cat_fashion.png',
          },
        ];

      case 'real_estate':
      case 'realEstate':
        return [
          {
            'id': 're1',
            'title': 'قطعة أرض مباني متميزة بجرجا (175 م²)',
            'price': 1450000.0,
            'oldPrice': 1550000.0,
            'category': 'أراضي مباني',
            'badge': 'المساحة: 175 م² 📐 • كاملة المرافق',
            'isAvailable': true,
            'imagePath': 'assets/images/cat_realestate.png',
          },
          {
            'id': 're2',
            'title': 'أرض استثمارية/زراعية بجرجا (5 قراريط)',
            'price': 650000.0,
            'oldPrice': null,
            'category': 'أراضي زراعية',
            'badge': 'المساحة: 5 قراريط 🌾 • واجهة على طريق رئيسي',
            'isAvailable': true,
            'imagePath': 'assets/images/cat_realestate.png',
          },
          {
            'id': 're3',
            'title': 'شقة تمليك فاخرة سوبر لوكس شارع المحطة',
            'price': 850000.0,
            'oldPrice': 920000.0,
            'category': 'شقق تمليك',
            'badge': 'المساحة: 140 م² 🏢 • 3 غرف نوم',
            'isAvailable': true,
            'imagePath': 'assets/images/realestate_apartment.png',
          },
          {
            'id': 're4',
            'title': 'محل تجاري حيوي الشارع التجاري الرئيسي',
            'price': 1200000.0,
            'oldPrice': null,
            'category': 'محلات تجارية',
            'badge': 'المساحة: 65 م² 🏪 • واجهة زجاجية',
            'isAvailable': true,
            'imagePath': 'assets/images/cat_realestate.png',
          },
        ];

      case 'restaurant':
      default:
        return [
          {
            'id': 'r1',
            'title': 'كشري فاخر ميكس سبيشال',
            'price': 45.0,
            'oldPrice': 55.0,
            'category': 'وجبات رئيسية',
            'badge': 'وقت التحضير: 15 دقيقة ⏱️',
            'isAvailable': true,
            'imagePath': 'assets/images/food_koshary.png',
          },
          {
            'id': 'r2',
            'title': 'بيتزا ميكس جبن إيطالي دبل',
            'price': 120.0,
            'oldPrice': null,
            'category': 'بيتزا وفطائر',
            'badge': 'وقت التحضير: 25 دقيقة ⏱️',
            'isAvailable': true,
            'imagePath': 'assets/images/food_pizza.png',
          },
          {
            'id': 'r3',
            'title': 'ساندوتش شاورما عربي دبل',
            'price': 85.0,
            'oldPrice': 95.0,
            'category': 'ساندوتشات',
            'badge': 'وقت التحضير: 12 دقيقة ⏱️',
            'isAvailable': false,
            'imagePath': 'assets/images/food_burger.png',
          },
        ];
    }
  }

  List<Map<String, dynamic>> getInitialSampleOrders() {
    switch (categoryId) {
      case 'real_estate':
      case 'realEstate':
        return [
          {
            'id': '#LAND-901',
            'customerName': 'أحمد محمود',
            'phone': '01012345678',
            'address': 'جرجا - شارع المحطة، بجوار البنك الأهلي',
            'items': 'معاينة: أرض مباني 175م² بجرجا (شارع المطار) - عقد تمليك',
            'total': 250000.0,
            'time': 'منذ 5 دقائق',
            'status': 'معاينات جديدة',
          },
          {
            'id': '#REAL-804',
            'customerName': 'عمر خالد',
            'phone': '01155443322',
            'address': 'جرجا - بحري النفق الرئيسي',
            'items': 'معاينة وتفاصيل تقسيط: شقة سكنية 120م² برج الأطباء - تقسيط شهري 5,000 ج.م',
            'total': 750000.0,
            'time': 'منذ ساعتين',
            'status': 'موعد محدد',
          },
          {
            'id': '#LAND-712',
            'customerName': 'محمود عبد الفتاح',
            'phone': '01288776655',
            'address': 'جرجا - طريق سوهاج الزراعي',
            'items': 'استفسار معاينة: أرض زراعية 5 قراريط بحري جرجا',
            'total': 450000.0,
            'time': 'أمس',
            'status': 'معاينات مكتملة',
          },
        ];

      case 'pharmacy':
        return [
          {
            'id': '#PHARM-304',
            'customerName': 'د. خلود حسن',
            'phone': '01288776655',
            'address': 'جرجا - شارع المستشفى العام',
            'items': '1× بندول إكسترا، 1× كحول طبي، 1× فيتامين C (مرفق صورة الروشتة 📜)',
            'total': 145.0,
            'time': 'منذ 8 دقائق',
            'status': 'الجديدة',
          },
        ];

      case 'supermarket':
        return [
          {
            'id': '#MARKET-412',
            'customerName': 'سامي عبدالملك',
            'phone': '01155443322',
            'address': 'جرجا - شارع المحاسنة، دقيقة من البوسطة',
            'items': '2× حليب جهينة، 1× أرز الضحى، 1× زيت عباد الشمس',
            'total': 210.0,
            'time': 'منذ 5 دقائق',
            'status': 'الجديدة',
          },
        ];

      case 'electronics':
        return [
          {
            'id': '#TECH-802',
            'customerName': 'مصطفى كمال',
            'phone': '01099884433',
            'address': 'جرجا - ش البحر، برج النور',
            'items': '1× سماعة إيربودز برو (طلب بطاقة الضمان 🛡️)',
            'total': 4200.0,
            'time': 'منذ 15 دقيقة',
            'status': 'الجديدة',
          },
        ];

      case 'fashion':
        return [
          {
            'id': '#FASH-615',
            'customerName': 'مروة علي',
            'phone': '01122998877',
            'address': 'جرجا - شارع التجارة، شقة 4',
            'items': '1× قميص كاجوال (مقاس L - لون كحلي)',
            'total': 380.0,
            'time': 'منذ 20 دقيقة',
            'status': 'الجديدة',
          },
        ];



      case 'parcel':
      case 'parcelDelivery':
        return [
          {
            'id': '#PRCL-901',
            'customerName': 'كابتن أحمد حسني',
            'phone': '01011223344',
            'address': 'استلام: شارع المحطة (جرجا) ➔ تسليم: ميدان النهضة',
            'items': 'طرد: مستندات وأوراق أمانة قانونية (شحنة اكسبريس عاجلة ⚡)',
            'total': 25.0,
            'time': 'منذ 3 دقائق',
            'status': 'طلبات جديدة',
            'pickupLat': 26.3385,
            'pickupLng': 31.8912,
            'dropoffLat': 26.3420,
            'dropoffLng': 31.8870,
            'captain': 'كابتن محمود السوهاجي',
            'plate': 'AB6299ZG',
          },
          {
            'id': '#PRCL-714',
            'customerName': 'عمر خالد (صيدلية النور)',
            'phone': '01155443322',
            'address': 'استلام: شارع المستشفى العام ➔ تسليم: شارع البحر',
            'items': 'طرد: أدوية ومستلزمات طبية معقمة (التعامل بحذر ⚠️)',
            'total': 30.0,
            'time': 'منذ 15 دقيقة',
            'status': 'قيد التوصيل',
            'pickupLat': 26.3365,
            'pickupLng': 31.8965,
            'dropoffLat': 26.3390,
            'dropoffLng': 31.8850,
            'captain': 'كابتن مصطفى طه',
            'plate': 'EG4410XY',
          },
          {
            'id': '#PRCL-550',
            'customerName': 'مؤسسة الشروق',
            'phone': '01288776655',
            'address': 'استلام: شارع الأهرام التجاري ➔ تسليم: شارع المطار',
            'items': 'شحنة: ملابس وأقمشة ومستلزمات أمانات 📦',
            'total': 45.0,
            'time': 'أمس',
            'status': 'تم التسليم',
            'pickupLat': 26.3350,
            'pickupLng': 31.8950,
            'dropoffLat': 26.3310,
            'dropoffLng': 31.8820,
            'captain': 'كابتن كريم حسن',
            'plate': 'SU8821AB',
          },
        ];

      case 'restaurant':
      default:
        return [
          {
            'id': '#FOOD-991',
            'customerName': 'أحمد محمود',
            'phone': '01012345678',
            'address': 'جرجا - شارع المحطة، بجوار البنك الأهلي',
            'items': '2× كشري فاخر، 1× بيبي بيبسي، 1× حلو',
            'total': 185.0,
            'time': 'منذ 3 دقائق',
            'status': 'الجديدة',
          },
        ];
    }
  }
}
