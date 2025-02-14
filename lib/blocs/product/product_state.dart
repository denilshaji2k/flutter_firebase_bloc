import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final Set<String> wishlistIds;

  ProductLoaded(this.products, {Set<String>? wishlistIds}) 
      : wishlistIds = wishlistIds ?? {};

  @override
  List<Object> get props => [products, wishlistIds];

  ProductLoaded copyWith({
    List<ProductModel>? products,
    Set<String>? wishlistIds,
  }) {
    return ProductLoaded(
      products ?? this.products,
      wishlistIds: wishlistIds ?? this.wishlistIds,
    );
  }
}

class WishlistLoaded extends ProductState {
  final List<ProductModel> wishlist;

  WishlistLoaded(this.wishlist);

  @override
  List<Object> get props => [wishlist];
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);

  @override
  List<Object> get props => [message];
}
