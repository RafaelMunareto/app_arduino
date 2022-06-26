// ignore_for_file: sort_child_properties_last, deprecated_member_use

import 'package:app_arduino/app/modules/home/home_store.dart';
import 'package:app_arduino/app/modules/home/shared/bluethoot_completo_widget.dart';
import 'package:app_arduino/app/modules/home/shared/colors_widget.dart';
import 'package:app_arduino/app/modules/home/shared/motor_dc_widget.dart';
import 'package:app_arduino/app/modules/home/shared/servo_motor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomeStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return BluethootCompletoWidget(
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: const [
                ColorsWidget(),
                MotorDcWidget(),
                ServoMotorWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
