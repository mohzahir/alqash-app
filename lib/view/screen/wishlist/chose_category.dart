import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wishlist/favorit_category_save.dart';
import 'package:provider/provider.dart';

import '../../basewidget/show_custom_snakbar.dart';

class ChoseCategory extends StatefulWidget {
  const ChoseCategory({Key? key, required this.productId}) : super(key: key);

  final int productId;

  @override
  State<ChoseCategory> createState() => _ChoseCategoryState();
}

class _ChoseCategoryState extends State<ChoseCategory> {

  String _categoryName = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          " Category which do you want save",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              // controller: _categoryName,
              onChanged: (val){
                _categoryName = val;
              },
              decoration: InputDecoration(
                labelText: "Enter Category name",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              keyboardType: TextInputType.name,
              style: const TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Consumer<WishListProvider>(
                builder: (context, wishListProvider, _) {
                  return wishListProvider.createCategoryLoading ? CircularProgressIndicator() : GestureDetector(
                    onTap: () {
                      if(_categoryName.trim().isNotEmpty) {
                        wishListProvider.createWishListCategory(
                            _categoryName.trim(),
                            feedbackMessage: feedbackMessage);
                      }
                        },

                    child: Container(
                      height: MediaQuery.of(context).size.height / 20,
                      width: MediaQuery.of(context).size.width / 3.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.green),
                      child: const Center(
                        child: Text(
                          'Create',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Consumer<WishListProvider>(
                  builder: (context, wishListProvider, _) {
                return wishListProvider.categoryLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    2, // number of items in each row
                                mainAxisSpacing: 10.0, // spacing between rows
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 3 // spacing between columns
                                ),
                        itemCount:
                            wishListProvider.allWishListCategories != null
                                ? wishListProvider.allWishListCategories!.length
                                : 0,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: ()
                            {
                              wishListProvider.addWishList(
                                  widget.productId,
                                  wishListProvider
                                      .allWishListCategories![index].userId,
                                  wishListProvider
                                      .allWishListCategories![index].id,
                                  feedbackMessage: feedbackMessage);
                            },
                            child: categoryContainer(
                                context,
                                wishListProvider
                                    .allWishListCategories![index].name!),
                          );
                        },
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Container categoryContainer(BuildContext context, String name) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  _loadData(BuildContext context) async {
    Provider.of<WishListProvider>(context, listen: false)
        .getWishListCategories();
  }

  feedbackMessage(String message) {
    if (message != '') {
      showCustomSnackBar(message, context, isError: false);
    }
  }
}
