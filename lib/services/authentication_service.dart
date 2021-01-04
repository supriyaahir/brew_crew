import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Users  _userFromUserCredential(User user){
    print("user credential");
    print(user.uid);
    return user != null ? Users(uid:user.uid) : null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }


  Future signInWithEmailAndPassword({String email, String password}) async {
    try {
     UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
     User user = userCredential.user;
      return _userFromUserCredential(user);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future registerWithEmailAndPassword({String email, String password}) async {
    try {
      UserCredential userCredential =  await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
      return _userFromUserCredential(user);
      //return "Signed up";
    }
    on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    }
  }
}
