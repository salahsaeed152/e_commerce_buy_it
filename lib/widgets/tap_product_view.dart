import 'package:buy_it/models/product_model.dart';
import 'package:buy_it/provider/manage_product_view_model.dart';
import 'package:buy_it/screens/product_info.dart';
import 'package:buy_it/services/fireStore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget tapProductView(String pCategory, List<ProductModel> allProducts, BuildContext context) {
  final _manageProductViewModel = Provider.of<ManageProductViewModel>(context);
  return StreamBuilder<QuerySnapshot>(
    stream: FireStoreServices().getProducts(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<ProductModel> productModel = [];
        for (var doc in snapshot.data.docs) {
          var data = doc.data();
          productModel.add(ProductModel.fromJson(data));
        }
        allProducts = [...productModel];
        productModel.clear();
        productModel = _manageProductViewModel.getProductByCategory(pCategory, allProducts);
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .8,
          ),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProductInfo.id, arguments: productModel[index]);
              },
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(productModel[index].pImageUrl),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Opacity(
                      opacity: .6,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                productModel[index].pName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('\$ ${productModel[index].pPrice}')
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          itemCount: productModel.length,
        );
      } else {
        return Center(child: Text('Loading...'));
      }
    },
  );
}