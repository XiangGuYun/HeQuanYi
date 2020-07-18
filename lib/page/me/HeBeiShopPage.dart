import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wobei/bean/Banner.dart';
import 'package:wobei/bean/BannerData.dart';
import 'package:wobei/bean/ChangeCardListData.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/enum/JumpType.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/page/dialog/LingQianDuiHuanDialog.dart';
import 'package:wobei/plugin/LogPlugin.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 禾贝商城页
///
///********************************************************************************************
class HeBeiShopPage extends StatefulWidget {
  @override
  _HeBeiShopPageState createState() => _HeBeiShopPageState();
}

class _HeBeiShopPageState extends State<HeBeiShopPage> with BaseUtils {
  /// 轮播图列表
  List<BannerData> bannerList = [];

  /// 禾贝余额
  var valueHeBeiBalance = 0;

  /// 零钱对话卡列表
  List<Result> cardList = [];

  /// 倒计时的时
  var _hh = '00';

  /// 倒计时的分
  var _mm = '00';

  /// 倒计时的秒
  var _ss = '00';

  Timer _timer;

  @override
  void initState() {
    super.initState();
    renderBanner();
    Req.getHeBeiBalance((total) {
      setState(() {
        valueHeBeiBalance = total;
      });
    });
    Req.getChangeCardList((ChangeCardListData data) {
      startCountDown(data.countdown);
      setState(() {
        cardList = data.cardAppVos.results;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(
                  top: 44 + getStatusBarHeight(),
                ),
                child: Column(
                  children: <Widget>[
                    getBanner(),
                    getCurrentHeBei(),
                    getLingQianDuiHuaKaBar(),
                    SizedBox(
                      height: 10,
                    ),
                    getLingQianList()
                  ],
                ),
              ),
            ),
            Container(
              child: TitleBar(
                title: '禾贝商城',
              ),
            )
          ],
        ));
  }

  ///---------------------------------------------------------------------------
  /// 设置轮播图
  ///---------------------------------------------------------------------------
  getBanner() {
    return Container(
      child: Swiper(
        key: UniqueKey(),
        itemBuilder: (BuildContext context, int index) {
          return FadeInImage.assetNetwork(
            placeholder: Config.BANNER_COVER,
            image: bannerList[index].url,
            fit: BoxFit.cover,
            fadeOutDuration: Duration(milliseconds: 10),
            fadeInDuration: Duration(milliseconds: 300),
            width: context.getSrnW() - 40,
            height: 167.5,
          );
        },
        itemCount: bannerList.length,
        pagination: SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig config) {
          print(config.activeIndex); //当前显示的索引值
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                bottom: 7,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 20,
                      height: 2,
                      color: config.activeIndex == 0
                          ? Colors.white
                          : Color(0x4dffffff),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 20,
                      height: 2,
                      color: config.activeIndex == 1
                          ? Colors.white
                          : Color(0x4dffffff),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 20,
                      height: 2,
                      color: config.activeIndex == 2
                          ? Colors.white
                          : Color(0x4dffffff),
                    )
                  ],
                ),
              )
            ],
          );
        }),
        control: null,
        loop: true,
        //是否循环
        autoplay: true,
        autoplayDelay: 3000,
      ).setClipRRect(4),
      width: double.infinity,
      height: 168,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
    );
  }

  getCurrentHeBei() {
    return Container(
      width: double.infinity,
      height: 90,
      margin: EdgeInsets.only(top: 15, left: 20, right: 20),
      child: Stack(
        children: <Widget>[
          Image.asset(
            Config.HEBEI_BG,
            width: double.infinity,
            height: 90,
            fit: BoxFit.cover,
          ).setClipRRect(5),
          Positioned(
            left: 20,
            top: 15,
            child: Text(
              '当前禾贝',
              style: TextStyle(fontSize: 12, color: Config.GREY_909399),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 15,
            child: Text(
              valueHeBeiBalance.toString(),
              style: TextStyle(
                  fontSize: 32,
                  color: Config.BLACK_303133,
                  fontFamily: 'money'),
            ),
          ),
          Positioned(
            right: 20,
            top: 31,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: Color(0xffE4E7ED),
              ),
              child: Text(
                '查看明细',
                style: TextStyle(fontSize: 12, color: Color(0xff606266)),
              ),
              width: 74,
              height: 28,
              alignment: Alignment.center,
            ).setGestureDetector(onTap: () {
              Navigator.of(context).pushNamed(AppRoute.DEAL_RECORD_PAGE,
                  arguments: JumpFrom.HEBEI_SHOP);
            }),
          ),
        ],
      ),
    );
  }

  getLingQianDuiHuaKaBar() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      width: double.infinity,
      height: 40,
      child: Row(
        children: <Widget>[
          Text(
            '零钱兑换卡 每日限领',
            style: TextStyle(fontSize: 18, color: Config.BLACK_303133),
          ),
          SizedBox(
            width: 1,
          ).setExpanded(1),
          Text(
            '距更新',
            style: TextStyle(fontSize: 12, color: Config.GREY_909399),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            decoration: BoxDecoration(
                color: Config.BLACK_303133,
                borderRadius: BorderRadius.all(Radius.circular(2))),
            width: 16,
            height: 16,
            alignment: Alignment.center,
            child: Text(
              _hh,
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            ':',
            style: TextStyle(fontSize: 11, color: Config.BLACK_303133),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            decoration: BoxDecoration(
                color: Config.BLACK_303133,
                borderRadius: BorderRadius.all(Radius.circular(2))),
            width: 16,
            height: 16,
            alignment: Alignment.center,
            child: Text(
              _mm,
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            ':',
            style: TextStyle(fontSize: 11, color: Config.BLACK_303133),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            decoration: BoxDecoration(
                color: Config.BLACK_303133,
                borderRadius: BorderRadius.all(Radius.circular(2))),
            width: 16,
            height: 16,
            alignment: Alignment.center,
            child: Text(
              _ss,
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  /// 渲染零钱兑换码列表
  ///---------------------------------------------------------------------------
  getLingQianList() {
    return Container(
      height: 320,
      margin: EdgeInsets.only(left: 20),
      child: GridView.builder(
          //屏蔽GridView内部滚动；
          physics: new NeverScrollableScrollPhysics(),
          itemCount: cardList.length,
          padding: EdgeInsets.only(top: 0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (context.getSrnW() - 20) / 2 / 150,
            crossAxisSpacing: 0,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Container(
                width: (context.getSrnW() - 20) / 2,
                height: 150,
                padding: EdgeInsets.only(right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      Config.CHANGE_COVER,
                      width: (context.getSrnW() - 20) / 2 - 20,
                      fit: BoxFit.cover,
                    ).setClipRRect(5).setAspectRatio(1.67),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      cardList[index].name,
                      style:
                          TextStyle(fontSize: 14, color: Config.BLACK_303133),
                    ),
                    Text(
                      cardList[index].score.toString() + '禾贝',
                      style: TextStyle(fontSize: 12, color: Color(0xffff2626)),
                    ),
                  ],
                ),
              ),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                LingQianDuiHuanDialog(
                  result: cardList[index],
                  rightBtnClick: () {
                    Req.viewCertificateInfo((certStatus, payPwdStatus) {
                      if (payPwdStatus == 2) {
                        Navigator.of(context)
                            .pushNamed(AppRoute.SET_PAY_PWD_PAGE);
                      } else {
                        // todo 显示支付密码对话框
                      }
                    });
                  },
                ).show(context);
              },
            );
          }),
    );
  }

  ///---------------------------------------------------------------------------
  /// 渲染轮播图
  ///---------------------------------------------------------------------------
  void renderBanner() {
    Req.getBannerInfo(isHomePage: false).then((response) {
      var banner = HbBanner.fromJson(response.data);
      setState(() {
        bannerList.addAll(banner.data);
      });
    });
  }

  ///---------------------------------------------------------------------------
  /// 开始倒计时
  ///---------------------------------------------------------------------------
  void startCountDown(int countdown) {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _timer = timer;
      Future.delayed(Duration(milliseconds: 100)).then((e) {
        setState(() {
          _hh = (countdown / 3600000 < 10)
              ? '0${countdown / 3600000}'
              : (countdown ~/ 3600000).toString();
          _mm =
              formatDate(DateTime.fromMillisecondsSinceEpoch(countdown), [nn]);
          _ss =
              formatDate(DateTime.fromMillisecondsSinceEpoch(countdown), [ss]);
          LogPlugin.logD('test', _hh + " " + _mm + ' ' + _ss);
        });
      });
      countdown -= 1000;
      if (_hh == '00' && _mm == '00' && _ss == '00') {
        timer.cancel();
      }
    });
  }

//  private fun startCountDown(countdown: Long) {
//
//  var date = countdown
//  Thread {
//  while (true) {
//  runOnUiThread {
//  tvHH.text = if ((date / 3600000L) < 10) "0${(date / 3600000L)}" else (date / 3600000L).s
//  tvmm.text = date.fmtDate("mm")
//  tvss.text = date.fmtDate("ss")
//  }
//  Thread.sleep(1000)
//  date -= 1000
//  }
//  }.start()
//  }
}
