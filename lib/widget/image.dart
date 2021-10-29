import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:easy_image_viewer/easy_image_viewer.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

class IndexController extends GetxController {
  final RxInt _current = 0.obs;

  int get current => _current.value;

  void changeCurrent(int index) {
    _current.value = index;
    update();
  }
}

class SlideImageView extends StatelessWidget {
  final List<String>? imageUrls;
  final _height = SizeConfig.defaultSize * 20;
  final _margin = SizeConfig.defaultSize * 0.5;
  final _borderRadius = SizeConfig.defaultSize * 1;

  SlideImageView({required this.imageUrls, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageUrls!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  showImageViewer(context,
                      CachedNetworkImageProvider("${imageUrls![index]}"),
                      immersive: false);
                },
                child: Container(
                  height: _height,
                  margin: EdgeInsets.all(_margin),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(_borderRadius)),
                    child: CachedNetworkImage(
                      height: _height,
                      imageUrl: "${imageUrls![index]}",
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.image_not_supported),
                    ),
                  ),
                ));
          },
        ));
  }
}

class CarouselImageView extends StatelessWidget {
  final List<String>? imageUrls;
  final IndexController indexController = IndexController();

  CarouselImageView({required this.imageUrls, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrls != null && imageUrls!.length > 0) {
      return Obx(() => Column(children: [
            CarouselSlider.builder(
                options: CarouselOptions(
                    height: SizeConfig.defaultSize * 20,
                    autoPlay: true,
                    onPageChanged: (index, reason) =>
                        indexController.changeCurrent(index)),
                itemCount: imageUrls!.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: CachedNetworkImage(
                        imageUrl: "${imageUrls![itemIndex]}",
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.image_not_supported),
                      ),
                    ),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageUrls!.asMap().entries.map((entry) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(
                          indexController.current == entry.key ? 0.9 : 0.4)),
                );
              }).toList(),
            )
          ]));
    }

    return Container(
      height: SizeConfig.defaultSize * 10,
      child: Icon(Icons.image_not_supported),
    );
  }
}
