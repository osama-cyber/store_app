import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yagot_app/constants/colors.dart';
import 'package:yagot_app/utilities/helper_functions.dart';
import 'main_page_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() {
    Timer(Duration(seconds: 5), popSplash);
  }

  popSplash() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return  MainPages();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.lerp(Alignment.topLeft, Alignment.topRight, .9),
          end: Alignment.lerp(Alignment.bottomLeft, Alignment.bottomRight, .2),
          colors: [
            blue3,
            blue4,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SvgPicture.asset(
            "assets/icons/full_logo.svg",
            color: white,
            height: 120.h,
          ),
          SizedBox(
            height: 110.h,
          ),
          Container(
            height: 240.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: const DecorationImage(
              image: ExactAssetImage("assets/images/splash_.png"),
              fit: BoxFit.fill,
            )),
          ),
        ],
      ),
    );
  }
}
