import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/Pair.dart';
import 'package:wobei/bean/RightClassData.dart';
import 'package:wobei/bean/RightSubPageData.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/EventBus.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/widget/BlackButton.dart';
import 'package:wobei/widget/TitleBar.dart';
import 'package:wobei/widget/right_item/RightItem.dart';

import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 权益分类页
///
///********************************************************************************************
class RightClassPage extends StatefulWidget {
  static const BUS_TAG = 'RightClassPage';

  static const ADD_CLASS_ID = 'add_class_id';

  static const REMOVE_CLASS_ID = 'remove_class_id';

  @override
  _RightClassPageState createState() => _RightClassPageState();
}

class _RightClassPageState extends State<RightClassPage> with BaseUtils {
  final _controller = PageController(initialPage: 0, keepPage: true);

  List<RightClassData> classList = [];

  /// 存放用户选择的分类ID
  List<int> idList = [];

  var leftSelectedId = 0;

  var isRightListVisible = false;

  List<Result> rightList = [];

  var pageNum = 1;

  var totalPageNum = 1;

  @override
  void initState() {
    super.initState();
    bus.on(RightClassPage.BUS_TAG, (arg) {
      Pair pair = arg;
      switch (pair.first) {
        case RightClassPage.ADD_CLASS_ID:
          setState(() {
            idList.add(pair.second);
          });
          break;
        case RightClassPage.REMOVE_CLASS_ID:
          setState(() {
            idList.remove(pair.second);
          });
          break;
      }
    });

    Req.getRightClassList((List<RightClassData> data, String jsonStr) {
      setState(() {
        leftSelectedId = data[0].id;
        for (var i = 0; i < data.length; i++) {
          data[i].index = i;
        }
        classList = data;
      });
    }, level: '2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              TitleBar(
                title: '权益分类',
              ),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                    isRightListVisible ? Config.FOLD : Config.UNFOLD),
                padding: EdgeInsets.only(left: 20, top: getStatusBarHeight()+2),
                margin: EdgeInsets.only(left: 80),
              ).setGestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (idList.length != 0) {
                      setState(() {
                        isRightListVisible = !isRightListVisible;
                      });
                    }
                  })
            ],
          ).setSizedBox(height: 44 + getStatusBarHeight()),
          Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 140,
                        color: Color(0xFFF5F7FA),
                        child: Column(
                          children: classList
                              .map((e) => Container(
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          child: Container(
                                            width: 140,
                                            height: 50,
                                            padding: EdgeInsets.only(left: 20),
                                            alignment: Alignment(-1, 0),
                                            child: e.name.text(
                                                (leftSelectedId == e.id
                                                    ? Config.RED_B3926F
                                                    : Config.BLACK_303133),
                                                16),
                                            color: leftSelectedId == e.id
                                                ? Colors.white
                                                : Colors.transparent,
                                          ),
                                        ),
                                        Positioned(
                                          left: leftSelectedId == e.id ? 0 : 20,
                                          bottom: 0,
                                          right: 0,
                                          child: Divider(
                                            height: 1,
                                            color: Color(0xFFDCDFE6),
                                          ),
                                        )
                                      ],
                                    ),
                                    width: 140,
                                    height: 50,
                                  ).setGestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        setState(() {
                                          leftSelectedId = e.id;
                                        });
                                        _controller.jumpToPage(e.index);
                                      }))
                              .toList(),
                        ),
                      ),
                      Container(
                        width: 1,
                        child: PageView(
                          controller: _controller,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          children: classList
                              .map((e) => RightClassSubPage(
                                    list: e.nextLevelVO,
                                  ))
                              .toList(),
                        ),
                      ).setExpanded(1)
                    ],
                  ).setExpanded(1),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        BlackButton(
                          text: '重置',
                          isStroke: true,
                          onClickListener: () {
                            bus.emit(
                                RightClassSubPage.BUS_TAG,
                                Pair(
                                    first: RightClassSubPage.RESET,
                                    second: true));
                          },
                        ).setExpanded(1),
                        SizedBox(
                          width: 20,
                        ),
                        BlackButton(
                          text: '确认',
                          isGrey: idList.length == 0,
                          onClickListener: () {
                            Req.getRightClassFilteredPage(idList,
                                (RightSubPageData data) {
                              setState(() {
                                totalPageNum = data.totalPageNum;
                                rightList = data.results;
                                isRightListVisible = true;
                              });
                            });
                          },
                        ).setExpanded(1),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              getRightFilteredList(rightList).setVisible2(isRightListVisible)
            ],
          ).setExpanded(1)
        ],
      ),
    );
  }

  final ctrlRefresh = RefreshController(initialRefresh: false);

  Widget getRightFilteredList(List<Result> rightList) {
    return Container(
      color: Colors.white,
      height: context.getSrnH() - getStatusBarHeight(),
      child: SmartRefresher(
        controller: ctrlRefresh,
        enablePullUp: true,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        child: ListView.builder(
            shrinkWrap: true, //自适应高度
            itemCount: rightList.length == 0 ? 1 : rightList.length,
            itemBuilder: (ctx, i) {
              if (rightList.length == 0) {
                return Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 100),
                  child: Text(
                    '暂无权益，下拉刷新试试',
                    style: TextStyle(fontSize: 18, color: Config.GREY_909399),
                  ),
                );
              }
              if (rightList[i].payWay == 2) {
                return RightItem(
                    imgUrl: rightList[i].logo,
                    title: rightList[i].name,
                    isHeCaZhuanShu: rightList[i].vipId == '1',
                    isFreePrice: true,
                    id: rightList[i].id);
              } else {
                if (rightList[i].vipPrice.toDouble() == 0.0) {
                  return RightItem(
                      imgUrl: rightList[i].logo,
                      title: rightList[i].name,
                      isHeCaZhuanShu: rightList[i].vipId == '1',
                      leftPrice: rightList[i].price,
                      isRightPriceVisible: false,
                      isLeftPriceRed: false,
                      id: rightList[i].id);
                } else {
                  if (rightList[i].vipId == '0') {
                    return RightItem(
                        imgUrl: rightList[i].logo,
                        title: rightList[i].name,
                        isHeCaZhuanShu: rightList[i].vipId == '1',
                        leftPrice: rightList[i].vipPrice,
                        rightPrice: rightList[i].price,
                        id: rightList[i].id);
                  } else {
                    if (rightList[i].vipType == 1)
                      return RightItem(
                          imgUrl: rightList[i].logo,
                          title: rightList[i].name,
                          isHeCaZhuanShu: rightList[i].vipId == '1',
                          leftPrice: rightList[i].vipPrice,
                          rightPrice: rightList[i].price,
                          isLeftPriceRed: false,
                          isRightPriceDelete: true,
                          id: rightList[i].id);
                    else {
                      return RightItem(
                          imgUrl: rightList[i].logo,
                          title: rightList[i].name,
                          isHeCaZhuanShu: rightList[i].vipId == '1',
                          leftPrice: rightList[i].price,
                          isRightPriceVisible: false,
                          isLeftPriceRed: false,
                          id: rightList[i].id);
                    }
                  }
                }
              }
            }),
      ),
    );
  }

  void _onLoading() {
    if (pageNum + 1 >= totalPageNum) {
      ctrlRefresh.loadComplete();
    } else {
      pageNum++;
      Req.getRightClassFilteredPage(idList, (RightSubPageData data) {
        setState(() {
          rightList = data.results;
          isRightListVisible = true;
        });
        ctrlRefresh.loadComplete();
      }, pageNum: pageNum);
    }
  }

  void _onRefresh() {
    pageNum = 1;
    Req.getRightClassFilteredPage(idList, (RightSubPageData data) {
      setState(() {
        rightList = data.results;
        isRightListVisible = true;
      });
      ctrlRefresh.refreshCompleted();
    }, pageNum: pageNum);
  }
}

class RightClassSubPage extends StatefulWidget {
  static const BUS_TAG = 'RightClassSubPage';

  static const RESET = 'reset';

  static const CONFIRM = 'confirm';

  final List<NextLevelVO> list;

  RightClassSubPage({this.list});

  @override
  _RightClassSubPageState createState() => _RightClassSubPageState();
}

class _RightClassSubPageState extends State<RightClassSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    bus.on(RightClassSubPage.BUS_TAG, (arg) {
      Pair pair = arg;
      switch (pair.first) {
        case RightClassSubPage.RESET:
          setState(() {
            widget.list.forEach((element) {
              element.isSelected = false;
            });
          });
          break;
        case RightClassSubPage.CONFIRM:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        children: widget.list
            .map((e) => Container(
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: e.name.text(Config.BLACK_303133, 16),
                        alignment: Alignment(-1, 0),
                        margin: EdgeInsets.only(left: 20),
                      ),
                      Positioned(
                        child: e.isSelected
                            ? Image.asset(
                                Config.CHECK_BLACK_BG,
                                width: 18,
                                height: 18,
                              )
                            : Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xFFffdcdfe6)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2))),
                              ),
                        right: 20,
                        top: 16,
                      ),
                      Positioned(
                        child: Divider(
                          height: 1,
                          color: Color(0xFFDCDFE6),
                        ),
                        left: 20,
                        bottom: 0,
                        right: 0,
                      )
                    ],
                  ),
                ).setGestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        e.isSelected = !e.isSelected;
                        if (e.isSelected) {
                          bus.emit(
                              RightClassPage.BUS_TAG,
                              Pair(
                                  first: RightClassPage.ADD_CLASS_ID,
                                  second: e.id));
                        } else {
                          bus.emit(
                              RightClassPage.BUS_TAG,
                              Pair(
                                  first: RightClassPage.REMOVE_CLASS_ID,
                                  second: e.id));
                        }
                      });
                    }))
            .toList(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
