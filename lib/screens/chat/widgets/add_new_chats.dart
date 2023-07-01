import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/screens/chat/widgets/create_chat_bottomSheet.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/prompts/custom_prompt_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewChats extends StatelessWidget {
  const AddNewChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: Icon(
            Icons.add,
            color: ColorManager.accentColor,
          ),
          items: [
            ...MenuItems.firstItems.map(
              (item) => DropdownMenuItem<MenuItem>(
                value: item,
                child: MenuItems.buildItem(item),
              ),
            ),
          ],
          onChanged: (value) {
            MenuItems.onChanged(context, value!);
          },
          dropdownStyleData: DropdownStyleData(
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: ColorManager.settingsColor,
            ),
            offset: const Offset(0, 8),
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: const EdgeInsets.only(left: 16, right: 16),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [newChat, newPrompt];

  static const newChat =
      MenuItem(text: 'New chat', icon: CupertinoIcons.chat_bubble);
  static const newPrompt = MenuItem(text: 'New prompt', icon: Icons.file_copy);
  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.newChat:
        //Do something
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          backgroundColor: Colors.blueGrey,
          context: context,
          builder: (_) => CreateChatBottomSheet(
            appCubit: AppCubit.instance(context),
          ),
        );
        break;
      case MenuItems.newPrompt:
        //Do something
        showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
            value: AppCubit.instance(context),
            child: const CustomPromptDialog(),
          ),
        );
        break;
    }
  }
}
