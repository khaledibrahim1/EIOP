class PropertyItem {
  final String id;
  final String title;
  final String location;
  final double price;
  final String priceUnit; // e.g. "ج.م / شهرياً" or "ج.م كاش"
  final String type; // e.g. "شقة للإيجار", "محل تجاري", "شقة للبيع"
  final double areaSqM;
  final int bedrooms;
  final int bathrooms;
  final String contactPhone;
  final String contactWhatsApp;
  final String imagePath;
  final bool isFeatured;

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
    required this.contactPhone,
    required this.contactWhatsApp,
    required this.imagePath,
    this.isFeatured = false,
  });
}

final List<PropertyItem> sampleProperties = [
  const PropertyItem(
    id: 'prop_1',
    title: 'شقة فاخرة سوبر لوكس بوسط المدينة',
    location: 'شارع المحطة - جرجا',
    price: 3500.0,
    priceUnit: 'ج.م / شهرياً',
    type: 'شقة للإيجار',
    areaSqM: 140,
    bedrooms: 3,
    bathrooms: 2,
    contactPhone: '01012345678',
    contactWhatsApp: '201012345678',
    imagePath: 'assets/images/realestate_apartment.png',
    isFeatured: true,
  ),
  const PropertyItem(
    id: 'prop_2',
    title: 'محل تجاري بموقع حيوي ومميز جداً',
    location: 'الشارع التجاري الرئيسية - جرجا',
    price: 1200000.0,
    priceUnit: 'ج.م كاش',
    type: 'محل للبيع',
    areaSqM: 65,
    bedrooms: 0,
    bathrooms: 1,
    contactPhone: '01123456789',
    contactWhatsApp: '201123456789',
    imagePath: 'assets/images/cat_realestate.png',
    isFeatured: true,
  ),
  const PropertyItem(
    id: 'prop_3',
    title: 'شقة سكنية دور ثالث تشطيب حديث',
    location: 'ميدان النهضة - جرجا',
    price: 680000.0,
    priceUnit: 'ج.م كاش',
    type: 'شقة للبيع',
    areaSqM: 110,
    bedrooms: 2,
    bathrooms: 1,
    contactPhone: '01234567890',
    contactWhatsApp: '201234567890',
    imagePath: 'assets/images/realestate_apartment.png',
  ),
];
