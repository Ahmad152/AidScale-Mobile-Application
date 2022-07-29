import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  Stream<User?> get user{
    return _auth.authStateChanges();
  }
  // sign in anonymously
  Future signInAnon() async{
    try{
      UserCredential result =await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    }on FirebaseException catch(e){
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
      return null;
    }
  }

  // sign in with email & password
  Future signInEmail(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }catch (e){
      print(e.toString());
      return null;
    }

  }

  // sign register with email & password
  Future registerEmail(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }catch (e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signout() async {
    try{
      return await _auth.signOut();
    }catch(e){

    }
  }
}