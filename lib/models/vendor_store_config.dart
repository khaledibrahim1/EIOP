import 'package:flutter/material.dart';

class VendorStoreConfig {
  final String categoryId;
  final String storeTypeTitle;
  final Color primaryColor;
  final String productTerm;
  final String salesStatLabel;
  final String orderActionLabel;
  final String addProductTitle;
  final String fieldLabelTitle;
  final String extraField1Label;
  final String extraField2Label;

  const VendorStoreConfig({
    required this.categoryId,
    required this.storeTypeTitle,
    required this.primaryColor,
    required this.productTerm,
    required this.salesStatLabel,
    required this.orderActionLabel,
    required this.addProductTitle,
    required this.fieldLabelTitle,
    required this.extraField1Label,
    required this.extraField2Label,
  });

  static VendorStoreConfig fromCategoryId(String categoryId) {
    switch (categoryId) {
      case 'restaurant':
        return const VendorStoreConfig(
          categoryId: 'restaurant',
          storeTypeTitle: 'مطعم / كافيه',
          primaryColor: Color(0xFFEF4444),
          productTerm: 'الوجبات والأطباق',
          salesStatLabel: 'وجبة مباعة',
          orderActionLabel: 'بدء طهي وتحضير الوجبة 🍳',
          addProductTitle: 'إضافة وجبة جديدة للمنيو',
          fieldLabelTitle: 'اسم الوجبة / الطبق',
          extraField1Label: 'وقت التحضير (مثلاً 20-30 دقيقة)',
          extraField2Label: 'المكونات / الإضافات المتاحة',
        );

      case 'supermarket':
        return const VendorStoreConfig(
          categoryId: 'supermarket',
          storeTypeTitle: 'سوبر ماركت وبقالة',
          primaryColor: Color(0xFF10B981),
          productTerm: 'السلع والمنتجات الغذائية',
          salesStatLabel: 'سلعة مباعة',
          orderActionLabel: 'تجميع السلع وتغليف الطلب 📦',
          addProductTitle: 'إضافة سلعة غذائية للمخزن',
          fieldLabelTitle: 'اسم السلعة / المنتج',
          extraField1Label: 'الوزن أو الحجم (مثلاً 1 كجم / لتر)',
          extraField2Label: 'الكمية بالمخزن (مثلاً 50 قطعة)',
        );

      case 'pharmacy':
        return const VendorStoreConfig(
          categoryId: 'pharmacy',
          storeTypeTitle: 'صيدلية ومستلزمات طبية',
          primaryColor: Color(0xFF06B6D4),
          productTerm: 'الأدوية والمستحضرات الطبية',
          salesStatLabel: 'روشتة ودواء',
          orderActionLabel: 'تجهيز الدواء والروشتة الطبية 💊',
          addProductTitle: 'إضافة دواء / مستحضر طبي',
          fieldLabelTitle: 'اسم الدواء / المستحضر',
          extraField1Label: 'الجرعة والمادة الفعالة',
          extraField2Label: 'يتطلب روشتة طبية (نعم / لا)',
        );

      case 'electronics':
        return const VendorStoreConfig(
          categoryId: 'electronics',
          storeTypeTitle: 'إلكترونيات وهواتف',
          primaryColor: Color(0xFF6366F1),
          productTerm: 'الأجهزة والإلكترونيات',
          salesStatLabel: 'جهاز مباع',
          orderActionLabel: 'فحص الجهاز والتأكد من الضمان 🛡️',
          addProductTitle: 'إضافة جهاز إلكتروني جديد',
          fieldLabelTitle: 'اسم الجهاز / الهاتف',
          extraField1Label: 'فترة الضمان (مثلاً سنة ضمان معتمد)',
          extraField2Label: 'المواصفات الفنية (الرام / الذاكرة)',
        );

      case 'fashion':
        return const VendorStoreConfig(
          categoryId: 'fashion',
          storeTypeTitle: 'أزياء وموضة وملابس',
          primaryColor: Color(0xFFE11D48),
          productTerm: 'المنتجات والملابس',
          salesStatLabel: 'قطعة ملابس',
          orderActionLabel: 'تجهيز وتغليف قطعة الملابس 👔',
          addProductTitle: 'إضافة قطعة أزياء جديدة',
          fieldLabelTitle: 'اسم قطعة الملابس / الموديل',
          extraField1Label: 'المقاسات المتاحة (S, M, L, XL)',
          extraField2Label: 'الألوان المتاحة والخامة',
        );

      case 'real_estate':
        return const VendorStoreConfig(
          categoryId: 'real_estate',
          storeTypeTitle: 'عقارات وأراضي',
          primaryColor: Color(0xFF8B5CF6),
          productTerm: 'العقارات والوحدات',
          salesStatLabel: 'معاينة وطلب',
          orderActionLabel: 'تأكيد موعد المعاينة 🏠',
          addProductTitle: 'إضافة عقار / وحدة جديدة',
          fieldLabelTitle: 'عنوان وصف العقار بجرجا',
          extraField1Label: 'المساحة بالمتر المربع (م²)',
          extraField2Label: 'نوع العقد (إيجار / بيع)',
        );

      case 'jobs':
        return const VendorStoreConfig(
          categoryId: 'jobs',
          storeTypeTitle: 'وظائف وخدمات',
          primaryColor: Color(0xFFF59E0B),
          productTerm: 'الوظائف والخدمات',
          salesStatLabel: 'طلب توظيف',
          orderActionLabel: 'مراجعة طلب التقديم للوظيفة 💼',
          addProductTitle: 'إضافة فرصة عمل جديدة',
          fieldLabelTitle: 'المسمى الوظيفي / الخدمة',
          extraField1Label: 'الراتب / التكلفة المتوقعة',
          extraField2Label: 'نوع الدوام والشروط',
        );

      case 'parcel':
        return const VendorStoreConfig(
          categoryId: 'parcel',
          storeTypeTitle: 'توصيل طرود وشحن',
          primaryColor: Color(0xFFEC4899),
          productTerm: 'خدمات الطرود والشحن',
          salesStatLabel: 'طرد مشحون',
          orderActionLabel: 'تسليم الطرد للمندوب 🚚',
          addProductTitle: 'إضافة خط شحن / خدمة طرود',
          fieldLabelTitle: 'اسم خدمة الشحن / التوصيل',
          extraField1Label: 'نطاق التغطية والحد الأقصى',
          extraField2Label: 'تكلفة الكيلو / المنطقة',
        );

      default:
        return const VendorStoreConfig(
          categoryId: 'customer',
          storeTypeTitle: 'متجر عام',
          primaryColor: Color(0xFFFF5216),
          productTerm: 'المنتجات والخدمات',
          salesStatLabel: 'منتج مباع',
          orderActionLabel: 'تأكيد وإعداد الطلب 🚀',
          addProductTitle: 'إضافة منتج جديد',
          fieldLabelTitle: 'اسم المنتج',
          extraField1Label: 'الوصف أو الملاحظات',
          extraField2Label: 'التصنيف أو القسم',
        );
    }
  }

  List<Map<String, dynamic>> getInitialSampleProducts() {
    switch (categoryId) {
      case 'restaurant':
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
        ];

      case 'pharmacy':
        return [
          {
            'id': 'ph1',
            'title': 'بندول إكسترا مسكن آلام (24 قرص)',
            'price': 36.0,
            'oldPrice': null,
            'category': 'مسكنات وأدوية',
            'badge': 'بدون روشتة 🟢 • جرعة 500 ملغم',
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

      default:
        return [
          {
            'id': 'g1',
            'title': 'منتج مميز لمتجرك',
            'price': 100.0,
            'oldPrice': 120.0,
            'category': 'عام',
            'badge': 'متوفر بالفرع 🟢',
            'isAvailable': true,
            'imagePath': 'assets/images/food_koshary.png',
          },
        ];
    }
  }

  List<Map<String, dynamic>> getInitialSampleOrders() {
    switch (categoryId) {
      case 'restaurant':
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
      case 'supermarket':
        return [
          {
            'id': '#MARKET-412',
            'customerName': 'سامي عبدالملك',
            'phone': '01155443322',
            'address': 'جرجا - شارع المحاسنة، دقيقة من البوسطة',
            'items': '2× حليب جهينة، 1× أرز الضحى، 1× زيت عباد',
            'total': 210.0,
            'time': 'منذ 5 دقائق',
            'status': 'الجديدة',
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
      default:
        return [
          {
            'id': '#ORD-101',
            'customerName': 'عميل جديد',
            'phone': '01000000000',
            'address': 'جرجا - وسط البلد',
            'items': '1× منتج مميز',
            'total': 150.0,
            'time': 'منذ 10 دقائق',
            'status': 'الجديدة',
          },
        ];
    }
  }
}
