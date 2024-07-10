import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/data/models/user_model.dart';
import '../../../../core/data/source/firebase_service.dart';
import '../../../../core/data/utils/constants/firebase_constants.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(InitialAuthState());
  final _firebaseService = FirebaseService();

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<void> fetchUserModel() async {
    emit(LoadingAuthState());
    final profileImageUrl = await _firebaseService.getProfileImage();
    String userEmail = await _firebaseService.getUserEmail();
    _userModel = UserModel(email: _userModel?.email ?? userEmail, profileImageUrl: profileImageUrl ?? '');
    emit(LoggedInAuthState());
  }

  Future<void> uploadProfileImage(XFile file) async {
    emit(LoadingAuthState());
    final profileImageUrl = await _firebaseService.uploadProfileImage(file);
    String userEmail = await _firebaseService.getUserEmail();
    _userModel = UserModel(email: _userModel?.email ?? userEmail, profileImageUrl: profileImageUrl ?? '');
    emit(LoggedInAuthState());
  }

  void login(String email, String password) async {
    emit(LoadingAuthState());
    // Simulate login process
    final result = await _firebaseService.signin(email: email, password: password);
    if(result == FirebaseConstants.loggedIn){
      _userModel = UserModel(email: email, profileImageUrl: null);
      emit(LoggedInAuthState());
    } else {
      emit(ErrorAuthState(result));
    }
  }

  void register(String email, String password) async {
    emit(LoadingAuthState());
    // Simulate login process
    final result = await _firebaseService.signup(email: email, password: password);
    if(result == FirebaseConstants.registered){
      emit(LoggedInAuthState());
    } else {
      emit(ErrorAuthState(result));
    }
  }

  void logout() async {
    _firebaseService.signout();
  }
}
