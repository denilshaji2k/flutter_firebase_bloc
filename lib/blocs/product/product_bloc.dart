import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gapp_bloc/repositories/wishlist_repository.dart';
import '../auth/auth_bloc.dart';
import '../../repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  final WishlistRepository _wishlistRepository = WishlistRepository();
  final AuthBloc _authBloc;

  ProductBloc({
    required ProductRepository productRepository,
    required AuthBloc authBloc,
  })  : _productRepository = productRepository,
        _authBloc = authBloc,
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
      Set<String> wishlistIds = {};
      
      final authState = _authBloc.state;
      if (authState is AuthSuccess) {
        final wishlistProducts = await _wishlistRepository.getWishlistProducts(authState.user.id);
        wishlistIds = wishlistProducts.map((p) => p.id).toSet();
      }
      
      emit(ProductLoaded(products, wishlistIds: wishlistIds));
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
      
      if (state is ProductLoaded) {
        final currentState = state as ProductLoaded;
        emit(currentState.copyWith(
          wishlistIds: {...currentState.wishlistIds, event.product.id},
        ));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onRemoveFromWishlist(RemoveFromWishlist event, Emitter<ProductState> emit) async {
    try {
      await _wishlistRepository.removeFromWishlist(event.userId, event.productId);
      
      if (state is ProductLoaded) {
        final currentState = state as ProductLoaded;
        final newWishlistIds = Set<String>.from(currentState.wishlistIds)
          ..remove(event.productId);
        emit(currentState.copyWith(wishlistIds: newWishlistIds));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

}
