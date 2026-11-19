import 'package:flutter/material.dart';
import 'package:trip_cast/utils/app_colors.dart';

class CustomScaffold extends StatelessWidget {
  final bool isBackgroundGradient;
  final Widget? body;
  final Widget? child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const CustomScaffold({super.key, this.actions, this.floatingActionButton, this.bottomNavigationBar, required this.isBackgroundGradient, this.body, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isBackgroundGradient==true? Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.sky_grey, AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,),

        ),
        child: Material(color: Colors.transparent,
            child: child),
      ): body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,

    );
  }
}
