import 'package:app_arduino/app/modules/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EnabledWidget extends StatefulWidget {
  final Function function;
  const EnabledWidget({Key? key, required this.function}) : super(key: key);

  @override
  State<EnabledWidget> createState() => _EnabledWidgetState();
}

class _EnabledWidgetState extends State<EnabledWidget> {
  HomeStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 12, 0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('Habilitar Blue. '),
          Switch(
            value: store.bluetoothState.isEnabled,
            onChanged: (bool value) {
              widget.function(value);
            },
          ),
        ],
      ),
    );
  }
}
