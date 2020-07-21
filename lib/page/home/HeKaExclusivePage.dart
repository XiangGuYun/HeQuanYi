import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/RightSubPageData.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/BaseState.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/utils/FileUtils.dart';
import 'package:wobei/widget/TitleBar.dart';
import 'package:wobei/widget/right_item/RightItem.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 禾卡专属页
///
///********************************************************************************************
class HeKaExclusivePage extends StatefulWidget {
  @override
  _HeKaExclusivePageState createState() => _HeKaExclusivePageState();
}

class _HeKaExclusivePageState extends BaseState<HeKaExclusivePage> {
  var pageNum = 1;
  var totalPageNum = 1;
  List<Result> list = [];

  var _ctrl = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    FileUtils.getStringFromTemp('HeKaExclusivePage.txt', (jsonStr) {
      RightSubPageData data = RightSubPageData.fromJson(json.decode(jsonStr));
      totalPageNum = data.totalPageNum;
      setState(() {
        list = data.results;
      });
    });
    reqData();
  }

  @override
  void dispose() {
    super.dispose();
    _ctrl.dispose();
  }

  void reqData([Function callback]) {
    Req.getHeKaExclusive((RightSubPageData data, String jsonStr) {
      if (callback != null) callback();
      totalPageNum = data.totalPageNum;
      setState(() {
        if (pageNum == 1) {
          list = data.results;
        } else {
          list.addAll(data.results);
        }
      });
      FileUtils.writeFileToTemp(context, 'HeKaExclusivePage.txt', jsonStr);
    }, pageNum);
  }

  void _onRefresh() {
    pageNum = 1;
    reqData(() {
      _ctrl.refreshCompleted();
    });
  }

  void _onLoading() {
    if (pageNum + 1 > totalPageNum) {
      _ctrl.loadComplete();
    } else {
      pageNum++;
      reqData(() {
        _ctrl.loadComplete();
      });
    }
  }

  @override
  Widget getContentPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: context.getSrnW(),
        height: context.getSrnH(),
        child: Column(
          children: <Widget>[
            TitleBar(
              title: '禾卡专属',
            ),
            Container(
              width: context.getSrnW(),
              height: context.getSrnH() - getStatusBarHeight() - 44,
              child: SmartRefresher(
                controller: _ctrl,
                enablePullUp: true,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                    shrinkWrap: true,
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
      ),
    );
  }
}
