import 'package:flutter/material.dart';
import 'package:wobei/bean/RedPacketData.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/BaseState.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 红包与历史红包
///
///********************************************************************************************
class RedPacketPage extends StatefulWidget {
  /// 是否是历史红包页面
  final bool isHistory;

  RedPacketPage({this.isHistory = false});

  @override
  _RedPacketPageState createState() => _RedPacketPageState();
}

class _RedPacketPageState extends BaseState<RedPacketPage>{
  /// 是否有红包
  var haveRedPacket = true;

  List<Result> redPacketList = [];

  @override
  void initState() {
    super.initState();
    setStatusBarColor(true, Colors.transparent);
    startLoading();
    Req.getMyPacket(myWidget.isHistory, 1, (RedPacketData data){
      stopLoading();
      if(data.results.length == 0){
        setState(() {
          haveRedPacket = false;
        });
      } else {
        setState(() {
          haveRedPacket = true;
          redPacketList.addAll(data.results);
        });
      }
    });
  }

  @override
  Widget getContentPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: <Widget>[
            getRedPacketList(),
            getEmptyPage(),
            TitleBar(
              title: myWidget.isHistory ? '历史红包' : '我的红包',
              subTitle: myWidget.isHistory ? '' : '历史红包',
              subTitleClick: () {
                Navigator.of(context)
                    .pushNamed(AppRoute.RED_PACKET_PAGE, arguments: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  getRedPacketList() {
    return Opacity(
      opacity: myWidget.isHistory ? 0.6 : 1.0,
      child: Container(
        width: context.getSrnW(),
        height: context.getSrnH(),
        margin: EdgeInsets.only(top: 44 + getStatusBarHeight()),
        child: ListView.builder(
            itemCount: redPacketList.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (ctx, i) {
              return Container(
                height: 90,
                width: context.getSrnW() - 40,
                margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: i == 0 ? 0 : 20,
                    bottom: i == 9 ? 20 : 0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF303133), Color(0xFF606266)]),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 15),
                      alignment: Alignment.topLeft,
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: '¥',
                            style: TextStyle(
                                fontSize: 14, color: Config.GOLD_FFE2C0)),
                        TextSpan(
                            text: redPacketList[i].price.toString().replaceAll('.00', '').replaceAll('.\0', ''),
                            style: TextStyle(
                                fontSize: 32, color: Config.GOLD_FFE2C0)),
                      ])),
                    ),
                    Positioned(
                      child: redPacketList[i].welfareDesc.text('#909399'.color(), 10),
                      bottom: 20,
                      left: 20,
                    ),
                    Positioned(
                      child: redPacketList[i].name.text(Colors.white, 16),
                      top: 20,
                      left: 120,
                    ),
                    Positioned(
                      child: '有效期至 ${redPacketList[i].dueTime}'.text(Config.GREY_909399, 10),
                      bottom: 20,
                      left: 120,
                    ),
                    Positioned(
                      child: Image.asset(
                        redPacketList[i].state==2?Config.OVERDUE:Config.USED,
                        width: 60,
                        height: 60,
                      ).setVisible2(myWidget.isHistory),
                      top: 15,
                      bottom: 15,
                      right: 20,
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  getEmptyPage() {
    return Container(
      width: context.getSrnW(),
      height: context.getSrnH(),
      color: Colors.white,
      margin: EdgeInsets.only(top: 44 + getStatusBarHeight()),
      padding: EdgeInsets.only(top: 160),
      alignment: Alignment.topCenter,
      child: (myWidget.isHistory ? '暂无历史红包' : '暂无可用的红包')
          .text(Config.GREY_C0C4CC, 22),
    ).setVisible2(!haveRedPacket);
  }

  @override
  void dispose() {
    super.dispose();
    if(!myWidget.isHistory)
    setStatusBarColor(false, Colors.transparent);
  }

}
