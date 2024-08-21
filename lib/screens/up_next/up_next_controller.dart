// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/routes.dart';
import 'package:shabadguru/utils/shared_pref.dart';

class UpNextController extends GetxController {
  UpNextController({required this.listOfShabads});

  final List<ShabadData> listOfShabads;

  Future<void> showMenuOptions(
    context,
    ShabadData shabadData,
  ) async {
    final myFavoriteListShabad = await SharedPref.getMyFavoriteList();
    bool isFindShabad = false;
    for (var i = 0; i < myFavoriteListShabad.length; i++) {
      if (myFavoriteListShabad[i].audio == shabadData.audio) {
        isFindShabad = true;
        break;
      }
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
      useRootNavigator: false,
      builder: (context) {
        return Container(
          height: audioHandler != null ? 390 : 260,
          color: secondPrimaryColor.withOpacity(0),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  bool isFind = false;
                  final myFavoriteList = await SharedPref.getMyFavoriteList();
                  if (myFavoriteList.isNotEmpty) {
                    for (var i = 0; i < myFavoriteList.length; i++) {
                      if (myFavoriteList[i].audio == shabadData.audio) {
                        isFind = true;
                        myFavoriteList.removeAt(i);
                        break;
                      }
                    }
                    if (!isFind) {
                      myFavoriteList.add(shabadData);
                    }
                  } else {
                    myFavoriteList.add(shabadData);
                  }
                  await SharedPref.saveMyFavoriteList(myFavoriteList);
                  Fluttertoast.showToast(
                    msg: isFind
                        ? 'Shabad removed from your favorite'
                        : "Shabad added to your favorite",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: darkBlueColor,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: secondPrimaryColor.withOpacity(0),
                  child: Row(
                    children: [
                      Icon(
                        isFindShabad ? Icons.favorite : Icons.favorite_border,
                        color: secondPrimaryColor,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        isFindShabad
                            ? 'Remove from favorite'
                            : 'Add to favorite',
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  goToLibraryPage(context, true, shabadData);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: secondPrimaryColor.withOpacity(0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline_sharp,
                        color: secondPrimaryColor,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Add to playlist',
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
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      },
    );
  }
}
