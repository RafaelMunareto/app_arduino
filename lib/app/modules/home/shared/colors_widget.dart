import 'dart:convert';
import 'dart:typed_data';

import 'package:app_arduino/app/modules/home/home_store.dart';
import 'package:app_arduino/app/modules/home/shared/box_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ColorsWidget extends StatefulWidget {
  final String title;
  const ColorsWidget({Key? key, this.title = "ColorsWidget"}) : super(key: key);

  @override
  State<ColorsWidget> createState() => _ColorsWidgetState();
}

class _ColorsWidgetState extends State<ColorsWidget> {
  HomeStore store = Modular.get();
  List<Map> items = [
    {
      'color': Colors.red,
      'val': 'r',
      'text': 'VERMELHO',
    },
    {
      'color': Colors.green,
      'val': 'g',
      'text': 'VERDE',
    },
    {
      'color': Colors.blue,
      'val': 'b',
      'text': 'AZUL',
    },
    {
      'color': Colors.grey,
      'val': '0',
      'text': 'DESLIGADO',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return BoxContainerWidget(
      text: 'LED',
      tamanho: 0.95,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          ...List.generate(
            items.length,
            (index) => InkWell(
              onTap: () async {
                store.connection!.output.add(
                    utf8.encode(items[index]['val'] + "\r\n") as Uint8List);
                await store.connection!.output.allSent;
              },
              child: Container(
                margin: const EdgeInsets.all(14),
                width: MediaQuery.of(context).size.width * 0.4,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: items[index]['color'],
                ),
                child: Center(
                  child: Text(
                    items[index]['text'],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
