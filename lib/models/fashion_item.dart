class FashionItem {
  final String id;
  final String title;
  final String brand;
  final String category;
  final double price;
  final double? oldPrice;
  final List<String> availableSizes;
  final List<String> availableColors;
  final String storeName;
  final String imagePath;
  final double rating;
  final int reviewCount;
  final String specs;
  final bool isNew;
  final bool isBestSeller;

  const FashionItem({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.availableSizes,
    this.availableColors = const [],
    required this.storeName,
    required this.imagePath,
    required this.rating,
    this.reviewCount = 0,
    this.specs = '',
    this.isNew = false,
    this.isBestSeller = false,
  });
}

class FashionStoreModel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final String deliveryTime;
  final String phone;
  final String coverImage;
  final List<String> categories;

  const FashionStoreModel({
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

final List<FashionStoreModel> girgaFashionStores = [
  const FashionStoreModel(
    id: 'fst_1',
    name: 'بوتيك الأناقة جرجا',
    location: 'شارع المحطة - أمام الكنيسة الكبيرة',
    rating: 4.9,
    deliveryTime: '30-50 دقيقة',
    phone: '01091234567',
    coverImage: 'assets/images/cat_fashion.png',
    categories: ['رجالي', 'نسائي', 'قمصان', 'بناطيل'],
  ),
  const FashionStoreModel(
    id: 'fst_2',
    name: 'سنتر المدينة للأحذية',
    location: 'ميدان النهضة - الدور الأرضي',
    rating: 4.8,
    deliveryTime: '20-40 دقيقة',
    phone: '01159876543',
    coverImage: 'assets/images/cat_fashion.png',
    categories: ['أحذية رجالية', 'أحذية نسائية', 'رياضي', 'كلاسيك'],
  ),
  const FashionStoreModel(
    id: 'fst_3',
    name: 'فاشون هاوس',
    location: 'شارع الجمهورية - بجوار بنك مصر',
    rating: 4.75,
    deliveryTime: '25-45 دقيقة',
    phone: '01234567891',
    coverImage: 'assets/images/cat_fashion.png',
    categories: ['ملابس أطفال', 'ملابس شبابية', 'إكسسوارات'],
  ),
  const FashionStoreModel(
    id: 'fst_4',
    name: 'نيو ستايل جرجا',
    location: 'شارع الملك فيصل - أمام محكمة جرجا',
    rating: 4.7,
    deliveryTime: '35-55 دقيقة',
    phone: '01012345678',
    coverImage: 'assets/images/cat_fashion.png',
    categories: ['بنطلونات', 'جاكيتات', 'ملابس محتشمة'],
  ),
];

final List<FashionItem> sampleFashionItems = [
  // بوتيك الأناقة جرجا
  const FashionItem(
    id: 'fas_1',
    title: 'قميص كاجوال قطن صافي',
    brand: 'Zara Men',
    category: 'قمصان',
    price: 490.0,
    oldPrice: 590.0,
    availableSizes: ['S', 'M', 'L', 'XL', 'XXL'],
    availableColors: ['أبيض', 'أزرق فاتح', 'رمادي'],
    storeName: 'بوتيك الأناقة جرجا',
    imagePath: 'assets/images/fashion_shirt.png',
    rating: 4.8,
    reviewCount: 124,
    specs: 'قماش قطن 100% • مريح للاستخدام اليومي • سهل الغسيل',
    isBestSeller: true,
  ),
  const FashionItem(
    id: 'fas_2',
    title: 'قميص رسمي أوكسفورد',
    brand: 'H&M',
    category: 'قمصان',
    price: 620.0,
    oldPrice: 780.0,
    availableSizes: ['M', 'L', 'XL'],
    availableColors: ['أبيض', 'كحلي', 'سماوي'],
    storeName: 'بوتيك الأناقة جرجا',
    imagePath: 'assets/images/fashion_shirt.png',
    rating: 4.7,
    reviewCount: 87,
    specs: 'قماش أوكسفورد مصري • كم طويل • مناسب للمقابلات والمناسبات',
    isNew: true,
  ),
  const FashionItem(
    id: 'fas_3',
    title: 'بنطال جينز سليم فيت عصري',
    brand: "Levi's Classic",
    category: 'بناطيل',
    price: 550.0,
    oldPrice: 750.0,
    availableSizes: ['30', '32', '34', '36', '38'],
    availableColors: ['أزرق غامق', 'أسود', 'رمادي'],
    storeName: 'بوتيك الأناقة جرجا',
    imagePath: 'assets/images/fashion_shirt.png',
    rating: 4.7,
    reviewCount: 203,
    specs: "دنيم سترتش 98% قطن • سليم فيت • جيوب أمامية وخلفية",
    isBestSeller: true,
  ),
  const FashionItem(
    id: 'fas_4',
    title: 'تيشيرت بولو مضلع',
    brand: 'Polo Ralph',
    category: 'رجالي',
    price: 380.0,
    availableSizes: ['S', 'M', 'L', 'XL'],
    availableColors: ['أبيض', 'أسود', 'أخضر'],
    storeName: 'بوتيك الأناقة جرجا',
    imagePath: 'assets/images/fashion_shirt.png',
    rating: 4.6,
    reviewCount: 56,
    specs: 'بيكيه مضلع • أزرار عند الرقبة • مريح وعصري',
    isNew: true,
  ),
  // سنتر المدينة للأحذية
  const FashionItem(
    id: 'fas_5',
    title: 'حذاء رياضي مريح خفيف الوزن',
    brand: 'Nike Sport',
    category: 'أحذية رجالية',
    price: 890.0,
    oldPrice: 1100.0,
    availableSizes: ['40', '41', '42', '43', '44', '45'],
    availableColors: ['أسود/أبيض', 'رمادي', 'أزرق'],
    storeName: 'سنتر المدينة للأحذية',
    imagePath: 'assets/images/cat_fashion.png',
    rating: 4.9,
    reviewCount: 318,
    specs: 'نعل هوائي • شبكة تهوية • خفيف جداً 280 جرام',
    isBestSeller: true,
  ),
  const FashionItem(
    id: 'fas_6',
    title: 'حذاء كلاسيك جلد طبيعي',
    brand: 'Clarks',
    category: 'كلاسيك',
    price: 1200.0,
    oldPrice: 1500.0,
    availableSizes: ['41', '42', '43', '44'],
    availableColors: ['بني', 'أسود'],
    storeName: 'سنتر المدينة للأحذية',
    imagePath: 'assets/images/cat_fashion.png',
    rating: 4.8,
    reviewCount: 145,
    specs: 'جلد طبيعي أصلي • نعل مريح • مناسب للعمل والمناسبات',
  ),
  const FashionItem(
    id: 'fas_7',
    title: 'بالرينا نسائي مريح',
    brand: 'Aldo',
    category: 'أحذية نسائية',
    price: 650.0,
    oldPrice: 850.0,
    availableSizes: ['36', '37', '38', '39', '40'],
    availableColors: ['بيج', 'أسود', 'ورديّ'],
    storeName: 'سنتر المدينة للأحذية',
    imagePath: 'assets/images/cat_fashion.png',
    rating: 4.7,
    reviewCount: 92,
    specs: 'جلد ناعم • نعل مطاطي • مقدمة مستديرة',
    isNew: true,
  ),
  const FashionItem(
    id: 'fas_8',
    title: 'حذاء رياضي نسائي رن',
    brand: 'Adidas Run',
    category: 'رياضي',
    price: 750.0,
    availableSizes: ['36', '37', '38', '39'],
    availableColors: ['أبيض/وردي', 'أسود/ذهبي'],
    storeName: 'سنتر المدينة للأحذية',
    imagePath: 'assets/images/cat_fashion.png',
    rating: 4.8,
    reviewCount: 178,
    specs: 'Boost foam • شبكة تهوية علوية • مقاومة للماء الخفيف',
    isBestSeller: true,
  ),
  // فاشون هاوس
  const FashionItem(
    id: 'fas_9',
    title: 'بدلة رياضية أطفال بهوديّ',
    brand: 'Gap Kids',
    category: 'ملابس أطفال',
    price: 320.0,
    oldPrice: 420.0,
    availableSizes: ['2-3 سنوات', '4-5 سنوات', '6-7 سنوات', '8-9 سنوات'],
    availableColors: ['أزرق', 'أحمر', 'رمادي'],
    storeName: 'فاشون هاوس',
    imagePath: 'assets/images/cat_fashion.png',
    rating: 4.8,
    reviewCount: 67,
    specs: 'قطن ناعم • سهل الغسيل • يتحمل الاستخدام المكثف',
  ),
  const FashionItem(
    id: 'fas_10',
    title: 'إكسسوار شال كاشمير',
    brand: 'Burberry Style',
    category: 'إكسسوارات',
    price: 280.0,
    availableSizes: ['مقاس واحد'],
    availableColors: ['بيج/أحمر', 'رمادي/أسود', 'كريمي'],
    storeName: 'فاشون هاوس',
    imagePath: 'assets/images/cat_fashion.png',
    rating: 4.7,
    reviewCount: 41,
    specs: 'خيوط كاشمير ناعمة • مناسب للشتاء • أبعاد 180×30 سم',
    isNew: true,
  ),
  // نيو ستايل جرجا
  const FashionItem(
    id: 'fas_11',
    title: 'جاكيت شتوي دافئ',
    brand: 'Zara Outerwear',
    category: 'جاكيتات',
    price: 1350.0,
    oldPrice: 1800.0,
    availableSizes: ['M', 'L', 'XL', 'XXL'],
    availableColors: ['كاكي', 'أسود', 'نيفي'],
    storeName: 'نيو ستايل جرجا',
    imagePath: 'assets/images/fashion_shirt.png',
    rating: 4.9,
    reviewCount: 89,
    specs: 'حشوة بوليستر • مقاوم للرياح • طراز bomber',
    isBestSeller: true,
  ),
  const FashionItem(
    id: 'fas_12',
    title: 'عباءة محتشمة أنيقة',
    brand: 'Modest Mode',
    category: 'ملابس محتشمة',
    price: 680.0,
    oldPrice: 850.0,
    availableSizes: ['M', 'L', 'XL', 'XXL', 'XXXL'],
    availableColors: ['أسود', 'بيج', 'نيفي', 'كحلي'],
    storeName: 'نيو ستايل جرجا',
    imagePath: 'assets/images/cat_fashion.png',
    rating: 4.8,
    reviewCount: 156,
    specs: 'قماش ساتان • قصة واسعة مريحة • مناسبة للمناسبات',
    isNew: true,
  ),
];
