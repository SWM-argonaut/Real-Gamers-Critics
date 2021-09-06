import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:soma_app_usage/configs/size_config.dart';

import 'package:soma_app_usage/widget/rating.dart';

class Comment extends StatelessWidget {
  const Comment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Radius radius = Radius.circular(SizeConfig.defaultSize * 3);

    final TextEditingController shortCommentCtrl = TextEditingController();
    final TextEditingController longCommentCtrl = TextEditingController();
    final RatingController ratingController = RatingController();

    int _rating = 0;
    String _shortComment = "";
    String _comment = "";

    return Container(
      height: SizeConfig.screenHeight * 0.73,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(child: Text("before review".tr)),
          StarRating(
            controller: ratingController,
            size: SizeConfig.defaultSize * 4,
            margin: SizeConfig.defaultSize * 1,
          ),
          // Obx(() => Text("rate : ${ratingController.rating}")),
          Container(
              margin: EdgeInsets.all(SizeConfig.defaultSize * 3),
              child: TextField(
                controller: shortCommentCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "short comment".tr,
                ),
              )),

          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: SizeConfig.defaultSize * 2,
                bottom: SizeConfig.defaultSize),
            child: Text("comment more info".tr),
          ),
          Container(
              margin:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 3),
              child: TextField(
                maxLines: 6,
                controller: longCommentCtrl,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "long comment".tr,
                  hintMaxLines: 4,
                ),
              )),
          Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.all(SizeConfig.defaultSize * 3),
              child: ElevatedButton(
                onPressed: () {
                  log("rating: ${ratingController.rating}\nshort: ${shortCommentCtrl.text}\nlong: ${longCommentCtrl.text}");
                  Get.back();
                },
                child: Text("send comment".tr),
              ))
        ],
      ),
    );
  }
}
