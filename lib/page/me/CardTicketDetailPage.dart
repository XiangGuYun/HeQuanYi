import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wobei/bean/CardTicketDetailData.dart';
import 'package:wobei/bean/ChangeCardListData.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 卡券详情页
///
///********************************************************************************************
class CardTicketDetailPage extends StatefulWidget {
  /// 订单ID
  final int orderId;

  CardTicketDetailPage({this.orderId});

  @override
  _CardTicketDetailPageState createState() => _CardTicketDetailPageState();
}

class _CardTicketDetailPageState extends State<CardTicketDetailPage>
    with BaseUtils {
  final _controller = ScrollController();

  /// 是否是白色顶部
  var whiteTop = false;

  /// 卡券图片
  String logo =  '';
  /// 卡券名称
  String ticketName = '';
  /// 兑换码
  String exchangeCode = '';
  /// 有效期
  String validDate = '';
  /// 兑换方式
  String exchangeWay = '';
  /// 兑换说明
  String exchangeExplain = '';

  @override
  void initState() {
    super.initState();
    setStatusBarColor(false, Colors.transparent);
    _controller.addListener(() {
      print(_controller.offset); //打印滚动位置
      if (_controller.offset > 16 && !whiteTop) {
        setState(() {
          setStatusBarColor(true, Colors.transparent);
          whiteTop = true;
        });
      }
      if (_controller.offset <= 16 && whiteTop) {
        setState(() {
          setStatusBarColor(false, Colors.transparent);
          whiteTop = false;
        });
      }
    });

    Req.getCardDetail(widget.orderId, (CardTicketDetailData data){
      setState(() {
        logo = data.itemLogo;
        ticketName = data.itemName;
        exchangeCode = data.couponCode.maxLength(15);
        validDate = data.exchangEndTime.toString();//.fmtDate([yyyy,'年',mm,'月',dd,'日']);
        exchangeWay = data.exchangeWay;
        exchangeExplain = data.exchangeDesc;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: _controller,
              physics: BouncingScrollPhysics(),
              child:  Column(
                children: <Widget>[
                  Container(
                    width: context.getSrnW() - 32,
                    margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16+44+getStatusBarHeight()),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: getCardDetailWidget(),
                  ),
                ],
              ),
            ),
            Container(
              height: getStatusBarHeight(),
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 44),
            ).setVisible1(whiteTop),
            TitleBar(
              title: '卡券详情',
              isTransparant: whiteTop ? false : true,
              needDivider: whiteTop ? true : false,
            ),
          ],
        ),
        width: context.getSrnW(),
        height: context.getSrnH(),
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFFA8A5B2), Color(0xFF6F6C7A)]),
        ),
      ),
    );
  }

  getCardDetailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            getTicketImage(),
            Positioned(
              child: Text(
                ticketName,
                style: TextStyle(color: Color(0xff393649), fontSize: 16),
              ),
              left: 100,
              right: 0, // 此属性必须加，否则文字不会自动徽行
            ),
            Positioned(
              child: '有效期至 2019.09.30'.text(Color(0xFFA5A3AC), 12),
              left: 100,
              bottom: 0,
            )
          ],
        ).setSizedBox(width: double.infinity),
        SizedBox(
          height: 24,
        ),
        Divider(
          height: 1,
          color: Config.DIVIDER_COLOR,
        ),
        SizedBox(
          height: 24,
        ),
        '兑换码'.text(Config.BLACK_303133, 18),
        SizedBox(
          height: 16,
        ),
        Row(
          children: <Widget>[
            '19HSA3134JS19HS'.text(Color(0xFFA5A3AC), 16),
            SizedBox(
              width: 1,
            ).setExpanded(1),
            '复制并兑换'.text('#B3926F'.color(), 14).setGestureDetector(onTap: () {
              Clipboard.setData(ClipboardData(text: '19HSA3134JS19HS'));
              '已复制'.toast();
            })
          ],
        ),
        SizedBox(
          height: 24,
        ),
        Divider(
          height: 1,
          color: Config.DIVIDER_COLOR,
        ),
//        getRecentStores(),
        getExchangeWays(),
        getExchangeExplain(),
        getMyTicketPacket().setGestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(AppRoute.MY_CARD_TICKET_PAGE, arguments: false);
          },
          behavior: HitTestBehavior.opaque
        )
      ],
    );
  }

  ///---------------------------------------------------------------------------
  /// 最近门店
  ///---------------------------------------------------------------------------
  getRecentStores() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        '最近门店'.text('#393649'.color(), 18),
        SizedBox(
          height: 16,
        ),
        Row(
          children: <Widget>[
            '蜜桃皇后公园店'.text('#393649'.color(), 14),
            SizedBox(
              width: 1,
            ).setExpanded(1),
            '1.2km'.text('#A5A3AC'.color(), 12),
            SizedBox(
              width: 12,
            ),
            Image.asset(
              Config.MAP,
              width: 40,
              height: 40,
            )
          ],
        ).setSizedBox(height: 40),
        SizedBox(
          height: 24,
        ),
        Divider(
          height: 1,
          color: Config.DIVIDER_COLOR,
        )
      ],
    );
  }

  ///---------------------------------------------------------------------------
  /// 兑换方式
  ///---------------------------------------------------------------------------
  getExchangeWays() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        '兑换方式'.text('#393649'.color(), 18),
        SizedBox(
          height: 12,
        ),
        Text(
          '1. 点击下方【立即领取】，获取兑换码； \n2. 登录饿了么APP——点击【我的】——成为超级会员； \n3. 申请会员领红包——兑换会员——输入16位',
          style: TextStyle(color: Color(0xffa5a3ac), fontSize: 14),
          strutStyle: StrutStyle(forceStrutHeight: true, height: 1.6),
        ),
        SizedBox(
          height: 24,
        ),
        Divider(
          height: 1,
          color: Config.DIVIDER_COLOR,
        )
      ],
    );
  }

  ///---------------------------------------------------------------------------
  /// 兑换说明
  ///---------------------------------------------------------------------------
  getExchangeExplain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        '兑换说明'.text('#393649'.color(), 18),
        SizedBox(
          height: 12,
        ),
        Text(
          '1. 兑换码一经输入，仅限当前账号使用；\n2. 每位用户仅限领取一个兑换码；\n3. 兑换码领取有效期：即日起至2019年7月5日；',
          style: TextStyle(color: Color(0xffa5a3ac), fontSize: 14),
          strutStyle: StrutStyle(forceStrutHeight: true, height: 1.6),
        ),
        SizedBox(
          height: 24,
        ),
        Divider(
          height: 1,
          color: Config.DIVIDER_COLOR,
        )
      ],
    );
  }

  ///---------------------------------------------------------------------------
  /// 我的卡券包
  ///---------------------------------------------------------------------------
  Widget getMyTicketPacket() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        Row(
          children: <Widget>[
            '我的卡券包'.text('#393649'.color(), 18),
            SizedBox(
              width: 1,
            ).setExpanded(1),
            Image.asset(
              Config.DETAIL_LIGHT,
              width: 12,
              height: 12,
            )
          ],
        ),
        SizedBox(
          height: 48,
        )
      ],
    );
  }

  getTicketImage() {
    if(!logo.isEmpty){
      return CachedNetworkImage(
        imageUrl: logo,
        width: 88,
        height: 66,
        fit: BoxFit.cover,
        placeholder: (ctx, url) => Image.asset(Config.COVER_88_66, width: 88, height: 66,),
        errorWidget: (ctx, url, err) => Image.asset(Config.COVER_88_66, width: 88, height: 66,),
      );
    } else {
      return Image.asset(Config.COVER_88_66, width: 88, height: 66,);
    }
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(true, Colors.transparent);
  }
}
