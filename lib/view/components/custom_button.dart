import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class Custombutton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color TextColor;
  final void Function()? onButtonTap;
  const Custombutton({super.key, required this.buttonText, required this.buttonColor, required this.TextColor, this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onButtonTap,
      child: Center(
        child: Container(padding: EdgeInsets.all(5),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border_grey, width:2),
              color: buttonColor,

            ),
            child: Align(alignment: AlignmentGeometry.center,
              child: Text(buttonText, style: TextStyle(color: TextColor,
                  fontSize: 19, fontWeight: FontWeight(700)),
              ),
            )),
      ),
    );
  }
}
