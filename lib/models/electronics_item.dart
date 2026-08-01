class ElectronicsItem {
  final String id;
  final String title;
  final String category;
  final String brand;
  final double price;
  final double? oldPrice;
  final String specs;
  final List<String> specTags;
  final String storeName;
  final String imagePath;
  final double rating;
  final int reviewsCount;
  final bool hasWarranty;
  final bool installmentAvailable;
  final bool isBestSeller;

  const ElectronicsItem({
    required this.id,
    required this.title,
    required this.category,
    required this.brand,
    required this.price,
    this.oldPrice,
    required this.specs,
    this.specTags = const [],
    required this.storeName,
    required this.imagePath,
    required this.rating,
    this.reviewsCount = 45,
    this.hasWarranty = true,
    this.installmentAvailable = true,
    this.isBestSeller = false,
  });
}

class ElectronicsStoreModel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final String deliveryTime;
  final String phone;
  final String coverImage;
  final List<String> categories;

  const ElectronicsStoreModel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.deliveryTime,
    required this.phone,
    required this.coverImage,
    required this.categories,
  });
}

final List<ElectronicsStoreModel> girgaElectronicsStores = [
  const ElectronicsStoreModel(
    id: 'store_1',
    name: 'تكنو ستور جرجا',
    location: 'شارع المحطة - أمام البنك الأهلي',
    rating: 4.9,
    deliveryTime: '20-35 دقيقة',
    phone: '01091234567',
    coverImage: 'assets/images/cat_electronics.png',
    categories: ['هواتف', 'سماعات', 'شواحن', 'صيانة'],
  ),
  const ElectronicsStoreModel(
    id: 'store_2',
    name: 'الشرق الأوسط للهواتف',
    location: 'ميدان النهضة - الشارع التجاري',
    rating: 4.8,
    deliveryTime: '15-30 دقيقة',
    phone: '01159876543',
    coverImage: 'assets/images/cat_electronics.png',
    categories: ['هواتف', 'ساعات ذكية', 'إكسسوارات'],
  ),
  const ElectronicsStoreModel(
    id: 'store_3',
    name: 'العالمية للإلكترونيات',
    location: 'شارع الأهرام - بجوار المجمع الطبي',
    rating: 4.75,
    deliveryTime: '25-40 دقيقة',
    phone: '01234567891',
    coverImage: 'assets/images/cat_electronics.png',
    categories: ['كمبيوتر', 'صوتيات', 'كاميرات'],
  ),
];

final List<ElectronicsItem> sampleElectronicsItems = [
  const ElectronicsItem(
    id: 'el_1',
    title: 'سماعات أذن لاسلكية ترو وايرلس ANC',
    category: 'سماعات وصوتيات',
    brand: 'Anker Soundcore',
    price: 850.0,
    oldPrice: 1050.0,
    specs: 'عزل ضوضاء نشط ANC • بطارية 30 ساعة • مقاومة للماء IPX5',
    specTags: ['عزل ضوضاء', '30 ساعة عمل', 'ضمان عامين'],
    storeName: 'تكنو ستور جرجا',
    imagePath: 'assets/images/electronics_earbuds.png',
    rating: 4.9,
    reviewsCount: 128,
    hasWarranty: true,
    isBestSeller: true,
  ),
  const ElectronicsItem(
    id: 'el_2',
    title: 'ساعة ذكية رياضية بأسوار سيليكون شاشة AMOLED',
    category: 'ساعات ذكية',
    brand: 'Xiaomi Smart Band',
    price: 1450.0,
    oldPrice: 1650.0,
    specs: 'قياس نبضات القلب • تتبع النوم والرياضة • ضد الماء 50م',
    specTags: ['شاشة AMOLED', 'تتبع اللياقة', 'بطارية 14 يوم'],
    storeName: 'الشرق الأوسط للهواتف',
    imagePath: 'assets/images/cat_electronics.png',
    rating: 4.8,
    reviewsCount: 94,
    hasWarranty: true,
    isBestSeller: true,
  ),
  const ElectronicsItem(
    id: 'el_3',
    title: 'شاحن جداري سريع بقدرة 65 واط نوع C تقنية GaN',
    category: 'شواحن وكوابل',
    brand: 'Joyroom Fast Charger',
    price: 320.0,
    oldPrice: 400.0,
    specs: 'شحن 3 أجهزة بوقت واحد • تقنية GaN الفائقة • حماية ضد السخونة',
    specTags: ['65W GaN', 'شحن ثلاثي', 'حماية ذكية'],
    storeName: 'تكنو ستور جرجا',
    imagePath: 'assets/images/electronics_earbuds.png',
    rating: 4.7,
    reviewsCount: 62,
    hasWarranty: true,
    isBestSeller: false,
  ),
  const ElectronicsItem(
    id: 'el_4',
    title: 'هاتف سامسونج جالاكسي A54 رام 8 جيجا - 256 جيجا',
    category: 'هواتف وتابلت',
    brand: 'Samsung',
    price: 13900.0,
    oldPrice: 15200.0,
    specs: 'شاشة Super AMOLED 120Hz • كاميرا 50 ميجا • بطارية 5000mAh',
    specTags: ['5G', '256GB', 'ضمان محلي'],
    storeName: 'الشرق الأوسط للهواتف',
    imagePath: 'assets/images/cat_electronics.png',
    rating: 4.95,
    reviewsCount: 210,
    hasWarranty: true,
    isBestSeller: true,
  ),
  const ElectronicsItem(
    id: 'el_5',
    title: 'باور بنك بسعة 20,000 ملّي أمبير شحن سريع 22.5W',
    category: 'شواحن وكوابل',
    brand: 'Baseus Digital Display',
    price: 980.0,
    oldPrice: 1150.0,
    specs: 'شاشة رقمية لنسبة الشحن • منفذين Type-C و USB • هيكل ألومنيوم',
    specTags: ['20000mAh', '22.5W', 'شاشة LED'],
    storeName: 'العالمية للإلكترونيات',
    imagePath: 'assets/images/electronics_earbuds.png',
    rating: 4.85,
    reviewsCount: 75,
    hasWarranty: true,
    isBestSeller: false,
  ),
  const ElectronicsItem(
    id: 'el_6',
    title: 'ماوس وايرلس جيمنج احترافي RGB ببطارية قابلة للشحن',
    category: 'إكسسوارات كمبيوتر',
    brand: 'Logitech Wireless',
    price: 650.0,
    specs: 'مستشعر دقيق 16000 DPI • أزرار قابلة للبرمجة • إضاءة RGB',
    specTags: ['16000 DPI', 'RGB', 'Wireless'],
    storeName: 'تكنو ستور جرجا',
    imagePath: 'assets/images/cat_electronics.png',
    rating: 4.65,
    reviewsCount: 41,
    hasWarranty: true,
    isBestSeller: false,
  ),
];
