// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shabadguru/screens/home/home_controller.dart';
import 'package:shabadguru/utils/font.dart';

class FeaturedItem extends StatelessWidget {
  const FeaturedItem(
      {super.key, required this.index, required this.featuredModel});

  final int index;
  final FeaturedModel featuredModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          right: 15, top: 15, bottom: 15, left: index == 0 ? 15 : 0),
      child: Column(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.zero,
            elevation: 3,
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                color: index.isEven
                    ? const Color(0XFFA2EEB2)
                    : const Color(0XFFA2DCEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  featuredModel.image,
                  width: 60,
                  height: 60,
                  color: index.isEven
                      ? const Color(0XFF127928)
                      : const Color(0XFF165E74),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            featuredModel.title,
            style: TextStyle(
                fontSize: 15,
                fontFamily: poppinsRegular,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}
