class FashionItem {
  final String id;
  final String title;
  final String brand;
  final double price;
  final double? oldPrice;
  final List<String> availableSizes;
  final String storeName;
  final String imagePath;
  final double rating;

  const FashionItem({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    this.oldPrice,
    required this.availableSizes,
    required this.storeName,
    required this.imagePath,
    required this.rating,
  });
}

final List<FashionItem> sampleFashionItems = [
  const FashionItem(
    id: 'fas_1',
    title: 'قميص كاجوال قطن صافي',
    brand: 'Zara Men',
    price: 490.0,
    oldPrice: 590.0,
    availableSizes: ['M', 'L', 'XL', 'XXL'],
    storeName: 'بوتيك الأناقة جرجا',
    imagePath: 'assets/images/fashion_shirt.png',
    rating: 4.8,
  ),
  const FashionItem(
    id: 'fas_2',
    title: 'حذاء رياضي مريح خفيف الوزن',
    brand: 'Nike Sport',
    price: 890.0,
    oldPrice: 1100.0,
    availableSizes: ['41', '42', '43', '44'],
    storeName: 'سنتر المدينة للأحذية',
    imagePath: 'assets/images/cat_fashion.png',
    rating: 4.9,
  ),
  const FashionItem(
    id: 'fas_3',
    title: 'بنطال جينز عصري سليم فيت',
    brand: 'Levi\'s Classic',
    price: 550.0,
    availableSizes: ['30', '32', '34', '36'],
    storeName: 'بوتيك الأناقة جرجا',
    imagePath: 'assets/images/fashion_shirt.png',
    rating: 4.7,
  ),
];
