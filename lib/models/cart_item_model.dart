class CartItemModel {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;
  final double? discountPrice;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    this.discountPrice,
  });

  double get totalPrice => (discountPrice ?? price) * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'discountPrice': discountPrice,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map, String id) {
    return CartItemModel(
      id: id,
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'] ?? 1,
      discountPrice: map['discountPrice']?.toDouble(),
    );
  }
}
