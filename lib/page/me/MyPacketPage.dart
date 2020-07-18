import 'package:flutter/material.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/enum/JumpType.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/widget/TitleBar.dart';

///********************************************************************************************
///
/// 我的钱包页
///
///********************************************************************************************
class MyPacketPage extends StatefulWidget {
  @override
  _MyPacketPageState createState() => _MyPacketPageState();
}

class _MyPacketPageState extends State<MyPacketPage> with BaseUtils{
  /// 钱包余额
  var packetBalance = '0';

  @override
  void initState() {
    super.initState();
    if(Global.isDarkText){
      setStatusBarColor(false, Colors.transparent);
    }
    Req.getPacketBalance((value){
      setState(() {
        packetBalance = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset(
                  Config.WALLET_BG,
                  width: double.infinity,
                  height: 213,
                  fit: BoxFit.cover,
                ),
                TitleBar(
                  title: '我的钱包',
                  isTransparant: true,
                  needDivider: false,
                ),
                Positioned(
                  left: 20,
                  bottom: 85,
                  child: Text(
                    '零钱余额(元)',
                    style: TextStyle(fontSize: 14, color: Config.GREY_C0C4CC),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 25,
                  child: Text(
                    packetBalance,
                    style: TextStyle(
                        fontSize: 48, color: Colors.white, fontFamily: 'money'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
           GestureDetector(
             child:    Container(
               color: Colors.white,
               child:  Row(
                 children: <Widget>[
                   SizedBox(
                     width: 20,
                   ),
                   Image.asset(
                     Config.RECORD,
                     width: 20,
                     height: 20,
                     fit: BoxFit.fill,
                   ),
                   SizedBox(width: 10,),
                   Text(
                     '交易记录',
                     style: TextStyle(fontSize: 16, color: Config.BLACK_303133),
                   ),
                   Expanded(
                     child: SizedBox(width: 1,),
                     flex: 1,
                   ),
                   Image.asset(Config.DETAIL_LIGHT, width: 12, height: 12,),
                   SizedBox(width: 20,)
                 ],
               ),
               height: 60,
             ),
             onTap: (){
              Navigator.of(context).pushNamed(AppRoute.DEAL_RECORD_PAGE, arguments: JumpFrom.MY_PACKET);
             },
           ),
            Divider(height: 1, color: Config.DIVIDER_COLOR, indent: 20, endIndent: 20,)
          ],
        ),
      ),
    );
  }
}
