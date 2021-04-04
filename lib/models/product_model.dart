class ProductModel {
  String pName;
  String pPrice;
  String pImageUrl;
  String pDescription;
  String pCategory;
  String pId;
  int pQuantity;

  ProductModel({
    this.pName,
    this.pPrice,
    this.pImageUrl,
    this.pDescription,
    this.pCategory,
    this.pId,
    this.pQuantity = 1,
  });


  ProductModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    pName = map['pName'];
    pPrice = map['pPrice'];
    pImageUrl = map['pImageUrl'];
    pDescription = map['pDescription'];
    pCategory = map['pCategory'];
    pId = map['pId'];
    pQuantity = map['pQuantity'];
  }

  toJson() {
    return {
      'pName': pName,
      'pPrice': pPrice,
      'pImageUrl': pImageUrl,
      'pDescription': pDescription,
      'pCategory': pCategory,
      'pId': pId,
      'pQuantity': pQuantity,
    };
  }

}
