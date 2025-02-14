import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadWishlist extends ProductEvent {
  final String userId;

  LoadWishlist(this.userId);

  @override
  List<Object> get props => [userId];
}

// class AddToWishlist extends ProductEvent {
//   final String productId;
//   final String userId;

//   AddToWishlist(this.productId, this.userId);

//   @override
//   List<Object> get props => [productId, userId];
// }

class RemoveFromWishlist extends ProductEvent {
  final String userId;
  final String productId;

  RemoveFromWishlist(this.userId, this.productId);

  @override
  List<Object> get props => [userId, productId];
}

class AddToWishlist extends ProductEvent {
  final String userId;
  final dynamic product;

  AddToWishlist(this.userId, this.product);
}