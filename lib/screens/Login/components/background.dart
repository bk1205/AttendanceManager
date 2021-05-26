import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Image.asset("assets/images/main_top.png", width: size.width*0.35,),
            left: 0,
            top: 0,
          ),
          Positioned(
            child: Image.asset("assets/images/login_bottom.png", width: size.width*0.35,),
            right: 0,
            bottom: 0,
          ),
          child

        ],
      ),
    );
  }
}