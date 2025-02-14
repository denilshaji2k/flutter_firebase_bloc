import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc({required CartRepository cartRepository})
      : _cartRepository = cartRepository,
        super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateQuantity);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await _cartRepository.getCartItems(event.userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.addToCart(event.userId, event.product);
      final items = await _cartRepository.getCartItems(event.userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.removeFromCart(event.userId, event.productId);
      final items = await _cartRepository.getCartItems(event.userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
      UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.updateQuantity(
          event.userId, event.productId, event.quantity);
      final items = await _cartRepository.getCartItems(event.userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
