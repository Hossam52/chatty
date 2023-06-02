//
import 'package:chatgpt/models/auth/user_model.dart';

abstract class AuthStates {}

class IntitalAuthState extends AuthStates {}

//
//Login online fetch data
class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {
  final User user;

  LoginSuccessState(this.user);
}

class LoginErrorState extends AuthStates {
  final String error;
  LoginErrorState({required this.error});
}

//Logout online fetch data
class LogoutLoadingState extends AuthStates {}

class LogoutSuccessState extends AuthStates {}

class LogoutErrorState extends AuthStates {
  final String error;
  LogoutErrorState({required this.error});
}

//Register online fetch data
class RegisterLoadingState extends AuthStates {}

class RegisterSuccessState extends AuthStates {}

class RegisterErrorState extends AuthStates {
  final String error;
  RegisterErrorState({required this.error});
}

//SendVerification online fetch data
class SendVerificationLoadingState extends AuthStates {}

class SendVerificationSuccessState extends AuthStates {}

class SendVerificationErrorState extends AuthStates {
  final String error;
  SendVerificationErrorState({required this.error});
}

//VerifyOtp online fetch data
class VerifyOtpLoadingState extends AuthStates {}

class VerifyOtpSuccessState extends AuthStates {
  String message;
  VerifyOtpSuccessState({
    required this.message,
  });
}

class VerifyOtpErrorState extends AuthStates {
  final String error;
  VerifyOtpErrorState({required this.error});
}

//ChangePhone online fetch data
class ChangePhoneLoadingState extends AuthStates {}

class ChangePhoneSuccessState extends AuthStates {
  final String phone;

  ChangePhoneSuccessState(this.phone);
}

class ChangePhoneErrorState extends AuthStates {
  final String error;
  ChangePhoneErrorState({required this.error});
}
