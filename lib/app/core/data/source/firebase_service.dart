import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/todo_model.dart';
import '../utils/constants/error_constants.dart';
import '../utils/constants/firebase_constants.dart';

class FirebaseService {

  Future<String> getUserEmail() async {
    String userEmail = FirebaseAuth.instance.currentUser!.email!.toString();
    return userEmail;
  }

  Future<String> signup({
    required String email,
    required String password
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      return FirebaseConstants.registered;
    } on FirebaseAuthException catch(e) {
      if (e.code == FirebaseErrorConstants.weakPassword) {
        return FirebaseErrorConstants.weakPasswordMessage;
      } else if (e.code == FirebaseErrorConstants.emailAlreadyInUse) {
        return FirebaseErrorConstants.emailAlreadyInUseMessage;
      }
    }
    return ErrorConstants.someError;
  }

  Future<String> signin({
    required String email,
    required String password
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return FirebaseConstants.loggedIn;
    } on FirebaseAuthException catch(e) {
      if (e.code == FirebaseErrorConstants.invalidEmail) {
        return FirebaseErrorConstants.invalidEmailMessage;
      } else if (e.code == FirebaseErrorConstants.invalidCredencial) {
        if(e.message == FirebaseErrorConstants.invalidCredencialDefaultMessage){
          return FirebaseErrorConstants.invalidCredencialNotRegisteredMessage;
        }
        return FirebaseErrorConstants.wrongPasswordMessage;
      } else if (e.code == FirebaseErrorConstants.wrongPassword) {
        return FirebaseErrorConstants.wrongPasswordMessage;
      } else if (e.code == FirebaseErrorConstants.tooManyRequests) {
        return FirebaseErrorConstants.tooManyRequestsMessage;
      }
    }
    return ErrorConstants.someError;
  }

  Future<void> signout() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<List<TodoModel>> getTodoList() async {
    String userEmail = await getUserEmail();
    final querySnapshot = await FirebaseFirestore.instance
      .collection("userEmail")
      .doc(userEmail)
      .collection("Todo").get();
    List<TodoModel> todoList = querySnapshot.docs
      .map((doc) => TodoModel.fromMap(doc.data()))
      .toList();
    return todoList;
  }

  Future<void> addTodo(TodoModel todo) async {
    String userEmail = await getUserEmail();
    return await FirebaseFirestore.instance.collection("userEmail").doc(userEmail).collection("Todo").doc(todo.id).set(todo.toMap());
  }

  Future<void> updateTodo(TodoModel todo) async {
    String userEmail = await getUserEmail();
    return await FirebaseFirestore.instance.collection("userEmail").doc(userEmail).collection("Todo").doc(todo.id).update(todo.toMap());
  }

  Future<String?> uploadProfileImage(XFile image) async {
    try {
      String userEmail = await getUserEmail();
      String fileExtension = image.path.split('.').last;
      final ref = FirebaseStorage.instance.ref(userEmail).child('profileImage.$fileExtension');
      final imageData = await image.readAsBytes();
      await ref.putData(imageData);
      final url = await ref.getDownloadURL();
      return url;
    }catch(e){
      return null;
    }
  }

  Future<String?> getProfileImage() async {
    try {
      String userEmail = await getUserEmail();
      final ref = FirebaseStorage.instance.ref(userEmail);
      final list = await ref.list();
      if(list.items.isNotEmpty){
        final url = await ref.child(list.items.first.name).getDownloadURL();
        return url;
      }
      return null;
    }catch(e){
      return null;
    }
  }
}