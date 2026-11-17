
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/screens/auth/check_your_email_screen.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendResetLink() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email address.")),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email address.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      Get.to(() => const CheckYourEmail());

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message = "Something went wrong. Please try again.";

      if (e.code == 'invalid-email') {
        message = "Please enter a valid email address.";
      } else if (e.code == 'too-many-requests') {
        message = "Too many requests. Please try again later.";
      } else if (e.code == 'network-request-failed') {
        message = "Please check your internet connection.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Please try again."),
        ),
      );

    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 44.h,
                width: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.chevron_left_outlined,
                    color: AppColors.ink,
                    size: 25,
                  ),
                ),
              ),

              15.verticalSpace,

              Container(
                padding: EdgeInsets.all(15),
                height: 72.h,
                width: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/icons/Gmail.png",
                    scale: 2,
                  ),
                ),
              ),

              25.verticalSpace,

              Text(
                "Forgot your password?",
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),

              12.verticalSpace,

              Text(
                "Enter the email you signed up with. We will send "
                    "you a link to choose a new password.",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),

              28.verticalSpace,

              Text(
                "Email",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),

              10.verticalSpace,

              Container(
                height: 54.h,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.ink,
                  ),
                  decoration: InputDecoration(
                    hintText: "you@example.com",
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.muted,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              25.verticalSpace,

              InkWell(
                onTap: isLoading ? null : sendResetLink,
                borderRadius: BorderRadius.circular(30.r),
                child: Container(
                  height: 56.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                      height: 23.h,
                      width: 23.w,
                      child: CircularProgressIndicator(
                        color: AppColors.pureWhite,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      "Send reset link",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
