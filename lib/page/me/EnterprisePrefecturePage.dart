import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/EnterprisePrefectureHomePageData.dart';
import 'package:wobei/bean/EnterprisePrefecturePageData.dart';
import 'package:wobei/bean/Pair.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/BaseState.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/widget/MyIndicator.dart';
import 'package:wobei/widget/MyTab.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 企业专区页
///
///********************************************************************************************
class EnterprisePrefecturePage extends StatefulWidget {
  final Pair info;

  EnterprisePrefecturePage({this.info});

  @override
  _EnterprisePrefecturePageState createState() =>
      _EnterprisePrefecturePageState();
}

class _EnterprisePrefecturePageState extends BaseState<EnterprisePrefecturePage>
    with SingleTickerProviderStateMixin, BaseUtils {
  int selectedIndex = 0;

  List<Label> labelList = [];

  bool showPageView = false;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(true, Colors.transparent);
    Req.getEnterprisePrefectureHomePage(myWidget.info.second as int,
        (EnterprisePrefectureHomePageData data) {
      _pageController = PageController(keepPage: true, initialPage: 0);
      setState(() {
        labelList = data.labelList;
        showPageView = true;
      });
    });
  }

  @override
  Widget getContentPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          TitleBar(
            title: '企业专区',
          ),
          Container(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    //去掉回退箭头
                    pinned: false,
                    // 不设置最小高度
                    elevation: 0,
                    expandedHeight: 140,
                    // 这个高度决定扩展的最大高度
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Image.asset(
                                  Config.OVAL,
                                  fit: BoxFit.cover,
                                  height: 90,
                                ).setClipRRect(5),
                                Container(
                                  height: 90,
                                  child: myWidget.info.first
                                      .text(Colors.white, 18),
                                  alignment: Alignment.center,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ).setExpanded(1),
                            Text(
                              '企业优选商品',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Config.BLACK_303133,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 12, bottom: 16),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: StickyTabBarDelegate(
                      child: Container(
                        child: ListView.builder(
                            itemCount: labelList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              return Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                alignment: Alignment.center,
                                height: 30,
                                child: Text(
                                  labelList[i].labelName,
                                  style: TextStyle(
                                      color: i == selectedIndex
                                          ? Colors.white
                                          : Config.BLACK_303133,
                                      fontSize: 12),
                                ),
                                margin: EdgeInsets.only(left: i == 0 ? 20 : 12),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                    color: i == selectedIndex
                                        ? Config.BLACK_303133
                                        : Color(0xFFF5F5F5)),
                              ).setGestureDetector(onTap: () {
                                setState(() {
                                  selectedIndex = i;
                                  _pageController.jumpToPage(i);
                                });
                              });
                            }),
                        height: 40,
                        padding: EdgeInsets.only(top: 5, right: 5),
                      ),
                    ),
                  ),
                  SliverFillRemaining(child: getTabView()),
                ],
              ),
              width: context.getSrnW(),
              height: context.getSrnH() - 44 - getStatusBarHeight())
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(false, Colors.transparent);
  }

  Widget getTabView() {
    if (showPageView) {
      return PageView.builder(
          itemCount: labelList.length,
          scrollDirection: Axis.horizontal,
          //禁止左右滑动
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {},
          controller: _pageController,
          itemBuilder: (context, index) {
            return EnterprisePage(label: labelList[index]);
          });
    } else {
      return Center(
        child: Text(''),
      );
    }
  }
}

///********************************************************************************************
///
/// 企业专区分页
///
///********************************************************************************************
class EnterprisePage extends StatefulWidget {
  final Label label;

  EnterprisePage({this.label});

  @override
  _EnterprisePageState createState() => _EnterprisePageState();
}

class _EnterprisePageState extends State<EnterprisePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final _ctrl = RefreshController(initialRefresh: false);

  var pageNum = 1;

  var totalPageNum = 1;

  List<Result> list = [];

  @override
  void initState() {
    super.initState();
    redData();
  }

  void redData({Function callback = null}) {
    Req.getEnterprisePrefecturePage(widget.label.labelId, pageNum.toString(),
        (EnterprisePrefecturePageData data) {
      if(callback != null) callback();
      totalPageNum = data.totalPageNum;
      setState(() {
        list.addAll(data.results);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: SmartRefresher(
        enablePullUp: true,
        controller: _ctrl,
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              return Container(
                width: context.getSrnW(),
                height: 122,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: CachedNetworkImage(
                        imageUrl: list[i].logo,
                        width: 120,
                        height: 90,
                        placeholder: (ctx, url) => Image.asset(
                          Config.COVER_120_90,
                          width: 120,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                        errorWidget: (ctx, url, err) => Image.asset(
                          Config.COVER_120_90,
                          width: 120,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ).setClipRRect(4),
                      left: 20,
                      top: 16,
                    ),
                    Positioned(
                      child: list[i].itemName.text(Config.BLACK_303133, 16),
                      top: 16,
                      left: 152,
                      right: 20,
                    ),
                    Positioned(
                      child: '企业特价: ${list[i].exclusivePrice.toString()}元'.text('#B3926F'.color(), 14),
                      left: 152,
                      bottom: 16,
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
