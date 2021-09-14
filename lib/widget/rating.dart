import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RatingController extends GetxController {
  RxInt rating = 5.obs;

  void setRating(int r) {
    rating.value = r;
    update();
  }
}

/// RatingController is required
class StarRating extends StatelessWidget {
  final double size, margin;
  final RatingController controller;

  StarRating(
      {required this.controller, this.size = 40, this.margin = 1, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatingController>(
        init: controller,
        builder: (_) {
          final background =
              _buildRatingBar(controller: _, size: size, margin: margin);
          return Stack(children: [
            background,
            _buildRatingBar(
                count: _.rating.value,
                color: Colors.yellow,
                controller: _,
                size: size,
                margin: margin)
          ]);
        });
  }
}

class StarRatingReadOnly extends StatelessWidget {
  final int count;
  final double size;

  StarRatingReadOnly(this.count, {Key? key, this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _buildRatingBar(size: size),
      _buildRatingBar(count: count, color: Colors.yellow, size: size)
    ]);
  }
}

///
Container _buildRatingBar(
    {int count = 5,
    IconData icon = Icons.star,
    Color color = Colors.grey,
    double size = 40,
    double margin = 1,
    RatingController? controller}) {
  List<Widget> _children = [];

  for (int i = 1; i <= count; i++) {
    Widget _icon = Padding(
      padding: EdgeInsets.all(margin),
      child: Icon(icon, color: color, size: size),
    );

    if (controller != null) {
      _icon = GestureDetector(
        child: _icon,
        onTap: () {
          controller.setRating(i);
        },
      );
    }

    _children.add(_icon);
  }

  return Container(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: _children,
    ),
  );
}
