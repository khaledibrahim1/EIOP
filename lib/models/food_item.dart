class FoodOption {
  final String id;
  final String title;
  final String? code; // e.g. 'S', 'M', 'L', 'XL'
  final double priceOffset;
  final String? imagePath;

  const FoodOption({
    required this.id,
    required this.title,
    this.code,
    this.priceOffset = 0.0,
    this.imagePath,
  });
}

class FoodItem {
  final String id;
  final String title;
  final String restaurantId;
  final String restaurant;
  final double price;
  final double rating;
  final String deliveryTime;
  final String description;
  final String imagePath;
  final List<String> images;
  final List<FoodOption> options;
  final String categoryId;
  final bool isPopular;

  const FoodItem({
    required this.id,
    required this.title,
    required this.restaurantId,
    required this.restaurant,
    required this.price,
    required this.rating,
    required this.deliveryTime,
    required this.description,
    required this.imagePath,
    this.images = const [],
    this.options = const [],
    required this.categoryId,
    this.isPopular = false,
  });

  List<String> get allImages => images.isNotEmpty ? images : [imagePath];
}

