import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wobei/bean/ReChargeData.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/utils/FileUtils.dart';
import 'package:wobei/widget/EditText.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 话费充值页
///
///********************************************************************************************
class PrepaidRefillPage extends StatefulWidget {
  @override
  _PrepaidRefillPageState createState() => _PrepaidRefillPageState();
}

class _PrepaidRefillPageState extends State<PrepaidRefillPage> {
  var ctrl;

  String phone = '';

  String tip = '';

  List<RechargeData> list = [];

  @override
  void initState() {
    super.initState();
    var initText = Global.prefs.getString('phone') != null
        ? Global.prefs.getString('phone')
        : '';
    ctrl = TextEditingController.fromValue(TextEditingValue(
        // 设置内容
        text: initText,
        // 保持光标在最后
        selection: TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream,
          offset: initText.length,
        ))));

    FileUtils.getStringFromTemp('PrepaidRefillPage.txt', (jsonStr) {
      List list = json.decode(jsonStr);
      List<RechargeData> dataList =
          list.map((data) => RechargeData.fromJson(data)).toList();
      setState(() {
        list = dataList.sublist(0, 6);
      });
    });

    Req.checkTheCallRechargeTAB((List<RechargeData> data, String jsonStr) {
      setState(() {
        list = data.sublist(0, 6);
      });
      FileUtils.writeFileToTemp(context, 'PrepaidRefillPage.txt', jsonStr);
    });

    Req.getRechargeTip((string) {
      setState(() {
        tip = string;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleBar(
            title: '话费充值',
            needDivider: false,
          ),
          SizedBox(
            height: 20.5,
          ),
          EditText(
            context.getSrnW() - 40,
            height: 39,
            margin: EdgeInsets.only(left: 20, right: 20),
            inputType: TextInputType.number,
            maxLength: 11,
            textSize: 28,
            textColor: '#303133'.color(),
            controller: ctrl,
            hint: '请输入手机号码',
            hintColor: '#C0C4CC'.color(),
            hintSize: 20,
            onChanged: (String value) {
              setState(() {
                phone = value;
              });
            },
          ),
          SizedBox(
            height: 10.5,
          ),
          Divider(
            height: 1,
            color: Config.DIVIDER_COLOR,
            endIndent: 20,
            indent: 20,
          ),
          SizedBox(
            height: 20,
          ),
          '选择充值话费'.text('#909399'.color(), 14).setMargin1(left: 20),
          GridView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (context.getSrnW() - 60) / 3 / 80,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
              ),
              itemBuilder: (ctx, i) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: getColor(), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: '${getPriceView(i)}元'
                            .toString()
                            .text(getColor(), 20),
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 17.5),
                      ),
                      Positioned(
                        child: '特价${getPriceDiscount(i)}元'
                            .text(getColor(), 12)
                            .setAlign(Alignment.bottomCenter),
                        bottom: 17.5,
                        left: 0,
                        right: 0,
                      )
                    ],
                  ),
                ).setInkWell(onTap: () {
                  "话费充值已暂停，给您带来不便，敬请谅解！".toast();
                });
              }).setMargin1(left: 20, right: 20),
          SizedBox(
            height: 20,
          ),
          tip.text('#909399'.color(), 14).setMargin1(left: 20, right: 20)
        ],
      ),
    );
  }

  getColor() {
    return phone.length == 11 ? '#303133'.color() : '#C0C4CC'.color();
  }

  getPriceDiscount(int i) {
    switch (i) {
      case 0:
        return 10.0;
        break;
      case 1:
        return 19.90;
        break;
      case 2:
        return 29.80;
        break;
      case 3:
        return 49.70;
        break;
      case 4:
        return 99.50;
        break;
      default:
        return 199;
        break;
    }
  }

  getPriceView(int i) {
    switch (i) {
      case 0:
        return 10;
        break;
      case 1:
        return 20;
        break;
      case 2:
        return 30;
        break;
      case 3:
        return 50;
      case 4:
        return 100;
        break;
      default:
        return 200;
    }
  }
}
