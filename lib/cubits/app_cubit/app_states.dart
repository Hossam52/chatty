//
abstract class AppStates {}

class IntitalAppState extends AppStates {}
//

//FetchAllChats online fetch data
class FetchAllChatsLoadingState extends AppStates {}

class FetchAllChatsSuccessState extends AppStates {}

class FetchAllChatsErrorState extends AppStates {
  final String error;
  FetchAllChatsErrorState({required this.error});
}
