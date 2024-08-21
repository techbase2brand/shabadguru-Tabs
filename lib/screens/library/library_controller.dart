// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/models/my_playlist_model.dart';
import 'package:shabadguru/network_service/models/popular_raags_model.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/home/home_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/routes.dart';
import 'package:shabadguru/utils/shared_pref.dart';

class LibraryController extends GetxController {
  List<MyPlaylistModel> selectedPlaylistList = [];

  List<MyPlaylistModel>? myPlaylist;
  TextEditingController playlistNameController = TextEditingController();
  HomeController homeController = Get.find<HomeController>();

  List<RaagData> playlistRaagslist = [];
  ShabadRaagModel? shabadRaagModel;

  List<ShabadData> selectedShabadList = [];
  bool isAddMoreShabad = false;

  List<ShabadData> shabadListOfLibrary = [];

  List<ShabadData> myFavoriteList = [];

  RxBool isSearchEnable = false.obs;
  RxBool isRaagSearchEnable = false.obs;
  RxBool isShabadSearchEnable = false.obs;

  String searchValue = '';
  String raagSearchValue = '';
  String shabadSearchValue = '';

  @override
  onInit() {
    super.onInit();
    getMyPlaylistFromLocal();
    getMyFavoriteShabad();
    for (var i = 0; i < homeController.popularRaagsModel!.data!.length; i++) {
      playlistRaagslist.add(homeController.popularRaagsModel!.data![i]);
    }
    for (var i = 0;
        i < homeController.popularRaagsModel!.postRaags!.length;
        i++) {
      playlistRaagslist.add(homeController.popularRaagsModel!.postRaags![i]);
    }
    for (var i = 0;
        i < homeController.popularRaagsModel!.preRaags!.length;
        i++) {
      playlistRaagslist.add(homeController.popularRaagsModel!.preRaags![i]);
    }
    for (var i = 0; i < homeController.popularBannisModel!.data!.length; i++) {
      playlistRaagslist.add(homeController.popularBannisModel!.data![i]);
    }
  }

  Future<void> getMyFavoriteShabad() async {
    myFavoriteList = await SharedPref.getMyFavoriteList();
    update();
    return;
  }

  Future<void> getMyPlaylistFromLocal() async {
    myPlaylist = await SharedPref.getMyPlaylist();
    update();
  }

  Future<void> readJson(String id) async {
    try {
      final String response =
          await rootBundle.loadString('assets/raags_banis/shabad$id.json');
      final data = await json.decode(response);
      shabadRaagModel = ShabadRaagModel.fromJson(data);
      update();
    } catch (e) {
      final String response =
          await rootBundle.loadString('assets/raags_shabad/shabad$id.json');
      final data = await json.decode(response);
      shabadRaagModel = ShabadRaagModel.fromJson(data);
      update();
    }
    if (selectedShabadList.isNotEmpty) {
      for (var i = 0; i < selectedShabadList.length; i++) {
        for (var index = 0; index < shabadRaagModel!.data!.length; index++) {
          if (selectedShabadList[i].audio ==
              shabadRaagModel!.data![index].audio) {
            shabadRaagModel!.data![index].isSelectedForPlaylist = true;
          }
        }
      }
    }
  }

  showNewPlaylistDialog(context, bool isRename,
      MyPlaylistModel? myPlaylistModel, int index, bool isSelectedPlaylist) {
    if (isRename) {
      playlistNameController.text = myPlaylistModel!.playlistName ?? '';
    } else {
      playlistNameController.text = '';
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        return SizedBox(
          child: Center(
            child: FittedBox(
              child: Column(
                children: [
                  Container(
                    width:
                        screenWidth > 600 ? Get.width * 0.50 : Get.width * 0.80,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 3.5,
                          width: 80,
                          decoration: BoxDecoration(
                              color: darkBlueColor,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DefaultTextStyle(
                          style: TextStyle(
                            fontFamily: poppinsBold,
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          child: Text(
                            isRename
                                ? 'Rename playlist'
                                : 'Create new playlist',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            DefaultTextStyle(
                              style: TextStyle(
                                fontFamily: poppinsBold,
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              child: const Text(
                                'Playlist name',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          child: SizedBox(
                            height: 45,
                            child: TextFormField(
                              style: TextStyle(
                                  fontFamily: poppinsRegular,
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              controller: playlistNameController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: darkBlueColor,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    bottom: 10, left: 15, right: 15),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: Get.width,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(darkBlueColor)),
                            onPressed: () async {
                              isAddMoreShabad = false;
                              if (playlistNameController.text.isNotEmpty) {
                                Navigator.of(context).pop();
                                if (isRename) {
                                  myPlaylistModel!.playlistName =
                                      playlistNameController.text;
                                  myPlaylist![index] = myPlaylistModel;
                                  await SharedPref.savePlaylist(myPlaylist!);
                                  selectedShabadList.clear();
                                  getMyPlaylistFromLocal();
                                } else {
                                  if (isSelectedPlaylist) {
                                    savePlaylist(0);
                                  } else {
                                    goToSelectRaagsScreen(context, 0);
                                  }
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Please enter playlist name",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: darkBlueColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            },
                            child: Text(
                              isRename ? 'Rename' : 'Create',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: poppinsBold,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: DefaultTextStyle(
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: poppinsBold,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            child: const Text(
                              'Cancel',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onMenuTaped(context, MyPlaylistModel myPlaylistModel, int index) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        useRootNavigator: false,
        builder: (context) {
          return Container(
            height: 330,
            color: secondPrimaryColor.withOpacity(0),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    isAddMoreShabad = true;
                    selectedShabadList.clear();
                    if (myPlaylistModel.shabadList != null &&
                        myPlaylistModel.shabadList!.isNotEmpty) {
                      selectedShabadList.addAll(myPlaylistModel.shabadList!);
                    }
                    Navigator.of(context).pop();
                    goToSelectRaagsScreen(context, index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    color: secondPrimaryColor.withOpacity(0),
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: secondPrimaryColor,
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Add more shabad',
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
                    showNewPlaylistDialog(
                        context, true, myPlaylistModel, index, false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    color: secondPrimaryColor.withOpacity(0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit,
                          color: secondPrimaryColor,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Rename playlist',
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
                  onTap: () async {
                    myPlaylist!.removeAt(index);
                    await SharedPref.savePlaylist(myPlaylist!);
                    selectedShabadList.clear();
                    getMyPlaylistFromLocal();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    color: secondPrimaryColor.withOpacity(0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete,
                          color: secondPrimaryColor,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Delete playlist',
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
  }

  Future<void> savePlaylist(int indexOfList) async {
    final List<MyPlaylistModel> savedPlaylistList =
        await SharedPref.getMyPlaylist();

    List<ShabadData> listOfShabads = [];

    for (var i = 0; i < selectedShabadList.length; i++) {
      bool isFind = false;
      for (var j = 0; j < listOfShabads.length; j++) {
        if (listOfShabads[j].audio == selectedShabadList[i].audio) {
          isFind = true;
          break;
        } else {
          isFind = false;
        }
      }
      if (!isFind) {
        listOfShabads.add(selectedShabadList[i]);
      }
    }
    if (isAddMoreShabad) {
      MyPlaylistModel myPlaylistModel = MyPlaylistModel(
          shabadList: listOfShabads,
          playlistName: savedPlaylistList[indexOfList].playlistName);
      savedPlaylistList[indexOfList] = myPlaylistModel;
    } else {
      MyPlaylistModel myPlaylistModel = MyPlaylistModel(
          shabadList: listOfShabads, playlistName: playlistNameController.text);
      savedPlaylistList.add(myPlaylistModel);
    }

    await SharedPref.savePlaylist(savedPlaylistList);
    selectedShabadList.clear();
    getMyPlaylistFromLocal();
  }

  Future<void> showPopupForShabadMenu(context, ShabadData shabadData,
      int indexOfLibrary, int indexOfShabad) async {
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
      useRootNavigator: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context1, setState) {
            return Container(
              height: 250,
              color: secondPrimaryColor.withOpacity(0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      bool isFind = false;
                      final myFavoriteList =
                          await SharedPref.getMyFavoriteList();
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
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      color: secondPrimaryColor.withOpacity(0),
                      child: Row(
                        children: [
                          Icon(
                            isFindShabad
                                ? Icons.favorite
                                : Icons.favorite_border,
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
                    onTap: () async {
                      myPlaylist![indexOfLibrary]
                          .shabadList!
                          .removeAt(indexOfShabad);
                      shabadListOfLibrary =
                          myPlaylist![indexOfLibrary].shabadList!;

                      update();
                      Navigator.of(context).pop();
                      await SharedPref.savePlaylist(myPlaylist!);
                      getMyPlaylistFromLocal();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      color: secondPrimaryColor.withOpacity(0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline_outlined,
                            color: secondPrimaryColor,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Remove from playlist',
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
      },
    );
  }

  void onSearch(String value) {
    searchValue = value;
    update();
  }

  void onSearchRaags(String value) {
    raagSearchValue = value;
    update();
  }

  void onSearchShabad(String value) {
    shabadSearchValue = value;
    update();
  }
}
