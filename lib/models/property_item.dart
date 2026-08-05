class PropertyReview {
  final String authorName;
  final String authorRole;
  final double rating;
  final String comment;
  final String avatarPath;

  const PropertyReview({
    required this.authorName,
    required this.authorRole,
    required this.rating,
    required this.comment,
    required this.avatarPath,
  });
}

class PropertyFacility {
  final String name;
  final String iconName; // e.g. 'temple', 'train', 'restaurant', 'school', 'bus', 'hospital'

  const PropertyFacility({required this.name, required this.iconName});
}

class PropertyItem {
  final String id;
  final String title;
  final String location;
  final double price;
  final String priceUnit; // e.g. "ج.م / شهرياً" or "ج.م كاش"
  final String type; // e.g. "شقة للإيجار", "محل تجاري", "شقة للبيع", "فيلا"
  final double areaSqM;
  final int bedrooms;
  final int bathrooms;
  final int livingRooms;
  final int parkingSpaces;
  final int builtYear;
  final double rating;
  final int reviewsCount;
  final String description;
  final String contactPhone;
  final String contactWhatsApp;
  final String imagePath;
  final List<String> galleryPhotos;
  final bool isFeatured;
  final String agentName;
  final String agentRole;
  final String agentAvatar;
  final List<PropertyFacility> facilities;
  final List<PropertyReview> reviews;

  const PropertyItem({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.priceUnit,
    required this.type,
    required this.areaSqM,
    required this.bedrooms,
    required this.bathrooms,
    this.livingRooms = 2,
    this.parkingSpaces = 1,
    this.builtYear = 2023,
    this.rating = 4.8,
    this.reviewsCount = 120,
    this.description =
        'شقة كلاسيكية فاخرة بإطلالة ممتازة وتشطيب سوبر لوكس حديث بقلب مدينة جرجا. تتميز بالتهوية الجيدة والإضاءة الطبيعية مع قربها من كافة المراكز والخدمات الأساسية.',
    required this.contactPhone,
    required this.contactWhatsApp,
    required this.imagePath,
    this.galleryPhotos = const [
      'assets/images/realestate_apartment.png',
      'assets/images/cat_realestate.png',
      'assets/images/realestate_apartment.png',
    ],
    this.isFeatured = false,
    this.agentName = 'أحمد المحمدي',
    this.agentRole = 'مستشار عقاري معتمد',
    this.agentAvatar = 'assets/images/delivery_rider.png',
    this.facilities = const [
      PropertyFacility(name: 'مسجد', iconName: 'mosque'),
      PropertyFacility(name: 'محطة قطار', iconName: 'train'),
      PropertyFacility(name: 'مطاعم', iconName: 'restaurant'),
      PropertyFacility(name: 'مدارس', iconName: 'school'),
      PropertyFacility(name: 'موقف باصات', iconName: 'bus'),
      PropertyFacility(name: 'مستشفى', iconName: 'hospital'),
    ],
    this.reviews = const [
      PropertyReview(
        authorName: 'سامح محمود',
        authorRole: 'مهندس برمجيات',
        rating: 5.0,
        comment: 'المكان ممتاز جداً والتجميع في الموقع سريع وصادق بدون أي عمولات خفية.',
        avatarPath: 'assets/images/delivery_rider.png',
      ),
      PropertyReview(
        authorName: 'رجب العبد',
        authorRole: 'محاسب قانوني',
        rating: 4.5,
        comment: 'موقع حيوي ممتاز والمالك متعاون جداً. تجربة سكن رائعة.',
        avatarPath: 'assets/images/delivery_rider.png',
      ),
    ],
  });
}

final List<PropertyItem> sampleProperties = [
  const PropertyItem(
    id: 'prop_1',
    title: 'Park Avenue Luxury Apartment',
    location: 'شارع المحطة - جرجا، سوهاج',
    price: 3500.0,
    priceUnit: 'ج.م / شهرياً',
    type: 'شقة للإيجار',
    areaSqM: 140,
    bedrooms: 3,
    bathrooms: 2,
    livingRooms: 2,
    parkingSpaces: 2,
    builtYear: 2023,
    rating: 4.8,
    reviewsCount: 124,
    description:
        'شقة كلاسيكية فاخرة سوبر لوكس تتكون من 3 غرف نوم وصالتين واسعتين، تشطيب هاي لوكس جاهزة للسكن الفوري بالدور الثالث بأسنسير وموقع مميز بجرجا.',
    contactPhone: '01012345678',
    contactWhatsApp: '201012345678',
    imagePath: 'assets/images/realestate_apartment.png',
    galleryPhotos: [
      'assets/images/realestate_apartment.png',
      'assets/images/cat_realestate.png',
      'assets/images/realestate_apartment.png',
    ],
    isFeatured: true,
    agentName: 'أماني الديب',
    agentRole: 'مستشارة عقارات إيجار',
  ),
  const PropertyItem(
    id: 'prop_2',
    title: 'Max Commercial Prime Shop',
    location: 'الشارع التجاري الرئيسي - جرجا',
    price: 1200000.0,
    priceUnit: 'ج.م كاش',
    type: 'محل للبيع',
    areaSqM: 65,
    bedrooms: 0,
    bathrooms: 1,
    livingRooms: 0,
    parkingSpaces: 1,
    builtYear: 2022,
    rating: 4.9,
    reviewsCount: 88,
    description:
        'محل تجاري ذو واجهة زجاجية عريضة بموقع حيوي أعلى كثافة شرائية بالشارع التجاري بجرجا، يصلح لكافة الأنشطة التجاري (صيدلية، ملابس، مطعم).',
    contactPhone: '01123456789',
    contactWhatsApp: '201123456789',
    imagePath: 'assets/images/cat_realestate.png',
    galleryPhotos: [
      'assets/images/cat_realestate.png',
      'assets/images/realestate_apartment.png',
    ],
    isFeatured: true,
    agentName: 'أحمد المحمدي',
    agentRole: 'خبير مبيعات ومحلات',
  ),
  const PropertyItem(
    id: 'prop_3',
    title: 'Modern Deluxe Residence',
    location: 'ميدان النهضة - جرجا، سوهاج',
    price: 680000.0,
    priceUnit: 'ج.م كاش',
    type: 'شقة للبيع',
    areaSqM: 110,
    bedrooms: 2,
    bathrooms: 1,
    livingRooms: 1,
    parkingSpaces: 1,
    builtYear: 2021,
    rating: 4.7,
    reviewsCount: 52,
    description:
        'شقة سكنية عصرية تشطيب حديث كاملة الخدمات (مياه، كهرباء، غاز) بميدان النهضة بالقرب من المستشفى العام ومحطة القطار.',
    contactPhone: '01234567890',
    contactWhatsApp: '201234567890',
    imagePath: 'assets/images/realestate_apartment.png',
    galleryPhotos: [
      'assets/images/realestate_apartment.png',
      'assets/images/cat_realestate.png',
    ],
    isFeatured: false,
    agentName: 'خالد إبراهيم',
    agentRole: 'مطور ومستشار عقاري',
  ),
  const PropertyItem(
    id: 'prop_4',
    title: 'Executive Office Suite',
    location: 'شارع الجمهورية - جرجا',
    price: 4500.0,
    priceUnit: 'ج.م / شهرياً',
    type: 'مكتب للإيجار',
    areaSqM: 90,
    bedrooms: 2,
    bathrooms: 1,
    livingRooms: 1,
    parkingSpaces: 1,
    builtYear: 2023,
    rating: 4.9,
    reviewsCount: 64,
    description:
        'مكتب إداري فاخر مجهز بأحدث التمديدات والشبكات للشركات والعيادات والمكاتب الاستشارية بوسط مدينة جرجا.',
    contactPhone: '01098765432',
    contactWhatsApp: '201098765432',
    imagePath: 'assets/images/cat_realestate.png',
    galleryPhotos: [
      'assets/images/cat_realestate.png',
      'assets/images/realestate_apartment.png',
    ],
    isFeatured: true,
    agentName: 'مصطفى حسين',
    agentRole: 'مستشار مكاتب إدارية',
  ),
];

