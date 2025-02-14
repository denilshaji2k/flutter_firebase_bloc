import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class WishlistRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToWishlist(String userId, ProductModel product) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(product.id)
          .set(product.toMap());
    } catch (e) {
      throw Exception('Failed to add ---- $e');
    }
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove-------$e');
    }
  }

  Future<List<ProductModel>> getWishlistProducts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get wishlist-------$e');
    }
  }
}