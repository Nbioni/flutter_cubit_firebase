class FirebaseConstants {
  static String loggedIn = "logged-in";
  static String invalidEmail = "logged-in";
  static String registered = "registered";
}

class FirebaseErrorConstants {
  static String invalidEmail = "invalid-email";
  static String invalidEmailMessage = "This email is not registered.";
  
  static String invalidCredencial = "invalid-credential";
  static String invalidCredencialDefaultMessage = "The supplied auth credential is malformed or has expired.";
  static String invalidCredencialNotRegisteredMessage = "Email not registered or expired.";
  static String invalidCredencialMessage = "Invalid credentials.";

  static String wrongPassword = "wrong-password";
  static String wrongPasswordMessage = "The password is incorrect.";

  static String weakPassword = "weak-password";
  static String weakPasswordMessage = "The password is weak.";

  static String emailAlreadyInUse = "email-already-in-use";
  static String emailAlreadyInUseMessage = "This email is already registered.";

  static String tooManyRequests = "too-many-requests";
  static String tooManyRequestsMessage = "Access to this account has been temporarily disabled due to many failed login attempts.";
}