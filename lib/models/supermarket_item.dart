class SupermarketItem {
  final String id;
  final String title;
  final String category;
  final double price;
  final double? oldPrice;
  final String unit;
  final String storeName;
  final String imagePath;
  final double rating;
  final bool isOrganic;

  const SupermarketItem({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.unit,
    required this.storeName,
    required this.imagePath,
    required this.rating,
    this.isOrganic = false,
  });
}

final List<SupermarketItem> sampleSupermarketItems = [
  const SupermarketItem(
    id: 'sup_1',
    title: 'حليب كامل الدسم طازج 1 لتر',
    category: 'ألبان واحتياجات',
    price: 38.0,
    oldPrice: 44.0,
    unit: 'عبوة 1 لتر',
    storeName: 'سوبرماركت الخير',
    imagePath: 'assets/images/cat_burger.png',
    rating: 4.9,
    isOrganic: true,
  ),
  const SupermarketItem(
    id: 'sup_2',
    title: 'أرز بسمتي درجة أولى 5 كجم',
    category: 'بقالة ومؤن',
    price: 185.0,
    oldPrice: 210.0,
    unit: 'كيس 5 كجم',
    storeName: 'هايبر ماركت المدينة',
    imagePath: 'assets/images/fried_rice.png',
    rating: 4.8,
  ),
  const SupermarketItem(
    id: 'sup_3',
    title: 'جبنة موزاريلا طبيعية 500 جرام',
    category: 'ألبان واحتياجات',
    price: 95.0,
    unit: 'كيس 500 جم',
    storeName: 'سوبرماركت الخير',
    imagePath: 'assets/images/cat_pizza.png',
    rating: 4.7,
  ),
  const SupermarketItem(
    id: 'sup_4',
    title: 'عصير برتقال طبيعي 100%',
    category: 'مشروبات وعصائر',
    price: 32.0,
    oldPrice: 38.0,
    unit: 'زجاجة 1 لتر',
    storeName: 'ماركت الفردوس',
    imagePath: 'assets/images/cat_coffee.png',
    rating: 4.9,
    isOrganic: true,
  ),
];
