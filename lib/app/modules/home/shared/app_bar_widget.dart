import 'package:app_arduino/app/modules/home/shared/enabled_widget.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget with PreferredSizeWidget {
  final Function function;
  final Function enable;
  const AppBarWidget({Key? key, required this.function, required this.enable})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Arduíno Controller"),
      actions: [
        EnabledWidget(function: widget.enable),
        GestureDetector(
          child: const Padding(
            padding: EdgeInsets.only(right: 8),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ),
          onTap: () async {
            await widget.function();
          },
        ),
      ],
    );
  }
}
