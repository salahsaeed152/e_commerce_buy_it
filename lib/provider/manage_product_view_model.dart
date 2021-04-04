import 'package:buy_it/models/product_model.dart';
import 'package:buy_it/services/fireStore_services.dart';
import 'package:flutter/material.dart';

class ManageProductViewModel extends ChangeNotifier {
  // List<ProductModel> _productModel = [];
  //
  // List<ProductModel> get productModel => _productModel;

  ManageProductViewModel() {
    // getProducts();
  }


  Future<List<ProductModel>>getProducts(List<ProductModel> productModel) async {
     final snapShots =  FireStoreServices().getProducts();
     await for(var snapShot in snapShots){
       print(snapShot.docs.length);
       for(var doc in snapShot.docs){
         var data = doc.data();
         productModel.add(ProductModel.fromJson(data));
       }
     }
     print('you are here');
     return productModel;
  }


  deleteProduct(String pId) async{
    await FireStoreServices().deleteProductFromFireStore(pId);
  }

  List<ProductModel> getProductByCategory(String kCategory, List<ProductModel> allProducts) {
    List<ProductModel> products = [];
    try {
      for (var product in allProducts) {
        if (product.pCategory == kCategory) {
          products.add(product);
        }
      }
    } on Error catch (ex) {
      print(ex);
    }
    return products;
  }


}