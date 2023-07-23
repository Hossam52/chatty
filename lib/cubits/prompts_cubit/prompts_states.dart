//
abstract class PromptsStates {}

class IntitalPromptsState extends PromptsStates {}
//

class ChangeSelectedPromptsState extends PromptsStates {}

class RemovePromptFieldState extends PromptsStates {}

class AddPromptFieldState extends PromptsStates {}

//GetPromptFieldTypes online fetch data
class GetPromptFieldTypesLoadingState extends PromptsStates {}

class GetPromptFieldTypesSuccessState extends PromptsStates {}

class GetPromptFieldTypesErrorState extends PromptsStates {
  final String error;
  GetPromptFieldTypesErrorState({required this.error});
}

//AddCustomPrompt online fetch data
class AddCustomPromptLoadingState extends PromptsStates {}

class AddCustomPromptSuccessState extends PromptsStates {
  final String msg;
  AddCustomPromptSuccessState({
    required this.msg,
  });
}

class AddCustomPromptErrorState extends PromptsStates {
  final String error;
  AddCustomPromptErrorState({required this.error});
}
