import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/RightSubPageData.dart';
import 'package:wobei/bean/SearchWord.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/BaseState.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/utils/ToastUtils.dart';
import 'package:wobei/widget/EditText.dart';
import 'package:wobei/widget/MyWidget.dart';
import 'package:wobei/widget/right_item/RightItem.dart';

import '../../my_lib/extension/BaseExtension.dart';

///*****************************************************************************
///
/// 描述：搜索页
/// 作者：YeXudong
/// 创建时间：2020/7
///
///*****************************************************************************
class SearchPage extends StatefulWidget {
  final SearchWord arguments;

  SearchPage({this.arguments});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends BaseState<SearchPage> {
  /// 搜索推荐词列表
  List<String> wordList;

  var _ctrl = RefreshController(initialRefresh: false);

  String keyword = '';

  var pageNum = 1;

  var totalPageNum = 1;

  List<Result> list = [];

  bool showSearchResult = false;

  var emptyString = '';

  var textShow = '';

  @override
  void initState() {
    super.initState();
    wordList = myWidget.arguments.recommendWords;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void reqData([Function callback]) {
    startLoading();
    Req.search((RightSubPageData data) {
      stopLoading();
      setState(() {
        if (callback != null) callback();
        totalPageNum = data.totalPageNum;
        if (data.results.length == 0) {
          emptyString = '没有找到相匹配的内容';
        }
        if (pageNum == 1) {
          list = data.results;
        } else {
          list.addAll(data.results);
        }
      });
    },
        searchWord: keyword != '' ? keyword : myWidget.arguments.suggestWord,
        pageNum: pageNum);
  }

  void _onRefresh() {
    pageNum = 1;
    reqData(() {
      _ctrl.refreshCompleted();
    });
  }

  void _onLoading() {
    if (pageNum == totalPageNum) {
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
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: getStatusBarHeight(),
          ),
          Container(
            width: double.infinity,
            height: 44,
            padding: EdgeInsets.only(left: 20, right: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MyWidget.getBackArrow().setGestureDetector(onTap: () {
                  context.pop();
                }).setSizedBox(width: 34),
                Container(
                  width: 0,
                  height: 36,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                  decoration: BoxDecoration(
                      color: '#fff5f7fa'.color(),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Image.asset(
                          Config.SEARCH,
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                        ),
                        top: 0,
                        bottom: 0,
                      ),
                      Positioned(
                        bottom: 0,
                        child: EditText(
                          215,
                          hint: myWidget.arguments.suggestWord,
                          height: 24,
                          maxLength: 10,
                          margin: EdgeInsets.only(left: 38, top: 5),
                          padding: EdgeInsets.only(top: 5),
                          action: TextInputAction.search,
                          onChanged: (value) {
                            keyword = value;
                          },
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: textShow,
                                  selection:
                                      TextSelection.fromPosition(TextPosition(
                                    affinity: TextAffinity.downstream,
                                    offset: textShow.length,
                                  )))),
                          onSubmitted: (value) {
                            setState(() {
                              showSearchResult = true;
                            });
                            pageNum = 1;
                            reqData();
                          },
                        ),
                      )
                    ],
                  ).setSizedBox(height: 36),
                ).setExpanded(1),
                Text(
                  '搜索',
                  style: TextStyle(fontSize: 14, color: Color(0xff303133)),
                ).setCenter().setSizedBox(width: 68).setGestureDetector(
                    onTap: () {
                  setState(() {
                    showSearchResult = true;
                  });
                  pageNum = 1;
                  reqData();
                })
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '发现更多',
                    style: TextStyle(
                        fontSize: 16,
                        color: Config.BLACK_303133,
                        fontWeight: FontWeight.w500),
                  ).setMargin1(left: 20, top: 25, bottom: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: wordList.map((s) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Color(0xfff5f7fa),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 6, bottom: 6),
                        child: Text(
                          s,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff909399)),
                        ).setGestureDetector(onTap: () {
                          keyword = s;
                          setState(() {
                            textShow = s;
                            showSearchResult = true;
                          });
                          reqData();
                        }),
                      );
                    }).toList(),
                  ).setMargin1(left: 20)
                ],
              ),
              Container(
                color: Colors.white,
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
                              emptyString,
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
              ).setVisible2(showSearchResult)
            ],
          )
        ],
      ),
    );
  }
}
