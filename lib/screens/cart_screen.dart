import 'package:buy_it/constants.dart';
import 'package:buy_it/models/product_model.dart';
import 'package:buy_it/provider/cart_model_view.dart';
import 'package:buy_it/screens/product_info.dart';
import 'package:buy_it/widgets/custom_popUp_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static String id = 'CartScreen';

  @override
  Widget build(BuildContext context) {
    List<ProductModel> products = Provider.of<CartModelView>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            LayoutBuilder(builder: (context, constrains) {
              if (products.isNotEmpty) {
                return Container(
                  height: screenHeight -
                      statusBarHeight -
                      appBarHeight -
                      (screenHeight * .08),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: GestureDetector(
                          onTapUp: (details) {
                            showCustomMenu(details, context, products[index]);
                          },
                          child: Container(
                            height: screenHeight * .15,
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: screenHeight * .15 / 2,
                                  backgroundImage:
                                      NetworkImage(products[index].pImageUrl),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              products[index].pName,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '\$ ${products[index].pPrice}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Text(
                                          products[index].pQuantity == 1
                                              ? '${products[index].pQuantity.toString()} piece'
                                              : '${products[index].pQuantity.toString()} pieces',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            color: kSecondaryColor,
                          ),
                        ),
                      );
                    },
                    itemCount: products.length,
                  ),
                );
              } else {
                return Container(
                  height: screenHeight -
                      (screenHeight * .08) -
                      appBarHeight -
                      statusBarHeight,
                  child: Center(
                    child: Text('Cart is Empty'),
                  ),
                );
              }
            }),
            Builder(
              builder: (context) => ButtonTheme(
                minWidth: screenWidth,
                height: screenHeight * .08,
                child: ElevatedButton(
                  onPressed: () {
                    if (products.isNotEmpty) {
                      showCustomDialog(products, context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No items in your orders list'),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        // side: BorderSide(color: kMainColor),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kMainColor),

                    // color: kMainColor,
                  ),
                  child: Text(
                    'Order'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomMenu(details, context, product) async {
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    double dx2 = MediaQuery.of(context).size.width - dx;
    double dy2 = MediaQuery.of(context).size.width - dy;
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
        items: [
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              Provider.of<CartModelView>(context, listen: false)
                  .deleteProduct(product);
              Navigator.pushNamed(context, ProductInfo.id, arguments: product);
            },
            child: Text('Edit'),
          ),
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              Provider.of<CartModelView>(context, listen: false)
                  .deleteProduct(product);
            },
            child: Text('Delete'),
          ),
        ]);
  }

  void showCustomDialog(List<ProductModel> products, context) async {
    final _cartModelView = Provider.of<CartModelView>(context, listen: false);
    var price = _cartModelView.getTotalPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      actions: <Widget>[
        MaterialButton(
          onPressed: () async {
            try {
              await _cartModelView.storeOrders(
                  {kTotalPrice: price, kAddress: address}, products);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Ordered Successfully'),
              ));
              Navigator.pop(context);
            } catch (ex) {
              print(ex.message);
            }
          },
          child: Text('Confirm'),
        )
      ],
      content: TextField(
        onChanged: (value) {
          address = value;
        },
        decoration: InputDecoration(hintText: 'Enter your Address'),
      ),
      title: Text('Total Price  = \$ $price'),
    );
    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }
}
