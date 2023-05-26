//
abstract class AuthStates {}

class IntitalAuthState extends AuthStates {}

//
//Login online fetch data
class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

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
