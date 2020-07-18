import 'package:flutter/material.dart';
import 'package:wobei/bean/BuyVipData.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/widget/BlackButton.dart';
import 'package:wobei/widget/GoldButton.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 会员购买页
///
///********************************************************************************************
class BuyVipPagePage extends StatefulWidget {
  @override
  _BuyVipPagePageState createState() => _BuyVipPagePageState();
}

class _BuyVipPagePageState extends State<BuyVipPagePage> with BaseUtils {
  /// 选择的列表项索引值
  int selectIndex = 0;

  List<Detail> itemList = [];

  List<PriceConfigAppVo> buyItemList = [];

  String valueSave = '0';

  @override
  void initState() {
    super.initState();
    setStatusBarColor(true, Colors.white);

    Req.getVipPurchasePage(Global.prefs.getString('vip') == 1, (BuyVipData data){
      setState(() {
        itemList = data.details;
        buyItemList = data.priceConfigAppVos;
        valueSave = data.saveMoneyCount.toString().replaceAll('.0', '');
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(false, Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff393649),
      body: Container(
        width: context.getSrnW(),
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: Global.prefs.getString('vip')=='1'?84 + getStatusBarHeight():44 + getStatusBarHeight(),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            '购买会员至少为您省',
                            style:
                            TextStyle(fontSize: 14, color: Color(0xffa5a3ac)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                valueSave,
                                style: TextStyle(
                                    fontSize: 48, color: Config.GOLD_FFE2C0),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Padding(
                                child: Text(
                                  '元/月',
                                  style: TextStyle(
                                      fontSize: 12, color: Config.GOLD_FFE2C0),
                                ),
                                padding: EdgeInsets.only(bottom: 8),
                              )
                            ],
                          ),
                        ),
                        getInfoList(),
                        SizedBox(
                          height: 20,
                        ),
                        getBuyItemList(),
                        SizedBox(
                          height: 90,
                        )
                      ],
                    ),
                    Positioned(
                      child: Image.asset(Config.VIP_BG, width: 90, height: 90,),
                      right: 20,
                      top: Global.prefs.getString('vip')=='1'?getStatusBarHeight()+44+20+40 : getStatusBarHeight()+44+20,
                    )
                  ],
                ),
                color: Color(0xff393649),
              ),
            ),
            TitleBar(
              title: '购买会员',
            ),
            Positioned(
              top: context.getSrnH() - 70,
              child: Container(
                color: Color(0xff393649),
                width: context.getSrnW(),
                height: 70,
                alignment: Alignment.center,
                child: GoldButton(
                  text: Global.prefs.getString('vip')=='1'?'立即续费':'立即开通',
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: context.getSrnW(),
                height: 40,
                color: Color(0xff666666),
                alignment: Alignment.center,
                child: Text(
                  '您的会员将于 2019.08.30 到期，续费后有效期顺延',
                  style: TextStyle(fontSize: 14, color: Config.GOLD_FFE2C0),
                ),
              ).setVisible2(Global.prefs.getString('vip')=='1'),
              top: 44 + getStatusBarHeight(),
            ),
          ],
        ),
      ),
    );
  }

  getInfoList() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: EdgeInsets.only(bottom: 20),
      width: context.getSrnW() - 40,
      decoration: BoxDecoration(
          color: Color(0xff606266),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        children: getList(itemList),
      ),
    );
  }

  getList(List<Detail> list) {
    if(list.length==0){
      list.insert(0, Detail());
    }
    List<Widget> widgets = [];
    list.asMap().forEach((i, item) {
      if (i == 0) {
        widgets.add(Column(
          children: <Widget>[
            Row(children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Text(
                '权益',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ).setAlign(Alignment(-1, 0)).setExpanded(2),
              Text(
                '禾卡会员',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ).setCenter().setExpanded(3),
              Text(
                '为您省',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ).setAlign(Alignment(1, 0)).setExpanded(2),
              SizedBox(
                width: 20,
              ),
            ]).setSizedBox(height: 59),
            Divider(
              height: 1,
              color: Config.DIVIDER_COLOR,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ).setSizedBox(height: 60));
      } else {
        widgets.add(Column(
          children: <Widget>[
            Row(children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Text(
                item.name,
                style: TextStyle(fontSize: 12, color: Color(0xffc9c8cd)),
              ).setAlign(Alignment(-1, 0)).setExpanded(2),
              Text(
                item.itemDesc,
                style: TextStyle(fontSize: 12, color: Color(0xffc9c8cd)),
              ).setCenter().setExpanded(3),
              Text(
                '¥${item.saveMoney}/月',
                style: TextStyle(fontSize: 12, color: Color(0xffc9c8cd)),
              ).setAlign(Alignment(1, 0)).setExpanded(2),
              SizedBox(
                width: 20,
              ),
            ]).setSizedBox(height: 59),
            Divider(
              height: 1,
              color: Config.DIVIDER_COLOR,
              indent: 20,
              endIndent: 20,
            ).setVisible2(i != list.length - 1),
          ],
        ).setSizedBox(height: 60));
      }
    });
    return widgets;
  }

  getBuyItemList() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: buyItemList.length,
        itemBuilder: (ctx, i) {
          return Container(
            width: (context.getSrnW() - 20 * 2 - 12 * 2) / 3,
            height: 140,
            margin:
                EdgeInsets.only(left: i == 0 ? 20 : 12, right: i == 4 ? 20 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                  color:
                      selectIndex == i ? Config.GOLD_FFE2C0 : Color(0xFF6F6C7A),
                  width: 1),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 16),
                  child: Text(
                    buyItemList[i].name,
                    style: TextStyle(
                        color: selectIndex == i
                            ? Config.GOLD_FFE2C0
                            : Colors.white,
                        fontSize: 12),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 58),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                        text: '¥ ',
                        style: TextStyle(
                            fontSize: 12,
                            color: Config.GOLD_FFE2C0,
                            fontFamily: 'money')),
                    TextSpan(
                        text: buyItemList[i].realPrice.toString(),
                        style: TextStyle(
                            fontSize: 24,
                            color: Config.GOLD_FFE2C0,
                            fontFamily: 'money')),
                  ])),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 28),
                  child: Text(
                    '原价${buyItemList[i].originalPrice}元',
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: i==selectIndex?Config.GOLD_FFE2C0:Color(0xFF6F6C7A),
                        color: selectIndex == i
                            ? Config.GOLD_FFE2C0
                            : Color(0xFF6F6C7A),
                        fontSize: 12),
                  ),
                ),
              ],
            ).setGestureDetector(
                onTap: () {
                  setState(() {
                    selectIndex = i;
                  });
                },
                behavior: HitTestBehavior.opaque),
          );
        }).setSizedBox(height: 140, width: 600);
  }
}
