import 'package:flutter/material.dart';
import 'package:wobei/bean/DealDetailData.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/enum/JumpType.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/widget/TitleBar.dart';

///********************************************************************************************
///
/// 交易详情页
///
///********************************************************************************************
class DealDetailPage extends StatefulWidget {
  /// 流水ID
  final int flowId;

  DealDetailPage({this.flowId});

  @override
  _DealDetailPageState createState() => _DealDetailPageState();
}

class _DealDetailPageState extends State<DealDetailPage> {
  /// 交易金额
  var money = '0';

  /// 交易时间
  var time = '';

  /// 交易结果
  var result = '';

  /// 交易类型
  var type = '';

  /// 交易单号
  var code = '';

  @override
  void initState() {
    super.initState();
    Req.getPacketDetail(widget.flowId.toString(), (DealDetailData data) {
      setState(() {
        money = data.flowType == 1 ? '+${data.money}' : '-${data.money}';
        time = data.timeView;
        result = data.result;
        type = data.content;
        code = data.orderId;
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
            TitleBar(title: '交易详情', needDivider: false,),
            SizedBox(height: 20,),
            Text('交易金额',
              style: TextStyle(fontSize: 14, color: Config.GREY_909399),),
            SizedBox(height: 10,),
            Text(money,
              style: TextStyle(fontSize: 32, color: Config.BLACK_303133),),
            Divider(height: 20,
              color: Config.DIVIDER_COLOR,
              indent: 20,
              endIndent: 20,),
            SizedBox(height: 10,),
            getItem('交易时间', time),
            getItem('交易结果', result),
            getItem('交易类型', type),
            getItem('交易单号', code),
          ],
        ),
      ),
    );
  }

  getItem(String left, String right) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Text(
            left, style: TextStyle(fontSize: 14, color: Config.GREY_909399),),
          Expanded(
            child: SizedBox(width: 1,),
            flex: 1,
          ),
          Text(
            right, style: TextStyle(fontSize: 14, color: Config.BLACK_303133),)
        ],
      ),
    );
  }
}
