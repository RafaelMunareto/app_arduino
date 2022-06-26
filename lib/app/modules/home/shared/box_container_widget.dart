import 'package:flutter/material.dart';

class BoxContainerWidget extends StatefulWidget {
  final Widget child;
  final String text;
  final double tamanho;
  const BoxContainerWidget(
      {Key? key, required this.child, required this.text, this.tamanho = 0.44})
      : super(key: key);

  @override
  State<BoxContainerWidget> createState() => _BoxContainerWidgetState();
}

class _BoxContainerWidgetState extends State<BoxContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * widget.tamanho,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Wrap(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.text,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            widget.child
          ],
        ),
      ),
    );
  }
}
