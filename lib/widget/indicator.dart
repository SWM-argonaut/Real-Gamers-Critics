import 'package:flutter/material.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

/// 0 <= percent <= 1
class LinearIndicator extends StatelessWidget {
  final double width;
  final double height;
  final double percent;
  final String? text;
  final Color backgroundColor;
  final Color? color;

  LinearIndicator({
    required percent,
    this.width = 100,
    this.height = 20,
    this.backgroundColor = Colors.black12,
    this.color,
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
          color: percent == 1 ? Colors.white : backgroundColor,
          borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 3),
        ),
      ),
      AnimatedContainer(
        width: width * percent,
        height: height,
        curve: Curves.linear,
        duration: Duration(seconds: 2),
        decoration: BoxDecoration(
          color: color ??
              (percent == 1
                  ? Color.fromRGBO(0, 255, 10, 0.2)
                  : Color.fromRGBO(255, 0, 0, 0.25)),
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
