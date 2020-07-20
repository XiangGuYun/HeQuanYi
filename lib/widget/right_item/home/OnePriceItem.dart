import 'package:flutter/material.dart';
import 'package:wobei/constant/Config.dart';

///********************************************************************************************
///
/// 只有一个价格的列表项
///
///********************************************************************************************
class OnePriceItem extends StatefulWidget {

  final String name;
  final double price;

  OnePriceItem({this.name, this.price});

  @override
  _OnePriceItemState createState() => _OnePriceItemState();
}

class _OnePriceItemState extends State<OnePriceItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 12,
          ),
          Text(
            widget.name,
            style: TextStyle(fontSize: 14, color: Config.BLACK_303133),
          ),
          Text(
            '¥ ${widget.price}',
            style: TextStyle(
                fontSize: 20, color: Config.BLACK_303133, fontFamily: 'money'),
          )
        ],
      ),
    );
  }
}
