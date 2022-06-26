import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../home/home_store.dart';

import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.instance<FlutterBluetoothSerial>(FlutterBluetoothSerial.instance),
    Bind.singleton((i) => HomeStore(bluethoot: i.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const HomePage()),
  ];
}
