import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/plugin/LogPlugin.dart';
import '../my_lib/extension/BaseExtension.dart';

class PinYinWidget extends StatefulWidget {
  final Function getCurrentLetter;

  PinYinWidget({this.getCurrentLetter});

  @override
  _PinYinWidgetState createState() => _PinYinWidgetState();
}

class _PinYinWidgetState extends State<PinYinWidget> {
  final letters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  var currentLetter = '';

  var lastLetter = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffdddddd),
          borderRadius: BorderRadius.all(Radius.circular(2))),
//      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: GestureDetector(
        child: Column(
          children: letters
              .map((e) => GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: currentLetter == e
                              ? Config.BLACK_303133
                              : Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        e,
                        style: TextStyle(
                            color: currentLetter == e
                                ? Colors.white
                                : Config.BLACK_303133,
                            fontSize: 12),
                      ),
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                    ),
                  ))
              .toList(),
        ),
        onVerticalDragUpdate: (details) {
          //${details.globalPosition} ${details.localPosition} ${details.delta}
//          LogPlugin.logD('test', 'onVerticalDragUpdate ${(details.localPosition.dy/16).toInt()} ');
          var position = details.localPosition.dy ~/ 16;
          if (position >= 0 && position <= 25 && letters[position] != lastLetter) {
//            LogPlugin.logD('test', letters[position]);
            widget.getCurrentLetter(letters[position], position);
            lastLetter = letters[position];
          }
        },
        onVerticalDragStart: (details) {
          var position = details.localPosition.dy ~/ 16;
          if (position >= 0 && position <= 25 && letters[position] != lastLetter) {
//            LogPlugin.logD('test', letters[position]);
            widget.getCurrentLetter(letters[position], position);
            lastLetter = letters[position];
          }
        },
//        onVerticalDragEnd: (details) {
//          var position = (details.localPosition.dy / 16).toInt();
//          if (position >= 0 && position <= 25 && letters[position] != lastLetter) {
//            LogPlugin.logD('test', letters[position]);
//            widget.getCurrentLetter(letters[position])
//            lastLetter = letters[position];
//          }
//        },
      ),
    );
  }
}

//
