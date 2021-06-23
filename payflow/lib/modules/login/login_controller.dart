import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  Future<void> googleSignIn() async {
    var _google_signin = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

    try {
      final response = await _google_signin.signIn();
      print(response);
    } catch (error) {
      print(error);
    }
  }
}
