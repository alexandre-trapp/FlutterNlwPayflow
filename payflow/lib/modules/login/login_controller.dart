import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:payflow/shared/auth/auth_controller.dart';
import 'package:payflow/shared/models/user_model.dart';

class LoginController {
  final authController = AuthController();

  Future<void> googleSignIn(BuildContext context) async {
    var _google_signin = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

    try {
      final response = await _google_signin.signIn();

      final user = UserModel(
        name: response!.displayName!,
        photoURL: response.photoUrl,
      );

      authController.setUser(context, user);

      print(response);
    } catch (error) {
      authController.setUser(context, null);
      print(error);
    }
  }
}
