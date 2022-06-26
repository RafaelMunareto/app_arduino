import 'package:app_arduino/app/modules/home/shared/box_container_widget.dart';
import 'package:flutter/material.dart';

class ServoMotorWidget extends StatefulWidget {
  final String title;
  const ServoMotorWidget({Key? key, this.title = "ServoMotorWidget"})
      : super(key: key);

  @override
  State<ServoMotorWidget> createState() => _ServoMotorWidgetState();
}

class _ServoMotorWidgetState extends State<ServoMotorWidget> {
  double _sliderDiscreteValue = 20;
  @override
  Widget build(BuildContext context) {
    return BoxContainerWidget(
      // ignore: sort_child_properties_last
      child: Slider(
        value: _sliderDiscreteValue,
        min: 0,
        max: 100,
        divisions: 5,
        label: _sliderDiscreteValue.round().toString(),
        onChanged: (value) {
          setState(() {
            _sliderDiscreteValue = value;
          });
        },
      ),
      text: 'SERVO MOTOR',
    );
  }
}
