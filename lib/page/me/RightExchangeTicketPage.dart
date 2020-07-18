import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/ExchangeTicketsData.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/BaseState.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 权益兑换券
///
///********************************************************************************************
class RightExchangeTicketPage extends StatefulWidget {
  final bool isHistory;

  RightExchangeTicketPage({this.isHistory = false});

  @override
  _RightExchangeTicketPageState createState() =>
      _RightExchangeTicketPageState();
}

class _RightExchangeTicketPageState extends BaseState<RightExchangeTicketPage>
    with BaseUtils {
  /// 是否有权益兑换券
  var haveExchangeTicket = true;

  final _ctrl = RefreshController(initialRefresh: false);

  List<Result> list = [];

  var pageNum = 1;
  var totalPageNum = 1;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(true, Colors.transparent);
    startLoading();
    reqData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getRightExchangeTicketList() {
    return Container(
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: false,
        onLoading: _onLoading,
        controller: _ctrl,
        child: ListView.builder(
          itemBuilder: (ctx, i) {
            return Container(
              width: context.getSrnW() - 30,
              height: 100,
              margin:
                  EdgeInsets.only(left: 15, right: 15, top: i == 0 ? 0 : 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Image.asset(
                      Config.EXCHANGE,
                      width: 40,
                      height: 40,
                    ),
                    left: 20,
                    top: 20,
                  ),
                  Positioned(
                    child: '影视特权兑换券'.text(Config.BLACK_303133, 16),
                    left: 75,
                    top: 20,
                  ),
                  Positioned(
                    child: '限定影视特权列表权益兑换'.text(Config.GREY_909399, 12),
                    left: 75,
                    top: 45,
                  ),
                  Positioned(
                    child: '有效期至 2019.08.20'.text(Config.GREY_909399, 12),
                    bottom: 20,
                    left: 75,
                  ),
                  getRightWidget()
                ],
              ),
            );
          },
          itemCount: list.length,
        ),
      ),
      width: context.getSrnW(),
      height: context.getSrnH() - 44 - getStatusBarHeight(),
    ).setOpacity(myWidget.isHistory ? 0.6 : 1.0);
  }

  getRightWidget() {
    if (myWidget.isHistory) {
      return Positioned(
        right: 20,
        top: 20,
        child: Container(
          child: Image.asset(
            Config.OVERDUE,
            width: 60,
            height: 60,
          ),
          width: 60,
          height: 60,
          alignment: Alignment.center,
        ),
      );
    } else {
      return Positioned(
        right: 20,
        top: 36,
        child: Container(
          child: '兑换'.text(Config.BLACK_303133, 14),
          width: 66,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Config.BLACK_303133, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(14))),
        ),
      );
    }
  }

  getEmptyPage() {
    return Container(
      width: context.getSrnW(),
      height: context.getSrnH(),
      color: Colors.white,
      margin: EdgeInsets.only(top: 44 + getStatusBarHeight()),
      padding: EdgeInsets.only(top: 160),
      alignment: Alignment.topCenter,
      child: (myWidget.isHistory ? '暂无历史兑换券' : '暂无兑换券')
          .text(Config.GREY_C0C4CC, 22),
    ).setVisible2(!haveExchangeTicket);
  }

  @override
  Widget getContentPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              color: Color(0xfff5f5f5),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 44 + getStatusBarHeight(),
                  ),
                  getRightExchangeTicketList()
                ],
              ),
            ),
            getEmptyPage(),
            TitleBar(
              needTopMargin: false,
              title: myWidget.isHistory ? '历史兑换券' : '权益兑换券',
              subTitle: myWidget.isHistory ? '' : '历史',
              subTitleClick: () {
                Navigator.of(context)
                    .pushNamed(AppRoute.RIGHT_EXCHANGE_PAGE, arguments: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onLoading() {
    if (pageNum + 1 > totalPageNum) {
      _ctrl.loadComplete();
    } else {
      pageNum++;
      reqData(callback: () {
        _ctrl.loadComplete();
      });
    }
  }

  void reqData({Function callback = null}) {
    Req.getMyExchangeTickets(myWidget.isHistory, pageNum,
        (ExchangeTicketsData data) {
      if (callback != null) callback();
      totalPageNum = data.totalPageNum;
      stopLoading();
      if (data.results.length == 0) {
        setState(() {
          haveExchangeTicket = false;
        });
      } else {
        haveExchangeTicket = true;
        setState(() {
          list.addAll(data.results);
        });
      }
    });
  }
}
