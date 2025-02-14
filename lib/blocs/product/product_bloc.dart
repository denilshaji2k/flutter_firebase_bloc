import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gapp_bloc/repositories/wishlist_repository.dart';
import '../../repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  final WishlistRepository _wishlistRepository = WishlistRepository();

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadWishlist>(_onLoadWishlist);
    on<AddToWishlist>(_onAddToWishlist);
    on<RemoveFromWishlist>(_onRemoveFromWishlist);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadWishlist(
    LoadWishlist event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final wishlist = await _productRepository.getWishlistProducts(event.userId);
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
  Future<void> _onAddToWishlist(AddToWishlist event, Emitter<ProductState> emit) async {
    try {
      await _wishlistRepository.addToWishlist(event.userId, event.product);
      final wishlist = await _wishlistRepository.getWishlistProducts(event.userId);
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onRemoveFromWishlist(RemoveFromWishlist event, Emitter<ProductState> emit) async {
    try {
      await _wishlistRepository.removeFromWishlist(event.userId, event.productId);
      final wishlist = await _wishlistRepository.getWishlistProducts(event.userId);
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

}
