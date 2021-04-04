import 'package:buy_it/constants.dart';
import 'package:buy_it/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices{
  final CollectionReference _productCollectionReference =
  FirebaseFirestore.instance.collection('Products');
  final CollectionReference _ordersCollectionReference =
  FirebaseFirestore.instance.collection(kOrders);

  Future<void> addProductToFireStore(ProductModel productModel) async {
    return await _productCollectionReference
        .doc(productModel.pId)
        .set(productModel.toJson());
  }

  Stream<QuerySnapshot> getProducts() {
    return _productCollectionReference.snapshots();
  }

  Future<void> deleteProductFromFireStore(String pId) async {
    return await _productCollectionReference.doc(pId).delete();
  }

  Future<void> updateProductFromFireStore(data, String pId) async {
    return await _productCollectionReference.doc(pId).update(data);
  }

  Future<void> storeOrders(data, List<ProductModel> products) async {
    var _orderReference =  await _ordersCollectionReference.doc();
    _orderReference.set(data);
    for (var product in products) {
      _orderReference.collection(kOrderDetails).doc().set(product.toJson());
    }
  }


}