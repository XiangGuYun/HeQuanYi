import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wobei/bean/Pair.dart';
import 'package:wobei/bean/PayInfoData.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/EventBus.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/page/dialog/CancelPayDialog.dart';
import 'package:wobei/widget/BlackButton.dart';
import 'package:wobei/widget/TitleBar.dart';

import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 权益支付页
///
///********************************************************************************************
class RightPayPage extends StatefulWidget {
  /// itemID
  final String id;

  RightPayPage({this.id});

  @override
  _RightPayPageState createState() => _RightPayPageState();
}

class _RightPayPageState extends State<RightPayPage> with BaseUtils {
  CancelPayDialog dialogCancelPay;

  /// 商品价格
  double price = 0.0;

  /// 商品名称
  String name = '';

  /// 支付方式
  List<Payway> payWays = [];

  var time = '30:00';

  String getFmtString(int seconds) {
    return (seconds / 60).toInt().toString() + ":" + (seconds % 60).toString();
  }

  @override
  void initState() {
    super.initState();

    var timePeriod = 30 * 60;

    Timer.periodic(Duration(seconds: 1), (timer) {
      timePeriod -= 1;
      setState(() {
        time = getFmtString(timePeriod);
      });
      if (timePeriod == 0) {
        timer.cancel();
        Req.cancelPayRightOrder(widget.id, (d) {
          if (d) {
            context.pop();
          }
        });
      }
    });

    dialogCancelPay = CancelPayDialog(
      rightClick: () {
        Req.cancelPayRightOrder(widget.id, (d) {
          if (d) {
            context.pop();
            context.pop();
          }
        });
      },
    );

    // 获取订单详情
    Req.getPayInfo(widget.id, (PayInfoData data) {
      setState(() {
        price = data.price;
        name = data.itemName;
        for (var i = 0; i < data.payways.length; i++) {
          data.payways[i].index = i;
        }
        payWays = data.payways;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              width: context.getSrnW(),
              height: context.getSrnH(),
              margin: EdgeInsets.only(top: 44 + getStatusBarHeight()),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 1,
                        ).setExpanded(1),
                        Image.asset(
                          Config.TIME,
                          width: 14,
                          height: 14,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        '支付剩余时间 $time'.text('#909399'.color(), 14),
                        SizedBox(
                          width: 1,
                        ).setExpanded(1),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '¥ $price',
                      style: TextStyle(
                          fontSize: 32,
                          color: Config.BLACK_303133,
                          fontFamily: 'money'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    name.text(Config.GREY_909399, 14),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: payWays
                          .map((e) => PayWayItem(
                                payWay: e,
                                index: e.index,
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: TitleBar(
                title: '支付',
              ),
            ),
            Positioned(
              child: Container(
                width: context.getSrnW(),
                height: 70,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: BlackButton(
                  text: '确认支付 (¥$price)',
                ),
              ),
              left: 0,
              bottom: 0,
              right: 0,
            )
          ],
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    dialogCancelPay.show(context);
    return true;
  }
}

class PayWayItem extends StatefulWidget {
  final Payway payWay;

  final int index;

  PayWayItem({this.payWay, this.index});

  @override
  _PayWayItemState createState() => _PayWayItemState();
}

class _PayWayItemState extends State<PayWayItem> {
  var isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.payWay.chosen;
    bus.on('PayWayItem', (arg) {
      Pair pair = arg;
      switch (pair.first) {
        case 'checkEvent':
          if (widget.index == pair.second) {
            setState(() {
              isChecked = true;
            });
          } else {
            setState(() {
              isChecked = false;
            });
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.getSrnW(),
      height: 60,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: CachedNetworkImage(
              imageUrl: widget.payWay.logo,
              width: 20,
              height: 20,
            ),
            left: 20,
            top: 20,
            bottom: 20,
          ),
          Positioned(
            child: Container(
              height: 60,
              child: widget.payWay.content.text(Config.BLACK_303133, 16),
              alignment: Alignment.centerLeft,
            ),
            left: 60,
          ),
          Positioned(
            child: Image.asset(
              widget.payWay.selectable
                  ? (isChecked ? Config.SELECTED : Config.SELECT)
                  : Config.SELECT_DISABLE,
              width: 16,
              height: 16,
            ),
            right: 20,
            top: 22,
          ),
          Positioned(
            child: Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: Config.DIVIDER_COLOR,
            ),
            left: 0,
            right: 0,
            bottom: 0,
          )
        ],
      ),
    ).setGestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            bus.emit(
                'PayWayItem', Pair(first: 'checkEvent', second: widget.index));
          });
        });
  }
}
