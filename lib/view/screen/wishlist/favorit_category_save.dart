import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wishlist/favorit_item.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider.dart';
import '../../../provider/wishlist_provider.dart';
import '../../basewidget/not_loggedin_widget.dart';
import '../../basewidget/show_custom_snakbar.dart';
import 'wishlist_screen.dart';

class FavouritCategorySave extends StatefulWidget {
  const FavouritCategorySave({Key? key}) : super(key: key);

  @override
  State<FavouritCategorySave> createState() => _FavouritCategorySaveState();
}

class _FavouritCategorySaveState extends State<FavouritCategorySave> {
  late bool isGuestMode;

  @override
  void initState() {
    super.initState();

    getdata();
  }

  getdata() {
    isGuestMode =
    !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if(!isGuestMode){
      WidgetsBinding.instance.addPostFrameCallback((_){

        Provider.of<WishListProvider>(context, listen: false)
            .getWishListCategories(feedbackMessage: feedbackMessage);

      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          " Category Save",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      body: isGuestMode
          ? const NotLoggedInWidget()
          : Padding(
        padding: const EdgeInsets.all(13.0),
        child: Consumer<WishListProvider>(
            builder: (context, wishListProvider, _) {
          return wishListProvider.categoryLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemCount: wishListProvider.allWishListCategories!.length,
                  // scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const ItemSave(),
                        //     ));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WishListScreen(wishListList: wishListProvider.allWishListCategories![index].wishLists!,),
                            ));
                      },
                      child: Container(
                        // height: MediaQuery.of(context).size.height / 12,
                        // width: MediaQuery.of(context).size.width / 1.1,
                        padding: const EdgeInsets.all(15),
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
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(
                                    0, 2), // changes position of shadow
                              ),
                            ]),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 170,
                              child: Text(
                                wishListProvider.allWishListCategories![index].name!,
                                style: const TextStyle(color: Colors.white, fontSize: 17),
                              ),
                            ),
                            if(wishListProvider.allWishListCategories![index].wishLists!.isNotEmpty)
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: ColorResources.yellow,
                              child: Text(
                                wishListProvider.allWishListCategories![index].wishLists!.length.toString(),
                                style: titilliumSemiBold.copyWith(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 15,
                    );
                  },
                );
        }),
      ),
    );
  }

  feedbackMessage(String message) {
    if (message != '') {
      showCustomSnackBar(message, context, isError: true);
    }
  }
}
