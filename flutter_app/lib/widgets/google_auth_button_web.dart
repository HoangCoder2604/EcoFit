import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

Widget buildGoogleAuthButton({
  required VoidCallback? onPressed,
  required bool signUp,
  required String locale,
}) => IgnorePointer(
  ignoring: onPressed == null,
  child: Opacity(
    opacity: onPressed == null ? 0.5 : 1,
    child: Center(
      child: web.renderButton(
        configuration: web.GSIButtonConfiguration(
          type: web.GSIButtonType.standard,
          theme: web.GSIButtonTheme.outline,
          size: web.GSIButtonSize.large,
          text: signUp
              ? web.GSIButtonText.signupWith
              : web.GSIButtonText.signinWith,
          shape: web.GSIButtonShape.pill,
          logoAlignment: web.GSIButtonLogoAlignment.left,
          minimumWidth: 320,
          locale: locale,
        ),
      ),
    ),
  ),
);
