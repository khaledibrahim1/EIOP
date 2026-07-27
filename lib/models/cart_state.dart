import 'package:flutter/foundation.dart';
import 'food_item.dart';

class CartItemModel {
  final FoodItem food;
  final FoodOption? selectedOption;
  int quantity;

  CartItemModel({
    required this.food,
    this.selectedOption,
    this.quantity = 1,
  });

  double get unitPrice => food.price + (selectedOption?.priceOffset ?? 0.0);
  double get totalPrice => unitPrice * quantity;
}

class ActiveOrderModel {
  final String orderId;
  final String areaName;
  final String addressDetails;
  final String phoneNumber;
  final double totalAmount;
  final List<CartItemModel> items;
  String status; // 'preparing', 'on_the_way', 'delivered'
  final String captainName;
  final String captainPhone;
  final DateTime orderTime;

  ActiveOrderModel({
    required this.orderId,
    required this.areaName,
    required this.addressDetails,
    required this.phoneNumber,
    required this.totalAmount,
    required this.items,
    this.status = 'on_the_way',
    this.captainName = 'كابتن محمود السوهاجي',
    this.captainPhone = '01098765432',
    required this.orderTime,
  });
}

class AppStateNotifier extends ChangeNotifier {
  final List<CartItemModel> _cartItems = [];
  final Set<String> _favoriteIds = {'1'};
  bool _isDarkMode = false;
  ActiveOrderModel? _activeOrder;

  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);
  Set<String> get favoriteIds => _favoriteIds;
  bool get isDarkMode => _isDarkMode;
  ActiveOrderModel? get activeOrder => _activeOrder;
  bool get hasActiveOrder => _activeOrder != null;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  int get totalItemCount {
    int total = 0;
    for (var item in _cartItems) {
      total += item.quantity;
    }
    return total;
  }

  double get grandTotal {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  bool isFavorite(String foodId) => _favoriteIds.contains(foodId);

  void toggleFavorite(String foodId) {
    if (_favoriteIds.contains(foodId)) {
      _favoriteIds.remove(foodId);
    } else {
      _favoriteIds.add(foodId);
    }
    notifyListeners();
  }

  void addToCart(FoodItem item, {FoodOption? selectedOption, int quantity = 1}) {
    final index = _cartItems.indexWhere((element) =>
        element.food.id == item.id &&
        element.selectedOption?.id == selectedOption?.id);
    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItemModel(
        food: item,
        selectedOption: selectedOption,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(String foodId, int quantity) {
    final index = _cartItems.indexWhere((element) => element.food.id == foodId);
    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void placeOrder({
    required String areaName,
    required String addressDetails,
    required String phoneNumber,
  }) {
    if (_cartItems.isEmpty) return;

    _activeOrder = ActiveOrderModel(
      orderId: 'GF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      areaName: areaName,
      addressDetails: addressDetails,
      phoneNumber: phoneNumber,
      totalAmount: grandTotal,
      items: List.from(_cartItems),
      orderTime: DateTime.now(),
    );

    _cartItems.clear();
    notifyListeners();
  }

  void placeParcelOrder({
    required String pickup,
    required String dropoff,
    required String category,
    required double fee,
  }) {
    _activeOrder = ActiveOrderModel(
      orderId: 'EXP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      areaName: 'مرسول: $category',
      addressDetails: 'من: $pickup | إلى: $dropoff',
      phoneNumber: 'طلب خاص',
      totalAmount: fee,
      items: [],
      orderTime: DateTime.now(),
    );
    notifyListeners();
  }

  void completeActiveOrder() {
    _activeOrder = null;
    notifyListeners();
  }
}

// Global Singleton Provider Accessor
final appState = AppStateNotifier();
