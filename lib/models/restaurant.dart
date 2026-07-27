class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final int reviewsCount;
  final String deliveryTime;
  final double deliveryFee;
  final String coverImagePath;
  final String logoPath;
  final String address;
  final bool isOpen;
  final String phone;
  final String categoryId;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.coverImagePath,
    required this.logoPath,
    required this.address,
    this.isOpen = true,
    this.phone = '01000000000',
    this.categoryId = 'grill',
  });
}
