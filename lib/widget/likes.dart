import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:real_gamers_critics/functions/format/number.dart';

class LikeController extends GetxController {
  RxBool isOn = false.obs;
  RxInt count = 0.obs;

  void set(bool b, int? i) {
    isOn.value = b;
    count.value = i ?? 0;
    update();
  }

  void setOn() {
    isOn.value = true;
    count.value++;
    update();
  }

  void setOff() {
    isOn.value = false;
    count.value--;
    update();
  }
}

class Likes extends StatelessWidget {
  final LikeController controller = LikeController();
  final Function? on, off;
  final int? count;

  Likes({isOn = false, this.on, this.off, this.count, Key? key})
      : super(key: key) {
    controller.set(isOn, count);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LikeController>(
      init: controller,
      builder: (_) {
        List<Widget> _widgets = [
          IconButton(
              icon: Icon(Icons.thumb_up,
                  color: _.isOn.value ? Colors.blue : Colors.black),
              onPressed: () {
                if (_.isOn.value) {
                  _.setOff();
                  if (off != null) {
                    off!();
                  }
                } else {
                  _.setOn();
                  if (on != null) {
                    on!();
                  }
                }
              }),
        ];

        if (count != null) {
          _widgets.add(Text("${formatedNumber(_.count.value)}"));
        }

        return Row(children: _widgets);
      },
    );
  }
}
