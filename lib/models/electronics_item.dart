class ElectronicsItem {
  final String id;
  final String title;
  final String brand;
  final double price;
  final double? oldPrice;
  final String specs;
  final String storeName;
  final String imagePath;
  final double rating;
  final bool hasWarranty;

  const ElectronicsItem({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    this.oldPrice,
    required this.specs,
    required this.storeName,
    required this.imagePath,
    required this.rating,
    this.hasWarranty = true,
  });
}

final List<ElectronicsItem> sampleElectronicsItems = [
  const ElectronicsItem(
    id: 'el_1',
    title: 'سماعات أذن لاسلكية ترو وايرلس',
    brand: 'Anker Soundcore',
    price: 850.0,
    oldPrice: 1050.0,
    specs: 'عزل ضوضاء • بطارية 30 ساعة • مقاومة للماء',
    storeName: 'تكنو ستور جرجا',
    imagePath: 'assets/images/cat_coffee.png',
    rating: 4.9,
  ),
  const ElectronicsItem(
    id: 'el_2',
    title: 'ساعة ذكية رياضية بأسوار سيليكون',
    brand: 'Xiaomi Smart Band',
    price: 1450.0,
    oldPrice: 1650.0,
    specs: 'قياس نبضات القلب • تتبع النوم • شاشة AMOLED',
    storeName: 'العالمية للإلكترونيات',
    imagePath: 'assets/images/cat_burger.png',
    rating: 4.8,
  ),
  const ElectronicsItem(
    id: 'el_3',
    title: 'شاحن سريع بقدرة 65 واط نوع C',
    brand: 'Joyroom Fast Charger',
    price: 320.0,
    specs: 'شحن 3 أجهزة بوقت واحد • تقنية GaN الفائقة',
    storeName: 'تكنو ستور جرجا',
    imagePath: 'assets/images/cat_pizza.png',
    rating: 4.7,
  ),
];
