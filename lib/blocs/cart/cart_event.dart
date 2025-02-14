import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {
  final String userId;
  LoadCart(this.userId);
  @override
  List<Object> get props => [userId];
}

class AddToCart extends CartEvent {
  final String userId;
  final ProductModel product;
  AddToCart(this.userId, this.product);
  @override
  List<Object> get props => [userId, product];
}

class RemoveFromCart extends CartEvent {
  final String userId;
  final String productId;
  RemoveFromCart(this.userId, this.productId);
  @override
  List<Object> get props => [userId, productId];
}

class UpdateCartItemQuantity extends CartEvent {
  final String userId;
  final String productId;
  final int quantity;
  UpdateCartItemQuantity(this.userId, this.productId, this.quantity);
  @override
  List<Object> get props => [userId, productId, quantity];
}
