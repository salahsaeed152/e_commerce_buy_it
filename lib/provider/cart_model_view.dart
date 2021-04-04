import 'package:buy_it/models/product_model.dart';
import 'package:buy_it/services/fireStore_services.dart';
import 'package:flutter/material.dart';

class CartModelView extends ChangeNotifier {
  List<ProductModel> products = [];

  addProduct(ProductModel product) {
    products.add(product);
    notifyListeners();
  }

  deleteProduct(ProductModel product) {
    products.remove(product);
    notifyListeners();
  }

  getTotalPrice(List<ProductModel> products) {
    var price = 0;
    for (var product in products) {
      price += product.pQuantity * int.parse(product.pPrice);
    }
    return price;
  }


  Future<void>storeOrders(data, List<ProductModel> products) async{
    await FireStoreServices().storeOrders(data, products);
    products.clear();
  }




}