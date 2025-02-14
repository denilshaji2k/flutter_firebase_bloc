import 'package:equatable/equatable.dart';
import '../../models/cart_item_model.dart';

abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final double total;

  CartLoaded(this.items)
      : total = items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  List<Object> get props => [items, total];
}

class CartError extends CartState {
  final String message;

  CartError(this.message);

  @override
  List<Object> get props => [message];
}
