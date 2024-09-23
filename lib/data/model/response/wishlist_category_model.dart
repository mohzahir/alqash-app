import 'product_model.dart';

class WishListCategoryModel {
  int? id;
  int? userId;
  String? name;
  String? createdAt;
  String? updatedAt;
  List<WishLists>? wishLists;

  WishListCategoryModel({this.id, this.name, this.userId, this.createdAt, this.updatedAt});

  WishListCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['userId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    wishLists = json['wishlists'].map<WishLists>((e)=> WishLists.fromJson(e)).toList();
  }
}

class WishLists {
  int? id;
  int? customerId;
  int? productId;
  int? wishlistCategoryId;
  String? createdAt;
  String? updatedAt;
  Product? product;

  WishLists(
      {this.id,
        this.customerId,
        this.productId,
        this.wishlistCategoryId,
        this.createdAt,
        this.updatedAt,
        this.product});

  WishLists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    productId = json['product_id'];
    wishlistCategoryId = json['wishlist_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['wishlist_product'] == null ? null : Product.fromJson(json['wishlist_product']);
  }
}