import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final String title;
  // final List<Widget> actions;

   MyAppBar({
    Key? key,
    // required this.title,
    // this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset('assets/logo.png', height: 40),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}