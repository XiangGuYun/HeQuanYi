import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frame_animate_widget/frame_animate_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/MyCardData.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/BaseState.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/page/me/MyHistoryCardTicketPage.dart';
import 'package:wobei/widget/TitleBar.dart';

import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 我的卡券页
///
///********************************************************************************************
class MyCardTicketPage extends StatefulWidget {
  final bool isOverdue;

  MyCardTicketPage({this.isOverdue});

  @override
  _MyCardTicketPageState createState() => _MyCardTicketPageState();
}

class _MyCardTicketPageState extends BaseState<MyCardTicketPage>
    with BaseUtils {
  final _refreshController = RefreshController(initialRefresh: false);

  var pageNum = 1;
  var totalPageNum = 1;
  List<Result> list = [];
  bool isOverdue;

  @override
  void initState() {
    super.initState();
    isOverdue = (widget as MyCardTicketPage).isOverdue;
    setStatusBarColor(true, Colors.transparent);
    reqMyCardList();
  }

  ///---------------------------------------------------------------------------
  /// FooterView
  ///---------------------------------------------------------------------------
  getBottomWidget(bool isLast) {
    if (!isLast) {
      return SizedBox(
        height: 0,
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 40, bottom: 40),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 1,
            ).setExpanded(1),
            '发现更多权益卡'.text(Config.GREY_909399, 14),
            Image.asset(
              Config.DETAIL_LIGHT,
              width: 12,
              height: 12,
            ).setCenter(),
            SizedBox(
              width: 1,
            ).setExpanded(1),
          ],
        ),
      );
    }
  }

  ///---------------------------------------------------------------------------
  /// 下拉刷新
  ///---------------------------------------------------------------------------
  void _refresh() {
    pageNum == 0;
    reqMyCardList(callback: () {
      _refreshController.refreshCompleted();
    });
  }

  ///---------------------------------------------------------------------------
  /// 上拉加载
  ///---------------------------------------------------------------------------
  void _loading() {
    if (pageNum + 1 > totalPageNum) {
      _refreshController.loadComplete();
    } else {
      pageNum++;
      reqMyCardList(callback: () {
        _refreshController.loadComplete();
      });
    }
  }

  @override
  Widget getContentPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 44 + getStatusBarHeight()),
              width: context.getSrnW(),
              height: context.getSrnH() - 44 - getStatusBarHeight(),
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: _refresh,
                onLoading: _loading,
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Positioned(
                                  child: CachedNetworkImage(
                                    colorBlendMode: BlendMode.color,
                                    color: isOverdue
                                        ? Colors.grey
                                        : Colors.transparent,
                                    imageUrl: list[i].logo,
                                    width: 120,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                      Config.COVER_120_90,
                                      width: 120,
                                      height: 90,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      Config.COVER_120_90,
                                      width: 120,
                                      height: 90,
                                    ),
                                  ).setClipRRect(4),
                                  left: 20,
                                  top: 16,
                                ),
                                Positioned(
                                  child: Divider(
                                    height: 1,
                                    color: Config.DIVIDER_COLOR,
                                  ),
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                ),
                                Positioned(
                                  child: list[i]
                                      .itemName
                                      .text(Config.BLACK_303133, 14),
                                  top: 16,
                                  left: 160,
                                  right: 20,
                                ),
                                Positioned(
                                  child: list[i].exchangEndTime.fmtDate([
                                    yyyy,
                                    '年',
                                    mm,
                                    '月',
                                    dd,
                                    '日'
                                  ]).text(Config.GREY_909399, 12),
                                  bottom: 16,
                                  left: 160,
                                  right: 20,
                                ),
                              ],
                            ).setSizedBox(height: 122),
                            // 如果有footerView，直接加上即可，但一定要指定普通列表项的高度
                            getBottomWidget(i == list.length - 1)
                          ],
                        ),
                      ).setGestureDetector(
                        onTap: (){
                          '556'.toast();
                          Navigator.of(context).pushNamed(AppRoute.CARD_TICKET_DETAIL_PAGE, arguments: list[i].id);
                        },
                        behavior: HitTestBehavior.opaque
                      );
                    }),
              ),
            ),
            TitleBar(
              title: '我的卡券包',
              subTitle: (isOverdue ? '' : '已过期'),
              subTitleClick: () {
                Navigator.of(context).pushNamed(AppRoute.MY_HISTORY_CARD_TICKET_PAGE);
              },
            )
          ],
        ),
      ),
    );
  }

  void reqMyCardList({Function callback = null}) {
    startLoading();
    Req.getMyCard((MyCardData data) {
      stopLoading();
      setState(() {
        if (pageNum == 0) {
          list = data.results;
        } else {
          list.addAll(data.results);
        }
      });
      if (callback != null) {
        callback();
      }
    }, pageNum: pageNum, isOverdue: isOverdue);
  }
}
