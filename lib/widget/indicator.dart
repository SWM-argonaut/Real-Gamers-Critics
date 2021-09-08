import 'package:flutter/material.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

/// 0 <= percent <= 1
class LinearIndicator extends StatelessWidget {
  final double width;
  final double height;
  final double percent;
  final String? text;
  final Color color, backgroundColor;

  LinearIndicator({
    required percent,
    this.width = 100,
    this.height = 20,
    this.color = Colors.green,
    this.backgroundColor = Colors.black26,
    this.text,
    Key? key,
  })  : this.percent = percent > 1.0
            ? 1.0
            : percent < 0
                ? 0.0
                : percent,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = <Widget>[
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 3),
        ),
      ),
      Container(
        width: width * percent,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 3),
        ),
      ),
    ];

    if (text != null) {
      _children.add(Container(
          width: width,
          height: height,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Text(text!)));
    }

    return Stack(
      children: _children,
    );
  }
}
