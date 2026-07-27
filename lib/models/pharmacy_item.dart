class PharmacyItem {
  final String id;
  final String title;
  final String category;
  final double price;
  final String pharmacyName;
  final String description;
  final String imagePath;
  final bool requiresPrescription;

  const PharmacyItem({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.pharmacyName,
    required this.description,
    required this.imagePath,
    this.requiresPrescription = false,
  });
}

final List<PharmacyItem> samplePharmacyItems = [
  const PharmacyItem(
    id: 'ph_1',
    title: 'فيتامين C + زنك أقراص فوارة',
    category: 'مكملات وفيتامينات',
    price: 65.0,
    pharmacyName: 'صيدلية د. أحمد علي',
    description: 'أقراص فوارة لتعزيز المناعة اليومية بنكهة البرتقال الطبيعية.',
    imagePath: 'assets/images/cat_coffee.png',
    requiresPrescription: false,
  ),
  const PharmacyItem(
    id: 'ph_2',
    title: 'معجون أسنان حساس للعناية الشاملة',
    category: 'عناية شخصية',
    price: 52.0,
    pharmacyName: 'صيدلية الشفاء',
    description: 'حماية متكاملة للأسنان الحساسة وتبييض طبيعي وآمن.',
    imagePath: 'assets/images/cat_icecream.png',
    requiresPrescription: false,
  ),
  const PharmacyItem(
    id: 'ph_3',
    title: 'جهاز قياس ضغط الدم الدقيق الرقمي',
    category: 'أجهزة طبية',
    price: 640.0,
    pharmacyName: 'صيدلية د. أحمد علي',
    description: 'شاشة LCD كبيرة مع ذاكرة لتسجيل 90 قراءة سابقة.',
    imagePath: 'assets/images/cat_pizza.png',
    requiresPrescription: false,
  ),
];
