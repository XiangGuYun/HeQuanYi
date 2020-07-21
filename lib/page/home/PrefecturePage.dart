import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/RightSubPageData.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/my_lib/utils/FileUtils.dart';
import 'package:wobei/widget/TitleBar.dart';
import 'package:wobei/widget/right_item/RightItem.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 专区
///
///********************************************************************************************
class PrefecturePage extends StatefulWidget {
  final int areaId;

  PrefecturePage({this.areaId});

  @override
  _PrefecturePageState createState() => _PrefecturePageState();
}

class _PrefecturePageState extends State<PrefecturePage> with BaseUtils {
  final ctrlRefresh = RefreshController();

  var pageNum = 1;

  var totalPageNum = 1;

  List<Result> list = [];

  @override
  void initState() {
    super.initState();
    FileUtils.getStringFromTemp('PrefecturePage-${widget.areaId}.txt',
        (jsonStr) {
      RightSubPageData data = RightSubPageData.fromJson(json.decode(jsonStr));
      totalPageNum = data.totalPageNum;
      setState(() {
        list = data.results;
      });
    });
    reqData();
  }

  void reqData([Function callback]) {
    Req.getPrefecturePage(widget.areaId,
        (RightSubPageData data, String jsonStr) {
      if (callback != null) callback();
      totalPageNum = data.totalPageNum;
      setState(() {
        if (pageNum == 1) {
          list = data.results;
          FileUtils.writeFileToTemp(
              context, 'PrefecturePage-${widget.areaId}.txt', jsonStr);
        } else {
          list.addAll(data.results);
        }
      });
    }, pageNum: pageNum);
  }

  @override
  void dispose() {
    super.dispose();
    ctrlRefresh.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          TitleBar(
            title: '本地生活',
          ),
          Container(
            width: context.getSrnW(),
            height: context.getSrnH() - 44 - getStatusBarHeight(),
            child: SmartRefresher(
              enablePullUp: true,
              controller: ctrlRefresh,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                  itemCount: list.length == 0 ? 1 : list.length,
                  itemBuilder: (ctx, i) {
                    if (list.length == 0) {
                      return Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 100),
                        child: Text(
                          '暂无权益，下拉刷新试试',
                          style: TextStyle(
                              fontSize: 18, color: Config.GREY_909399),
                        ),
                      );
                    }
                    if (list[i].payWay == 2) {
                      return RightItem(
                          imgUrl: list[i].logo,
                          title: list[i].name,
                          isHeCaZhuanShu: list[i].vipId == '1',
                          isFreePrice: true,
                          id: list[i].id);
                    } else {
                      if (list[i].vipPrice.toDouble() == 0.0) {
                        return RightItem(
                            imgUrl: list[i].logo,
                            title: list[i].name,
                            isHeCaZhuanShu: list[i].vipId == '1',
                            leftPrice: list[i].price,
                            isRightPriceVisible: false,
                            isLeftPriceRed: false,
                            id: list[i].id);
                      } else {
                        if (list[i].vipId == '0') {
                          return RightItem(
                              imgUrl: list[i].logo,
                              title: list[i].name,
                              isHeCaZhuanShu: list[i].vipId == '1',
                              leftPrice: list[i].vipPrice,
                              rightPrice: list[i].price,
                              id: list[i].id);
                        } else {
                          if (list[i].vipType == 1)
                            return RightItem(
                                imgUrl: list[i].logo,
                                title: list[i].name,
                                isHeCaZhuanShu: list[i].vipId == '1',
                                leftPrice: list[i].vipPrice,
                                rightPrice: list[i].price,
                                isLeftPriceRed: false,
                                isRightPriceDelete: true,
                                id: list[i].id);
                          else {
                            return RightItem(
                                imgUrl: list[i].logo,
                                title: list[i].name,
                                isHeCaZhuanShu: list[i].vipId == '1',
                                leftPrice: list[i].price,
                                isRightPriceVisible: false,
                                isLeftPriceRed: false,
                                id: list[i].id);
                          }
                        }
                      }
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  void _onRefresh() {
    pageNum = 1;
    reqData(() {
      ctrlRefresh.refreshCompleted();
    });
  }

  void _onLoading() {
    if (pageNum == totalPageNum) {
      ctrlRefresh.loadComplete();
    } else {
      reqData(() {
        ctrlRefresh.loadComplete();
      });
    }
  }
}
