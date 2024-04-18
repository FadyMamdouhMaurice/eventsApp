import 'package:firebase_auth/firebase_auth.dart';
import 'package:symstax_events/Models/user_model.dart';

class AuthViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        return UserModel(email: user.email ?? '', password: '');
      }
    } catch (e) {
      print('Error signing up: $e');
    }
    return null;
  }
}