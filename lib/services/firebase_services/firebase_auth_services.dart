import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../view/screens/auth/login_signup_screen.dart';
import '../../view/screens/main_screens/bottom_nav_screens/home_screen.dart';

class FirebaseAuthServices{
  signupWithEmailAndPassword({
    required String name,
    required String emailAddress,
    required String password,
  })async{try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    String uid=credential.user!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid':uid,
      'name':name,
      'email':emailAddress,
      'createdAt':FieldValue.serverTimestamp(),

    });Get.snackbar('Success','User account created successfully.');
    return credential;

  } on FirebaseAuthException catch (e) {
    debugPrint('Signup Firebase Error: ${e.code}');
    debugPrint('Message: ${e.message}');

    if (e.code == 'weak-password') {
      debugPrint('The password provided is too weak.');
      Get.snackbar('Error','The password provided is too weak.');

    } else if (e.code == 'email-already-in-use') {
      debugPrint('An account already exists for this email.');
      Get.snackbar('Error','An account already exists for this email.');
    } else if (e.code == 'invalid-email') {
      debugPrint('The email address is invalid.');
      Get.snackbar('Error','The email address is invalid.');
    } else {
      debugPrint('Signup failed: ${e.code}');
      Get.snackbar('Error','Signup failed: ${e.code}');
    }

    return null;

  } catch (e) {
    debugPrint('Unexpected Signup Error: $e');
    Get.snackbar('Error','Unexpected Signup Error: $e');
    return null;
  }}

  loginWithEmailAndPassword({
    required String emailAddress,
    required String password,
    })async{try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password
    );
    Get.snackbar('Success','User logged in successfully.');
    Get.to(() => HomeScreen());
  }on FirebaseAuthException catch (e) {
    debugPrint('Login Firebase Error: ${e.code}');
    debugPrint('Message: ${e.message}');

    if (e.code == 'user-not-found') {
      debugPrint('No user found for that email.');
      Get.snackbar('Error','No user found for that email.');
    } else if (e.code == 'wrong-password') {
      debugPrint('Incorrect password.');
      Get.snackbar("Error",'Incorrect password.');
    } else if (e.code == 'invalid-credential') {
      debugPrint('Invalid email or password.');
      Get.snackbar("Error", 'Invalid email or password.');
    } else if (e.code == 'invalid-email') {
      debugPrint('Please enter a valid email address.');
      Get.snackbar("Error",'Please enter a valid email address.');
    } else if (e.code == 'user-disabled') {
      debugPrint('This user account has been disabled.');
      Get.snackbar("Error",'This user account has been disabled.');
    } else if (e.code == 'too-many-requests') {
      debugPrint('Too many attempts. Please try again later.');
      Get.snackbar("Error",'Too many attempts. Please try again later.');
    } else {
      debugPrint('Login failed: ${e.code}');
      Get.snackbar("Error",'Login failed: ${e.code}');
    }

    return null;

  } catch (e) {
    debugPrint('Unexpected Login Error: $e');
    return null;
  }
  }
}