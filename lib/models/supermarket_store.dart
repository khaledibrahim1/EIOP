import 'supermarket_item.dart';

class SupermarketStore {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewsCount;
  final String deliveryTime;
  final double deliveryFee;
  final String coverImagePath;
  final String logoPath;
  final String address;
  final bool isOpen;
  final String phone;
  final String description;
  final String categoryId;

  const SupermarketStore({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.coverImagePath,
    required this.logoPath,
    required this.address,
    this.isOpen = true,
    this.phone = '01000000000',
    this.description = 'جميع المستلزمات والمنتجات الطازجة والتوصيل السريع',
    this.categoryId = 'all',
  });
}

// Sample Supermarket Stores in Girga
final List<SupermarketStore> sampleSupermarketStores = const [
  SupermarketStore(
    id: 'store_1',
    name: 'هايبر ماركت المدينة',
    category: 'هايبر ماركت • بقالة شاملة',
    rating: 4.9,
    reviewsCount: 340,
    deliveryTime: '15-25 دقيقة',
    deliveryFee: 10.0,
    coverImagePath: 'assets/images/cat_supermarket.png',
    logoPath: 'assets/images/supermarket_basket.png',
    address: 'الشارع التجاري - بجوار البنك الأهلي',
    isOpen: true,
    description: 'أكبر هايبر ماركت في جرجا يوفر جميع المؤن والأغذية والألبان والمنظفات بأرخص الأسعار.',
    categoryId: 'hyper',
  ),
  SupermarketStore(
    id: 'store_2',
    name: 'سوبرماركت الخير والبركة',
    category: 'ألبان • بقالة • مجمدات',
    rating: 4.8,
    reviewsCount: 215,
    deliveryTime: '15-20 دقيقة',
    deliveryFee: 8.0,
    coverImagePath: 'assets/images/supermarket_basket.png',
    logoPath: 'assets/images/cat_supermarket.png',
    address: 'شارع المحطة الرئيسي',
    isOpen: true,
    description: 'متخصصون في الألبان الطازجة، الأجبان الفاخرة والمؤن الغذائية اليومية.',
    categoryId: 'dairy',
  ),
  SupermarketStore(
    id: 'store_3',
    name: 'ماركت الفردوس للمؤن',
    category: 'مشروبات • حلويات • تسالي',
    rating: 4.7,
    reviewsCount: 180,
    deliveryTime: '20-30 دقيقة',
    deliveryFee: 10.0,
    coverImagePath: 'assets/images/cat_supermarket.png',
    logoPath: 'assets/images/supermarket_basket.png',
    address: 'ميدان النهضة - جرجا',
    isOpen: true,
    description: 'تنوع كبير في العصائر والمشروبات الباردة والحلويات والشوكولاتة المستوردة.',
    categoryId: 'drinks',
  ),
  SupermarketStore(
    id: 'store_4',
    name: 'سوبرماركت التوحيد والصفا',
    category: 'خضار وفواكه طازجة • بقالة',
    rating: 4.9,
    reviewsCount: 290,
    deliveryTime: '15-25 دقيقة',
    deliveryFee: 12.0,
    coverImagePath: 'assets/images/supermarket_basket.png',
    logoPath: 'assets/images/cat_supermarket.png',
    address: 'شارع البحر - أمام المجمع الطبي',
    isOpen: true,
    description: 'فواكه وخضروات طازجة تصل يومياً من المزارع بالإضافة لجميع احتياجات المنزل.',
    categoryId: 'fresh',
  ),
  SupermarketStore(
    id: 'store_5',
    name: 'أسواق مكة والمدينة',
    category: 'منظفات • عناية بالمنزل • بقالة',
    rating: 4.6,
    reviewsCount: 145,
    deliveryTime: '25-35 دقيقة',
    deliveryFee: 10.0,
    coverImagePath: 'assets/images/cat_supermarket.png',
    logoPath: 'assets/images/supermarket_basket.png',
    address: 'طريق الكورنيش - جرجا',
    isOpen: true,
    description: 'عروض حصرية يومية وأسبوعية على المنظفات ومنتجات العناية الشخصية والأغذية.',
    categoryId: 'hyper',
  ),
];

// Helper method to generate sample products for a specific Supermarket store
List<SupermarketItem> getStoreProducts(String storeId, String storeName) {
  return [
    SupermarketItem(
      id: '${storeId}_p1',
      storeId: storeId,
      title: 'حليب كامل الدسم طازج 1 لتر',
      category: 'ألبان واحتياجات',
      price: 38.0,
      oldPrice: 44.0,
      unit: 'عبوة 1 لتر',
      storeName: storeName,
      imagePath: 'assets/images/supermarket_basket.png',
      rating: 4.9,
      isOrganic: true,
    ),
    SupermarketItem(
      id: '${storeId}_p2',
      storeId: storeId,
      title: 'أرز بسمتي ذهبي ممتاز 5 كجم',
      category: 'بقالة ومؤن',
      price: 185.0,
      oldPrice: 210.0,
      unit: 'كيس 5 كجم',
      storeName: storeName,
      imagePath: 'assets/images/cat_supermarket.png',
      rating: 4.8,
    ),
    SupermarketItem(
      id: '${storeId}_p3',
      storeId: storeId,
      title: 'جبنة موزاريلا طبيعية 500 جم',
      category: 'ألبان واحتياجات',
      price: 95.0,
      oldPrice: 110.0,
      unit: 'كيس 500 جم',
      storeName: storeName,
      imagePath: 'assets/images/supermarket_basket.png',
      rating: 4.7,
    ),
    SupermarketItem(
      id: '${storeId}_p4',
      storeId: storeId,
      title: 'عصير برتقال طبيعي 100% 1 لتر',
      category: 'مشروبات وعصائر',
      price: 32.0,
      oldPrice: 38.0,
      unit: 'زجاجة 1 لتر',
      storeName: storeName,
      imagePath: 'assets/images/cat_supermarket.png',
      rating: 4.9,
      isOrganic: true,
    ),
    SupermarketItem(
      id: '${storeId}_p5',
      storeId: storeId,
      title: 'زيت عباد الشمس نقي 1.5 لتر',
      category: 'بقالة ومؤن',
      price: 115.0,
      oldPrice: 130.0,
      unit: 'زجاجة 1.5 لتر',
      storeName: storeName,
      imagePath: 'assets/images/supermarket_basket.png',
      rating: 4.8,
    ),
    SupermarketItem(
      id: '${storeId}_p6',
      storeId: storeId,
      title: 'مكرونة فاخرة أصناف متنوعة 1 كجم',
      category: 'بقالة ومؤن',
      price: 28.0,
      oldPrice: 34.0,
      unit: 'كيس 1 كجم',
      storeName: storeName,
      imagePath: 'assets/images/cat_supermarket.png',
      rating: 4.7,
    ),
    SupermarketItem(
      id: '${storeId}_p7',
      storeId: storeId,
      title: 'تفاح أحمر سكري طازج 1 كجم',
      category: 'خضروات وفواكه',
      price: 65.0,
      oldPrice: 75.0,
      unit: '1 كجم',
      storeName: storeName,
      imagePath: 'assets/images/supermarket_basket.png',
      rating: 4.9,
      isOrganic: true,
    ),
    SupermarketItem(
      id: '${storeId}_p8',
      storeId: storeId,
      title: 'شاي أسود فاخر 250 جم',
      category: 'مشروبات وعصائر',
      price: 45.0,
      oldPrice: 52.0,
      unit: 'عبوة 250 جم',
      storeName: storeName,
      imagePath: 'assets/images/cat_supermarket.png',
      rating: 4.8,
    ),
  ];
}
