class PharmacyItem {
  final String id;
  final String title;
  final String category;
  final double price;
  final String pharmacyName;
  final String description;
  final String imagePath;
  final bool requiresPrescription;
  final double rating;

  const PharmacyItem({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.pharmacyName,
    required this.description,
    required this.imagePath,
    this.requiresPrescription = false,
    this.rating = 4.8,
  });
}

final List<PharmacyItem> samplePharmacyItems = const [
  PharmacyItem(
    id: 'ph_1',
    title: 'فيتامين C + زنك أقراص فوارة',
    category: 'فيتامينات ومكملات',
    price: 65.0,
    pharmacyName: 'صيدلية الشفاء',
    description: 'أقراص فوارة لتعزيز المناعة اليومية والحماية من نزلات البرد.',
    imagePath: 'assets/images/pharmacy_vitamins.png',
    requiresPrescription: false,
    rating: 4.9,
  ),
  PharmacyItem(
    id: 'ph_2',
    title: 'بنادول إكسترا مسكن سريع للآلام',
    category: 'مسكنات وأدوية برد',
    price: 45.0,
    pharmacyName: 'صيدلية النور والرحمة',
    description: 'أقراص تسكين الصداع والآلام الشديدة مع كافيين لتعزيز المفعول.',
    imagePath: 'assets/images/cat_pharmacy.png',
    requiresPrescription: false,
    rating: 4.9,
  ),
  PharmacyItem(
    id: 'ph_3',
    title: 'جهاز قياس ضغط الدم الرقمي الدقيق',
    category: 'أجهزة طبية',
    price: 650.0,
    pharmacyName: 'صيدلية السلام والأهرام',
    description: 'شاشة LCD ذكية مع ذاكرة لتسجيل القراءات السابقة وسهولة الاستخدام.',
    imagePath: 'assets/images/pharmacy_vitamins.png',
    requiresPrescription: false,
    rating: 4.8,
  ),
  PharmacyItem(
    id: 'ph_4',
    title: 'كريم مرطب ومغذٍ للبشرة الحساسة',
    category: 'عناية وتجميل',
    price: 120.0,
    pharmacyName: 'صيدلية الأمل',
    description: 'تركيبة غنية بحمض الهيالورونيك والزيوت الطبيعية لترطيب يدوم 24 ساعة.',
    imagePath: 'assets/images/cat_pharmacy.png',
    requiresPrescription: false,
    rating: 4.7,
  ),
  PharmacyItem(
    id: 'ph_5',
    title: 'أوجمنتين 1 جرام مضاد حيوي واسع المجال',
    category: 'مضادات حيوية',
    price: 110.0,
    pharmacyName: 'صيدلية الشفاء',
    description: 'أقراص لعلاج التهابات الجاهز التنفسي والأذن والأسنان.',
    imagePath: 'assets/images/pharmacy_vitamins.png',
    requiresPrescription: true,
    rating: 4.9,
  ),
  PharmacyItem(
    id: 'ph_6',
    title: 'أوميز 20 مجم لعلاج حموضة وجرثومة المعدة',
    category: 'أدوية معدة وهضم',
    price: 38.0,
    pharmacyName: 'صيدلية النور والرحمة',
    description: 'كبسولات سريعة المفعول لارتجاع المريء وحماية جدار المعدة.',
    imagePath: 'assets/images/cat_pharmacy.png',
    requiresPrescription: false,
    rating: 4.8,
  ),
  PharmacyItem(
    id: 'ph_7',
    title: 'حفاضات رعاية الأطفال فائقة الامتصاص',
    category: 'رعاية الأطفال',
    price: 280.0,
    pharmacyName: 'صيدلية السلام',
    description: 'حجم مناسب للبشرة الحساسة مع حماية من التسريب طوال الليل.',
    imagePath: 'assets/images/pharmacy_vitamins.png',
    requiresPrescription: false,
    rating: 4.9,
  ),
];
