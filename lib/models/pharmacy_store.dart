class PharmacyStore {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewsCount;
  final String deliveryTime;
  final double deliveryFee;
  final String coverImagePath;
  final String logoPath;
  final bool isOpen;
  final bool is24Hours;
  final String phone;

  const PharmacyStore({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.coverImagePath,
    required this.logoPath,
    this.isOpen = true,
    this.is24Hours = true,
    required this.phone,
  });
}

final List<PharmacyStore> samplePharmacyStores = const [
  PharmacyStore(
    id: 'pharm_1',
    name: 'صيدلية الشفاء د. أحمد علي',
    address: 'شارع المحطة - جرجا',
    rating: 4.9,
    reviewsCount: 230,
    deliveryTime: '15-25 دقيقة',
    deliveryFee: 10.0,
    coverImagePath: 'assets/images/pharmacy_vitamins.png',
    logoPath: 'assets/images/pharmacy_vitamins.png',
    isOpen: true,
    is24Hours: true,
    phone: '01012345678',
  ),
  PharmacyStore(
    id: 'pharm_2',
    name: 'صيدلية النور والرحمة',
    address: 'ميدان النهضة - الشارع التجاري',
    rating: 4.8,
    reviewsCount: 185,
    deliveryTime: '15-20 دقيقة',
    deliveryFee: 8.0,
    coverImagePath: 'assets/images/cat_pharmacy.png',
    logoPath: 'assets/images/cat_pharmacy.png',
    isOpen: true,
    is24Hours: true,
    phone: '01123456789',
  ),
  PharmacyStore(
    id: 'pharm_3',
    name: 'صيدلية السلام والأهرام',
    address: 'شارع الأهرام - بجوار البنك الأهلي',
    rating: 4.7,
    reviewsCount: 140,
    deliveryTime: '20-30 دقيقة',
    deliveryFee: 12.0,
    coverImagePath: 'assets/images/pharmacy_vitamins.png',
    logoPath: 'assets/images/pharmacy_vitamins.png',
    isOpen: true,
    is24Hours: false,
    phone: '01234567890',
  ),
  PharmacyStore(
    id: 'pharm_4',
    name: 'صيدلية الأمل للرعاية الصحية',
    address: 'طريق الكورنيش - جرجا',
    rating: 4.9,
    reviewsCount: 310,
    deliveryTime: '15-25 دقيقة',
    deliveryFee: 10.0,
    coverImagePath: 'assets/images/cat_pharmacy.png',
    logoPath: 'assets/images/cat_pharmacy.png',
    isOpen: true,
    is24Hours: true,
    phone: '01512345678',
  ),
];
