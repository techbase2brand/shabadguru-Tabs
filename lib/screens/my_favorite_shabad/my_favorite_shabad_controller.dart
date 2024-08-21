// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/shared_pref.dart';

class MyFavoriteShabadController extends GetxController {
  List<ShabadData> myFavoriteShabad = [];

  RxBool isSearchEnable = false.obs;
  String searchValue = '';

  @override
  void onInit() {
    super.onInit();
    getMyFavoriteShabad();
  }

  Future<void> getMyFavoriteShabad() async {
    myFavoriteShabad = await SharedPref.getMyFavoriteList();
    update();
    return;
  }

  void onMenuTapped(ShabadData myFavoriteShabad, context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
         constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
        useRootNavigator: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 180,
              color: secondPrimaryColor.withOpacity(0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final myFavoriteList =
                          await SharedPref.getMyFavoriteList();
                      if (myFavoriteList.isNotEmpty) {
                        for (var i = 0; i < myFavoriteList.length; i++) {
                          if (myFavoriteList[i].audio ==
                              myFavoriteShabad.audio) {
                            myFavoriteList.removeAt(i);
                            break;
                          }
                        }
                      }
                      await SharedPref.saveMyFavoriteList(myFavoriteList);
                      Fluttertoast.showToast(
                        msg: 'Shabad removed from your favorite',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: darkBlueColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      await getMyFavoriteShabad();
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      color: secondPrimaryColor.withOpacity(0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: secondPrimaryColor,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Remove from favorite',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: poppinsBold,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(darkBlueColor)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          });
        });
  }

  void onSearch(String value) {
    searchValue = value;
    update();
  }
}
