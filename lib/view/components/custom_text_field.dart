import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';


class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final void Function()? onSuffixTap;
  final void Function()? onPrefixTap;
  final bool? isObscure;
  final bool showBorder;
  final bool isNumberInput;
  final TextEditingController ?Controller;
  final FormFieldValidator<String>?validator;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  const CustomTextField({super.key, required this.hintText, this.suffixIcon, this.onSuffixTap, this.isObscure,  this.showBorder=true,  this.isNumberInput=false, this.Controller,  this.validator, this.onFieldSubmitted, this.prefixIcon, this.onPrefixTap, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      validator: validator,
      keyboardType: isNumberInput?TextInputType.number:TextInputType.text,
      obscureText: isObscure??false,
      controller: Controller,
      decoration: InputDecoration(
          fillColor: AppColors.pureWhite,
          prefixIcon:InkWell(onTap: onPrefixTap, child: Icon(prefixIcon)) ,
          suffixIcon: InkWell(onTap: onSuffixTap,
              child: Icon(suffixIcon)),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: showBorder?AppColors.border_grey:Colors.transparent, width: 2)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r),
              borderSide:  BorderSide(color: showBorder?AppColors.primary:Colors.transparent)),
          errorBorder:OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          )),);
  }
}