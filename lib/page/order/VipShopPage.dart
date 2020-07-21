import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/CategoryData.dart';
import 'package:wobei/bean/ProductPageData.dart';
import 'package:wobei/bean/RightClassData.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/my_lib/utils/FileUtils.dart';
import 'package:wobei/widget/MyIndicator.dart';
import 'package:wobei/widget/MyTab.dart';
import 'package:wobei/widget/ProductItem.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 会员商城
///
///********************************************************************************************
class VipShopPage extends StatefulWidget {
  final int categoryId;

  VipShopPage({this.categoryId = -1});

  @override
  _VipShopPageState createState() => _VipShopPageState();
}

class _VipShopPageState extends State<VipShopPage>
    with BaseUtils, SingleTickerProviderStateMixin {
  TabController _controller;
  TextStyle selectStyle, unSelectStyle;
  int currentIndex = 0;
  double fontSize1 = 18.0;
  double fontSize2 = 16.0;

  List<CategoryData> dataList;

  List<MyTab> tabList = List.generate(
      Global.categoryNumber,
      (index) => MyTab(
            text: '',
          ));

  @override
  void initState() {
    super.initState();
    selectStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
    unSelectStyle = TextStyle(fontSize: 16);
    _controller = TabController(vsync: this, length: Global.categoryNumber);

    FileUtils.getStringFromTemp('cate_data.txt', (jsonStr) {
      List list = json.decode(jsonStr);
      dataList = list.map((data) => CategoryData.fromJson(data)).toList();
      setState(() {
        tabList = dataList
            .map((e) => MyTab(
                  text: e.name,
                ))
            .toList();
      });
      dataList.asMap().forEach((key, value) {
        if (value.id == widget.categoryId) {
          _controller.animateTo(key);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45 + 44.0),
        child: Container(
//          padding: EdgeInsets.only(top: getStatusBarHeight()),
          child: Column(
            children: <Widget>[
              TitleBar(
                title: '会员商城',
                needDivider: false,
                subTitle: '我的订单',
                subTitleClick: () {
                  if (Global.prefs.getString('token') != null) {
                    Global.routeLogin = AppRoute.MY_ORDER_PAGE;
                    Navigator.of(context).pushNamed(AppRoute.MY_ORDER_PAGE);
                  } else {
                    Navigator.of(context).pushNamed(AppRoute.LOGIN);
                  }
                },
              ),
              Row(
                children: <Widget>[
                  TabBar(
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(left: 12, right: 12),
                    controller: _controller,
                    indicator: MyTabIndicator(
                        borderSide:
                            BorderSide(width: 3, color: Config.RED_B3926F),
                        indicatorWidth: 18,
                        paddingBottom: 3),
                    labelStyle: selectStyle,
                    unselectedLabelStyle: unSelectStyle,
                    labelColor: Color(0xff393649),
                    unselectedLabelColor: Color(0xffA5A3AC),
                    tabs: tabList,
                  ).setExpanded(1),
                  Container(
                    width: 54,
                    alignment: Alignment.center,
                    child: Image.asset(
                      Config.CLASSIFICATION,
                      width: 24,
                      height: 24,
                    ),
                  ).setVisible2(false)
                ],
              ).setSizedBox(
                height: 44,
              ),
              Divider(
                height: 1,
                color: Config.DIVIDER_COLOR,
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _controller,
        children: dataList == null
            ? List.generate(Global.categoryNumber, (index) => SizedBox())
            : dataList
                .map((e) => VipShopSubPage(
                      categoryId: e.id,
                    ))
                .toList(),
      ),
    );
  }
}

class VipShopSubPage extends StatefulWidget {
  final int categoryId;

  VipShopSubPage({this.categoryId});

  @override
  _VipShopSubPageState createState() => _VipShopSubPageState();
}

class _VipShopSubPageState extends State<VipShopSubPage>
    with AutomaticKeepAliveClientMixin {
  List<Result> list = [];

  final ctrlRefresh = RefreshController(initialRefresh: false);

  var pageNum = 1;

  var totalPageNum = 1;

  @override
  void initState() {
    super.initState();
    FileUtils.getStringFromTemp('VipShopSubPage-${widget.categoryId}.txt',
        (jsonStr) {
      ProductPageData data = ProductPageData.fromJson(json.decode(jsonStr));
      setState(() {
        list = data.results;
      });
    });
    reqData();
  }

  void reqData({Function callback}) {
    Req.getVipShopPage(widget.categoryId,
        (ProductPageData data, String jsonStr) {
      totalPageNum = data.totalPageNum;
      if (callback != null) callback();
      setState(() {
        if (pageNum == 1) {
          list = data.results;
        } else {
          list.addAll(data.results);
        }
      });
      if (pageNum == 1) {
        FileUtils.writeFileToTemp(
            context, 'VipShopSubPage-${widget.categoryId}.txt', jsonStr);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Color(0xfff5f5f5),
      child: SmartRefresher(
        controller: ctrlRefresh,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              return Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: ProductItem(
                  productTitle: list[i].name,
                  vipPrice: list[i].vipPrice.toString(),
                  originPrice: list[i].price.toString(),
                  imgUrl: list[i].logo,
                  onItemClick: () {
                    Navigator.of(context).pushNamed(
                        AppRoute.PRODUCT_DETAIL_PAGE,
                        arguments: list[i].id);
                  },
                ),
              );
            }),
      ),
    );
  }

  void _onRefresh() {
    pageNum = 1;
    reqData(callback: () {
      ctrlRefresh.refreshCompleted();
    });
  }

  void _onLoading() {
    if (pageNum == totalPageNum) {
      ctrlRefresh.loadComplete();
    } else {
      pageNum++;
      reqData(callback: () {
        ctrlRefresh.loadComplete();
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
