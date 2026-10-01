import 'package:flutter/material.dart';

Widget buildGoogleAuthButton({
  required VoidCallback? onPressed,
  required bool signUp,
  required String locale,
}) => OutlinedButton.icon(
  onPressed: onPressed,
  icon: const Text(
    'G',
    style: TextStyle(
      color: Colors.blue,
      fontSize: 18,
      fontWeight: FontWeight.w800,
    ),
  ),
  label: Text(
    signUp
        ? (locale == 'vi' ? 'Đăng ký với Google' : 'Sign up with Google')
        : (locale == 'vi' ? 'Đăng nhập với Google' : 'Sign in with Google'),
  ),
);
