import 'package:app_arduino/app/modules/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ConectarWidget extends StatefulWidget {
  final Function getDeviceItems;
  final dynamic connect;
  final dynamic disconnect;
  const ConectarWidget(
      {Key? key,
      required this.getDeviceItems,
      this.connect,
      required this.disconnect})
      : super(key: key);

  @override
  State<ConectarWidget> createState() => _ConectarWidgetState();
}

class _ConectarWidgetState extends State<ConectarWidget> {
  HomeStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Dispositivo:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButton(
            items: widget.getDeviceItems(),
            onChanged: (dynamic value) => setState(() => store.device = value),
            value: store.devicesList.isNotEmpty ? store.device : null,
          ),
          ElevatedButton(
            onPressed: store.isButtonUnavailable
                ? null
                : store.connected
                    ? widget.disconnect
                    : widget.connect,
            child: Text(store.connected ? 'Disconectar' : 'Conectar'),
          ),
        ],
      ),
    );
  }
}
