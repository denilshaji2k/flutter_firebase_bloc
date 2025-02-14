import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CartItemModel>> getCartItems(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      return snapshot.docs
          .map((doc) => CartItemModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch items');
    }
  }

  Future<void> addToCart(String userId, ProductModel product) async {
    try {
      final cartRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(product.id);

      final doc = await cartRef.get();
      
      if (doc.exists) {
        await cartRef.update({'quantity': FieldValue.increment(1)});
      } else {
        await cartRef.set({
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'quantity': 1,
          'discountPrice': product.discountPrice,
        });
      }
    } catch (e) {
      throw Exception('Failed to add item');
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove item');
    }
  }

  Future<void> updateQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(userId, productId);
      } else {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(productId)
            .update({'quantity': quantity});
      }
    } catch (e) {
      throw Exception('Failed to update');
    }
  }
}
