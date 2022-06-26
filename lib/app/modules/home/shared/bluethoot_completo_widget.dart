// ignore_for_file: sort_child_properties_last, deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';

import 'package:app_arduino/app/modules/home/home_store.dart';
import 'package:app_arduino/app/modules/home/shared/app_bar_widget.dart';
import 'package:app_arduino/app/modules/home/shared/conectar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BluethootCompletoWidget extends StatefulWidget {
  final Widget? child;
  const BluethootCompletoWidget({Key? key, required this.child})
      : super(key: key);

  @override
  State<BluethootCompletoWidget> createState() =>
      _BluethootCompletoWidgetState();
}

class _BluethootCompletoWidgetState extends State<BluethootCompletoWidget> {
  HomeStore store = Modular.get();
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  startBluethoot() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        store.bluetoothState = state;
      });
    });
    store.deviceState = 0;
    enableBluetooth();
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        store.bluetoothState = state;
        if (store.bluetoothState == BluetoothState.STATE_OFF) {
          store.isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startBluethoot();
  }

  @override
  void dispose() {
    if (store.isConnected) {
      store.isDisconnecting = true;
      store.connection!.dispose();
      store.connection = null;
    }
    super.dispose();
  }

  Future enableBluetooth() async {
    store.bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (store.bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      debugPrint("Error");
    }
    if (!mounted) {
      return;
    }
    setState(() {
      store.devicesList = devices;
    });
  }

  refresh() {
    getPairedDevices().then((_) {
      show('Lista de dispositivo atualizada');
    });
  }

  enable(value) {
    future() async {
      if (value) {
        await FlutterBluetoothSerial.instance.requestEnable();
      } else {
        await FlutterBluetoothSerial.instance.requestDisable();
      }

      await getPairedDevices();
      store.isButtonUnavailable = false;

      if (store.connected) {
        disconnect();
      }
    }

    future().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(function: refresh, enable: enable),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Visibility(
              visible: store.isButtonUnavailable &&
                  store.bluetoothState == BluetoothState.STATE_ON,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.greenAccent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Padding(
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
                    items: _getDeviceItems(),
                    onChanged: (dynamic value) =>
                        setState(() => store.device = value),
                    value: store.devicesList.isNotEmpty ? store.device : null,
                  ),
                  ElevatedButton(
                    onPressed: store.isButtonUnavailable
                        ? null
                        : store.connected
                            ? disconnect
                            : connect,
                    child: Text(store.connected ? 'Disconectar' : 'Conectar'),
                  ),
                ],
              ),
            ),
            widget.child!
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (store.devicesList.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NENHUM'),
      ));
    } else {
      for (var device in store.devicesList) {
        items.add(DropdownMenuItem(
          child: Text(device.name.toString()),
          value: device,
        ));
      }
    }
    return items;
  }

  void connect() async {
    setState(() {
      store.isButtonUnavailable = true;
    });
    if (store.device == null) {
      show('Dispositivo não selecionado');
    } else {
      if (!store.isConnected) {
        await BluetoothConnection.toAddress(store.device!.address)
            .then((connection) {
          debugPrint('Connected to the device');
          store.connection = connection;
          setState(() {
            store.connected = true;
          });

          store.connection!.input!.listen(null).onDone(() {
            if (store.isDisconnecting) {
              debugPrint('Disconnecting locally!');
            } else {
              debugPrint('Disconnected remotely!');
            }
            if (mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          debugPrint('Não foi possível conectar.');
          debugPrint(error);
        });
        show('Dispositivo conectado');

        setState(() => store.isButtonUnavailable = false);
      }
    }
  }

  void disconnect() async {
    setState(() {
      store.isButtonUnavailable = true;
      store.deviceState = 0;
    });

    await store.connection!.close();
    show('Dispositivo desconectado');
    if (!store.connection!.isConnected) {
      setState(() {
        store.connected = false;
        store.isButtonUnavailable = false;
      });
    }
  }

  void sendOnMessageToBluetooth() async {
    store.connection!.output.add(utf8.encode("g" "\r\n") as Uint8List);
    await store.connection!.output.allSent;
    show('Dispositivo ligado');
    setState(() {
      store.deviceState = 1; // device on
    });
  }

  void sendOffMessageToBluetooth() async {
    store.connection!.output.add(utf8.encode("0" "\r\n") as Uint8List);
    await store.connection!.output.allSent;
    show('Desligar');
    setState(() {
      store.deviceState = -1;
    });
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
