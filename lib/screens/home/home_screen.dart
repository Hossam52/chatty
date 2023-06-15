import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import '../../cubits/app_cubit/app_cubit.dart';
import '../chat/chat_history_screen.dart';
import '../settings/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = NotchBottomBarController(index: 1);
  final _pageController = PageController(initialPage: 1);
  final List<_BottomModel> _items = [
    _BottomModel(title: 'Info', icon: CupertinoIcons.info, child: Container()),
    _BottomModel(
        title: 'Chats',
        icon: CupertinoIcons.chat_bubble_2,
        child: const ChatHistoryScreen()),
    _BottomModel(
        title: 'Settings',
        icon: CupertinoIcons.settings,
        child: const SettingsScreen()),
  ];
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..fetchAllChats(),
      child: Scaffold(
        bottomNavigationBar: _bottomNavigation(),
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _items.map((e) => e.child).toList(),
        ),
      ),
    );
  }

  Widget _bottomNavigation() {
    return AnimatedNotchBottomBar(
        color: Colors.black38,
        notchColor: Colors.grey,
        onTap: (index) {
          setState(() {});
          _pageController.jumpToPage(index);
        },
        notchBottomBarController: _controller,
        bottomBarItems: _items
            .map(
              (e) => BottomBarItem(
                inActiveItem: Icon(
                  e.icon,
                  color: Colors.blueGrey,
                ),
                activeItem: Icon(
                  e.icon,
                  color: Colors.blueGrey,
                ),
                itemLabel: e.title,
              ),
            )
            .toList());
  }
}

class _BottomModel {
  final String title;
  final IconData icon;
  final Color? color;
  final Widget child;

  _BottomModel(
      {required this.title,
      required this.child,
      required this.icon,
      this.color});
}
