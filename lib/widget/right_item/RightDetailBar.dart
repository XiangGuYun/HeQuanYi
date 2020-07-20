import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wobei/bean/RightDetailData.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/enum/RightType.dart';
import 'package:wobei/widget/VipPriceText.dart';
import '../../my_lib/extension/BaseExtension.dart';

class RightDetailBar extends StatefulWidget {

  final RightDetailData data;

  RightDetailBar(this.data);

  @override
  _RightDetailBarState createState() => _RightDetailBarState();
}

class _RightDetailBarState extends State<RightDetailBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.getSrnW(),
      height: 77,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Image.asset(
              Config.HECARD_ONLY,
              width: 44,
              height: 14,
            ),
            left: 20,
            top: 0,
          ),
          Positioned(
            child: Image.asset(
              Config.SUPPORTHEBEI,
              width: 44,
              height: 14,
            ),
            left: 72,
            top: 0,
          ),
          Positioned(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                      color: '#A5A3AC'.color(),
                      borderRadius: BorderRadius.all(Radius.circular(7))),
                ),
                Container(
                  height: 14,
                  width: 32,
                  decoration: BoxDecoration(
                      color: '#393649'.color(),
                      borderRadius: BorderRadius.all(Radius.circular(7))),
                ),
                Container(
                  height: 14,
                  width: 80,
                  alignment: Alignment.center,
                  child: '40%已售'.text(Colors.white, 10),
                ),
              ],
            ).setVisible1(false),
            right: 20,
            bottom: 29,
          ),
          Positioned(
            child: getPriceItem(),
            left: 20,
            bottom: 24,
          ),
          Positioned(
            child: '${Random().nextInt(100)}人已${Global.RIGHT_TYPE==RightType.FREE?"领":"买"}'.text('#A5A3AC'.color(), 12).setVisible1(true),
            right: 20,
            bottom: 28,
          )
        ],
      ),
    );
  }

  getPriceItem() {
    if(Global.RIGHT_TYPE == RightType.VIP_PRICE){
      return Row(
        children: <Widget>[
          VipPriceText(
            bigFontSize: 22,
            smallFontSize: 14,
            price: widget.data?.vipPrice.toString(),
          ),
          SizedBox(
            width: 2,
          ),
          Image.asset(
            Config.HECARD_PRICE,
            width: 22,
            height: 10,
            fit: BoxFit.fill,
          ).setPadding1(top: 3),
          SizedBox(
            width: 8,
          ),
          Text(
            '¥${widget.data?.price}',
            style: TextStyle(
              fontFamily: 'money',
              fontSize: 14,
              color: '#A5A3AC'.color(),
              decoration: TextDecoration.lineThrough,
              decorationColor: '#A5A3AC'.color(),
            ),
          ).setPadding1(top: 2)
        ],
      );
    } else if (Global.RIGHT_TYPE == RightType.FREE){
      return '免费领'.text(Color(0xFFB3926F), 16);
    } else if(Global.RIGHT_TYPE == RightType.NEW_PRICE ){
      // todo
      return SizedBox();
    } else {
      // todo
      return SizedBox();
    }
  }
}
