import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/wishlist_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/product_details_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/wishlist_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

import '../data/model/response/wishlist_category_model.dart';

class WishListProvider extends ChangeNotifier {
  final WishListRepo? wishListRepo;
  final ProductDetailsRepo? productDetailsRepo;
  WishListProvider({required this.wishListRepo, required this.productDetailsRepo});

  bool _wish = false;
  String _searchText = "";
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _wishList_by_categoryLoading = false;
  bool get wishList_by_categoryLoading => _wishList_by_categoryLoading;

  bool get isWish => _wish;
  String get searchText => _searchText;

  bool _categoryLoading = false;
  bool get categoryLoading => _categoryLoading;

  bool _createCategoryLoading = false;
  bool get createCategoryLoading => _createCategoryLoading;

  clearSearchText() {
    _searchText = '';
    notifyListeners();
  }

  List<Product>? _wishList;
  List<Product>? _allWishList;

  List<Product>? get wishList => _wishList;
  List<Product>? get allWishList => _allWishList;

  List<WishListCategoryModel>? _allWishListCategories = [];
  List<WishListCategoryModel>? get allWishListCategories => _allWishListCategories;

  void searchWishList(String query) async {
    _wishList = [];
    _searchText = query;

    if (query.isNotEmpty) {
      List<Product> products = _allWishList!.where((product) {
        return product.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      _wishList!.addAll(products);
    } else {
      _wishList!.addAll(_allWishList!);
    }
    notifyListeners();
  }

  void addWishList(int? productID, int? customerId, int? categoryID, {Function? feedbackMessage}) async {
    ApiResponse apiResponse = await wishListRepo!.addWishList(productID, customerId, categoryID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      feedbackMessage!(message);
      _wish = true;
      notifyListeners();
    } else {
      // _wish = false;
      feedbackMessage!(apiResponse.error.toString());
    }
    notifyListeners();
  }

  void createWishListCategory(String name, {Function? feedbackMessage}) async {
    _createCategoryLoading = true;
    notifyListeners();

    try{
      ApiResponse apiResponse =
          await wishListRepo!.createWishListCategory(name);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        Map map = apiResponse.response!.data;
        String? message = map['message'];
        feedbackMessage!(message);

        _createCategoryLoading = false;
      } else {
        feedbackMessage!(apiResponse.error.toString());
        _createCategoryLoading = false;
      }
      notifyListeners();
    }catch(e){
      print(e);
      _createCategoryLoading = false;
      notifyListeners();
    }
  }

  void getWishListCategories({Function? feedbackMessage}) async {
    _categoryLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await wishListRepo!.getWishListCategories();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      print('..................');
      print(apiResponse.response!.data);

      final jsonResponse = apiResponse.response!.data['data'];

      _allWishListCategories = jsonResponse.map<WishListCategoryModel>((e)=> WishListCategoryModel.fromJson(e)).toList();
      print('..................');

      _categoryLoading = false;
      notifyListeners();
    } else {
      feedbackMessage!(apiResponse.error.toString());

      _categoryLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  void removeWishList(int? productID, {int? index, Function? feedbackMessage}) async {
    ApiResponse apiResponse = await wishListRepo!.removeWishList(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      if(feedbackMessage != null) {
        feedbackMessage(message);
      }
      if (index != null) {
        _wishList!.removeAt(index);
        _allWishList!.removeAt(index);
        notifyListeners();
      }
    } else {
      if (kDebugMode) {
        print(apiResponse.error.toString());
      }
      feedbackMessage!(apiResponse.error.toString());
    }
    _wish = false;
    notifyListeners();
  }

  Future<void> initWishList(BuildContext context, String? languageCode) async {
    _isLoading = true;
    notifyListeners();

    try{
      ApiResponse apiResponse = await wishListRepo!.getWishList();

      print('....................=============...........');
      print(apiResponse.response!.data);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _wishList = [];
        _allWishList = [];
        for (int i = 0; i < apiResponse.response!.data.length; i++) {
          ApiResponse productResponse = await productDetailsRepo!.getProduct(
            WishListModel.fromJson(apiResponse.response!.data[i])
                .product!
                .slug
                .toString(),
          );
          if (productResponse.response != null &&
              productResponse.response!.statusCode == 200) {
            Product product = Product.fromJson(productResponse.response!.data);
            _wishList!.add(product);
            _allWishList!.add(product);
            notifyListeners();
          } else {
            ApiChecker.checkApi(productResponse);
          }
        }
        if (apiResponse.response!.data.length > 0) {
          notifyListeners();
        }
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        ApiChecker.checkApi(apiResponse);
      }
    }catch(e){
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getWishListByCategory(BuildContext context, List<WishLists> wishListsList) async {
    _wishList_by_categoryLoading = true;
    notifyListeners();

    try{
      ApiResponse apiResponse = await wishListRepo!.getWishList();

      print('....................=============...........');
      print(apiResponse.response!.data);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _wishList = [];
        _allWishList = [];
        for (int i = 0; i < wishListsList.length; i++) {
          ApiResponse productResponse = await productDetailsRepo!.getProduct(
            WishListModel.fromJson(apiResponse.response!.data[i])
                .product!
                .slug
                .toString(),
          );
          if (productResponse.response != null &&
              productResponse.response!.statusCode == 200) {
            Product product = Product.fromJson(productResponse.response!.data);
            _wishList!.add(product);
            _allWishList!.add(product);
            notifyListeners();
          } else {
            ApiChecker.checkApi(productResponse);
          }
        }
        if (apiResponse.response!.data.length > 0) {
          notifyListeners();
        }
        _wishList_by_categoryLoading = false;
        notifyListeners();
      } else {
        _wishList_by_categoryLoading = false;
        notifyListeners();
        ApiChecker.checkApi(apiResponse);
      }
    }catch(e){
      print(e);
      _wishList_by_categoryLoading = false;
      notifyListeners();
    }
  }

  void checkWishList(String productId, BuildContext context) async {
    ApiResponse apiResponse = await wishListRepo!.getWishList();
    List<String> productIdList = [];
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _wishList = [];
      apiResponse.response!.data.forEach((wishList) async {
        WishListModel wishListModel = WishListModel.fromJson(wishList);
        productIdList.add(wishListModel.productId.toString());
      });
      productIdList.contains(productId) ? _wish = true : _wish = false;
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }
}
