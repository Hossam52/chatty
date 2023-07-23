import 'package:chatgpt/models/prompts/fields_types/prompt_field_type_details_model.dart';
import 'package:chatgpt/shared/network/services/app_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import './prompts_states.dart';

class FieldType {
  final String fieldName;
  final PromptFieldType fieldType;

  FieldType({required this.fieldName, required this.fieldType});
  Map<String, dynamic> toMap() {
    return {
      'field': fieldName,
      'field_type': fieldType.id,
    };
  }
}

//Bloc builder and bloc consumer methods
typedef PromptsBlocBuilder = BlocBuilder<PromptsCubit, PromptsStates>;
typedef PromptsBlocConsumer = BlocConsumer<PromptsCubit, PromptsStates>;

//
class PromptsCubit extends Cubit<PromptsStates> {
  PromptsCubit() : super(IntitalPromptsState());
  static PromptsCubit instance(BuildContext context) =>
      BlocProvider.of<PromptsCubit>(context);

  PromptFieldTypeDetailsModel? _fieldDetails;
  bool get hasFieldError => _fieldDetails == null;
  List<PromptFieldType> get fieldTypes => _fieldDetails?.prompt_types ?? [];

  PromptFieldType? selectedField;
  List<FieldType> addedFields = [];

  void setSelectedField(PromptFieldType? promptFieldType) {
    this.selectedField = promptFieldType;
    emit(ChangeSelectedPromptsState());
  }

  void removeAddedFields() {
    addedFields = [];
  }

  void addField(String fieldName) {
    if (selectedField == null) return;
    addedFields.add(FieldType(fieldName: fieldName, fieldType: selectedField!));
    selectedField = null;
    emit(AddPromptFieldState());
  }

  void removeAddedField(int index) {
    addedFields.removeAt(index);
    emit(RemovePromptFieldState());
  }

  Future<void> getPromptFieldTypes() async {
    if (!hasFieldError) return;
    try {
      emit(GetPromptFieldTypesLoadingState());
      final response = await AppServices.getPromptFieldTypes();
      _fieldDetails = PromptFieldTypeDetailsModel.fromMap(response);
      emit(GetPromptFieldTypesSuccessState());
    } catch (e) {
      emit(GetPromptFieldTypesErrorState(error: e.toString()));
    }
  }

  String? _isFeldsSamePromptFields(
      List<String> promptFields, List<String> userFields) {
    for (var field in userFields) {
      if (!promptFields.contains(field)) {
        throw "The field '[$field]' is required in the prompt.";
      }
    }

    for (var field in promptFields) {
      if (!userFields.contains(field)) {
        throw "The field '[$field]' not found in entered fields.";
      }
    }
    return null;
  }

  void _validateFields(String prompt) {
    RegExp regex = RegExp(r"\[([^\]]*)\]");
    List<String> matches =
        regex.allMatches(prompt).map((match) => match.group(1)!).toList();

    final userFields = addedFields.map((e) => e.fieldName).toList();
    final res = _isFeldsSamePromptFields(matches, userFields);
    if (res != null) {
      throw res;
    }
  }

  Future<void> addCustomPrompt(String promptName, String prompt) async {
    try {
      emit(AddCustomPromptLoadingState());
      _validateFields(prompt);
      final userFields = addedFields.map((e) => e.toMap()).toList();
      final res = await AppServices.addPrompt(
          promptName: promptName, prompt: prompt, userFields: userFields);

      emit(AddCustomPromptSuccessState(msg: res['message']));
    } catch (e) {
      emit(AddCustomPromptErrorState(error: e.toString()));
    }
  }
}
