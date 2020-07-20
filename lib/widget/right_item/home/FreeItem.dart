import 'package:flutter/material.dart';
import 'package:wobei/constant/Config.dart';
import '../../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 免费领列表项
///
///********************************************************************************************
class FreeItem extends StatefulWidget {

  final String name;
  final bool isFirst;

  FreeItem({this.name, this.isFirst = false});

  @override
  _FreeItemState createState() => _FreeItemState();
}

class _FreeItemState extends State<FreeItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 12,
          ),
          Text(
            widget.name.maxLength(10),
            style: TextStyle(fontSize: 14, color: Config.BLACK_303133),
          ),
          Text(
            '免费领',
            style: TextStyle(fontSize: 12, color: Config.RED_B3926F),
          )
        ],
      ),
      padding: EdgeInsets.only(left: widget.isFirst ? 20 : 12),
    );
  }
}
