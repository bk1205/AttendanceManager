import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class SocialIcon extends StatelessWidget {
  final String iconSrc;
  final Function onPress;
  const SocialIcon({
    this.iconSrc,
    this.onPress,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: kPrimaryLightColor
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(iconSrc, height: 20, width: 20, ),
      ),
    );
  }
}
