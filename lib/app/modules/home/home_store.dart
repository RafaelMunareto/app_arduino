import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  BluetoothConnection? connection;
  int? deviceState;
  bool isDisconnecting = false;
  FlutterBluetoothSerial bluethoot = Modular.get();
  bool get isConnected => connection != null && connection!.isConnected;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? device;
  bool connected = false;
  bool isButtonUnavailable = false;

  HomeStoreBase({required this.bluethoot});
}
