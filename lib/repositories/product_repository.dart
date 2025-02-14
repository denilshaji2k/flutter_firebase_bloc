import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('unable to fetch prod');
    }
  }

  Future<List<ProductModel>> getWishlistProducts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .get();
      
      List<ProductModel> wishlistProducts = [];
      for (var doc in snapshot.docs) {
        final productDoc = await _firestore
            .collection('products')
            .doc(doc.id)
            .get();
        if (productDoc.exists) {
          wishlistProducts.add(
              ProductModel.fromMap(productDoc.data()!, productDoc.id));
        }
      }
      return wishlistProducts;
    } catch (e) {
      throw Exception('unable to fetch');
    }
  }
}
