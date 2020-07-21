import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/Pair.dart';
import 'package:wobei/bean/RightClassData.dart';
import 'package:wobei/bean/RightSubPageData.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/EventBus.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/my_lib/utils/FileUtils.dart';
import 'package:wobei/widget/MyIndicator.dart';
import 'package:wobei/widget/MyTab.dart';
import 'package:wobei/widget/right_item/RightItem.dart';

import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 权益界面
///
///********************************************************************************************
class RightPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RightPage>
    with SingleTickerProviderStateMixin, BaseUtils {
  TabController _controller;
  TextStyle selectStyle, unSelectStyle;
  int currentIndex = 0;
  double fontSize1 = 18.0;
  double fontSize2 = 16.0;

  List<RightClassData> dataList;

  var maskVisible = false;

  var prop = RightProp.ZUI_XIN;

  var currentIndexZX = 0;

  var currentIndexBXSX = 0;

  var currentIndexFJ = 0;

  var listZX = ['最新', '热门', '高价'];
  var listBXSX = ['不限属性', '通用权益', '其它'];
  var listFJ = ['附近', '<3公里', '<6公里'];

  ///当组件销毁时调用
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  List<MyTab> tabList = List.generate(
      Global.classNumber,
      (index) => MyTab(
            text: '',
          ));

  @override
  void initState() {
    super.initState();
    selectStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
    unSelectStyle = TextStyle(fontSize: 16);
    _controller = TabController(vsync: this, length: Global.classNumber);
    //监听Tab切换事件
    FileUtils.getStringFromTemp('right_class_data.txt', (s) {
      List list = json.decode(s);
      dataList = list.map((data) => RightClassData.fromJson(data)).toList();
      setState(() {
        tabList = dataList
            .map((e) => MyTab(
                  text: e.name,
                ))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(84.0),
      child: Container(
        padding: EdgeInsets.only(top: getStatusBarHeight()),
        child: Column(
          children: <Widget>[
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
                ).setGestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.of(context).pushNamed(AppRoute.RIGHT_CLASS_PAGE);
                    }
                )
              ],
            ).setSizedBox(
              height: 44,
            ),
            Row(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    listZX[currentIndexZX].text('#393649'.color(), 14),
                    SizedBox(
                      width: 4,
                    ),
                    Image.asset(
                      prop == RightProp.ZUI_XIN && maskVisible ? Config.FOLD : Config.UNFOLD,
                      width: 12,
                      height: 12,
                    )
                  ],
                ).setSizedBox(width: context.getSrnW()/3).setGestureDetector(onTap: () {
                  setState(() {
                    prop = RightProp.ZUI_XIN;
                    maskVisible = true;
                  });
                }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    listBXSX[currentIndexBXSX].text('#393649'.color(), 14),
                    SizedBox(
                      width: 4,
                    ),
                    Image.asset(
                      prop == RightProp.BU_XIAN_SHU_XING && maskVisible ? Config.FOLD : Config.UNFOLD,
                      width: 12,
                      height: 12,
                    )
                  ],
                ).setSizedBox(width: context.getSrnW()/3).setGestureDetector(onTap: () {
                  setState(() {
                    prop = RightProp.BU_XIAN_SHU_XING;
                    maskVisible = true;
                  });
                }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    listFJ[currentIndexFJ].text('#393649'.color(), 14),
                    SizedBox(
                      width: 4,
                    ),
                    Image.asset(
                      prop == RightProp.FU_JIN && maskVisible ? Config.FOLD : Config.UNFOLD,
                      width: 12,
                      height: 12,
                    )
                  ],
                ).setSizedBox(width: context.getSrnW()/3).setGestureDetector(onTap: () {
                  setState(() {
                    prop = RightProp.FU_JIN;
                    maskVisible = true;
                  });
                }),
              ],
            ).setSizedBox(height: 39),
            Divider(
              height: 1,
              color: Config.DIVIDER_COLOR,
            )
          ],
        ),
      ),
    ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          TabBarView(
            controller: _controller,
            children: dataList == null
                ? List.generate(Global.classNumber, (index) => SizedBox())
                : dataList
                    .map((e) => RightSubPage(
                          id: e.id,
                        ))
                    .toList(),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 170,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        getFirstProp(),
                      ],
                    ).setSizedBox(height: 50).setGestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (prop == RightProp.ZUI_XIN) {
                            setState(() {
                              currentIndexZX = 0;
                              maskVisible = false;
                            });
                            bus.emit('RightSubPage', Pair(first: 'refresh_right', second: '${getZX()}-${getBXSX()}-${getFJ()}'));
                          } else if (prop == RightProp.BU_XIAN_SHU_XING) {
                            setState(() {
                              currentIndexBXSX = 0;
                              maskVisible = false;
                            });
                            bus.emit('RightSubPage', Pair(first: 'refresh_right', second: '${getZX()}-${getBXSX()}-${getFJ()}'));
                          } else {
                            setState(() {
                              currentIndexFJ = 0;
                              maskVisible = false;
                            });
                            bus.emit('RightSubPage', Pair(first: 'refresh_right', second: '${getZX()}-${getBXSX()}-${getFJ()}'));
                          }
                        }),
                    Row(
                      children: <Widget>[
                        getSecondProp(),
                      ],
                    ).setSizedBox(height: 50).setGestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (prop == RightProp.ZUI_XIN) {
                            setState(() {
                              currentIndexZX = 1;
                              maskVisible = false;
                            });
                            bus.emit('RightSubPage', Pair(first: 'refresh_right', second: '${getZX()}-${getBXSX()}-${getFJ()}'));
                          } else if (prop == RightProp.BU_XIAN_SHU_XING) {
                            setState(() {
                              currentIndexBXSX = 1;
                              maskVisible = false;
                            });
                            bus.emit('RightSubPage', Pair(first: 'refresh_right', second: '${getZX()}-${getBXSX()}-${getFJ()}'));
                          } else {
                            setState(() {
                              currentIndexFJ = 1;
                              maskVisible = false;
                            });
                            bus.emit('RightSubPage', Pair(first: 'refresh_right', second: '${getZX()}-${getBXSX()}-${getFJ()}'));
                          }
                        }),
                    Row(
                      children: <Widget>[
                        getThirdProp(),
                      ],
                    ).setSizedBox(height: 50).setGestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (prop == RightProp.ZUI_XIN) {
                            setState(() {
                              currentIndexZX = 2;
                              maskVisible = false;
                            });
                            bus.emit('RightSubPage', Pair(first: 'refresh_right', second: '${getZX()}-${getBXSX()}-${getFJ()}'));
                          } else if (prop == RightProp.BU_XIAN_SHU_XING) {
                            setState(() {
                              currentIndexBXSX = 2;
                              maskVisible = false;
                            });
                            bus.emit('RightSubPage', Pair(first: 'refresh_right', second: '${getZX()}-${getBXSX()}-${getFJ()}'));
                          } else {
                            setState(() {
                              currentIndexFJ = 2;
                              maskVisible = false;
                            });
                            bus.emit('RightSubPage', Pair(first: 'refresh_right', second: '${getZX()}-${getBXSX()}-${getFJ()}'));
                          }
                        }),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ).setMargin1(left: 20, right: 20),
              ),
              Container(
                height:
                    context.getSrnH() - getStatusBarHeight() - 84 - 170 - 49,
                color: Color(0x99000000),
              ).setGestureDetector(onTap: () {
                setState(() {
                  maskVisible = false;
                });
              })
            ],
          ).setVisible2(maskVisible)
        ],
      ),
    );
  }

  Widget getFirstProp() {
    if (prop == RightProp.ZUI_XIN) {
      return '最新'.text(Config.BLACK_393649, 14);
    } else if (prop == RightProp.BU_XIAN_SHU_XING) {
      return '不限属性'.text(Config.BLACK_393649, 14);
    } else {
      return '附近'.text(Config.BLACK_393649, 14);
    }
  }

  getSecondProp() {
    if (prop == RightProp.ZUI_XIN) {
      return '热门'.text(Config.BLACK_393649, 14);
    } else if (prop == RightProp.BU_XIAN_SHU_XING) {
      return '通用权益'.text(Config.BLACK_393649, 14);
    } else {
      return '<3公里'.text(Config.BLACK_393649, 14);
    }
  }

  getThirdProp() {
    if (prop == RightProp.ZUI_XIN) {
      return '高价'.text(Config.BLACK_393649, 14);
    } else if (prop == RightProp.BU_XIAN_SHU_XING) {
      return '其它'.text(Config.BLACK_393649, 14);
    } else {
      return '<6公里'.text(Config.BLACK_393649, 14);
    }
  }

  String getZX(){
   switch(currentIndexZX){
     case 0:
       return '0';
       break;
     case 1:
       return '1';
       break;
     default:
       return '2';
       break;
   }
  }

  String getBXSX(){
    switch(currentIndexBXSX){
      case 0:
        return '';
        break;
      case 1:
        return '0';
        break;
      default:
        return '1';
        break;
    }
  }

  String getFJ() {
    switch(currentIndexFJ){
      case 0:
        return '0';
        break;
      case 1:
        return '3';
        break;
      default:
        return '6';
        break;
    }
  }
}

class RightSubPage extends StatefulWidget {
  final int id;

  RightSubPage({this.id = -1, Key key}) : super(key: key);

  @override
  _RightSubPageState createState() => _RightSubPageState();
}

class _RightSubPageState extends State<RightSubPage>
    with AutomaticKeepAliveClientMixin {
  List<Result> list = [];

  final _controller = RefreshController(initialRefresh: false);
  var pageNum = 1;
  var totalPageNum = 1;

  @override
  void initState() {
    super.initState();

    bus.on('RightSubPage', (arg) {
     Pair pair = arg;
     switch(pair.first){
       case 'refresh_right':
         pageNum = 1;
         Req.getRightSubPage(
             itemGroupLevelIds: widget.id.toString(),
             pageNum: pageNum,
             commonType: pair.second.toString().split('-')[0],
             typeId: pair.second.toString().split('-')[1],
             distanceType: pair.second.toString().split('-')[2],
             callback: (RightSubPageData data, String json) {
               totalPageNum = data.totalPageNum;
               setState(() {
                 if (pageNum == 1) {
                   list = data.results;
                 } else {
                   list.addAll(data.results);
                 }
               });
               FileUtils.writeFileToTemp(
                   context, 'RightSubPage-${widget.id}.txt', json);
             });
         break;
     }
    });

    FileUtils.getStringFromTemp('RightSubPage-${widget.id}.txt',
            (jsonString) {
          RightSubPageData data =
          RightSubPageData.fromJson(json.decode(jsonString));
          pageNum = data.pageNum;
          totalPageNum = data.totalPageNum;
          setState(() {
            if (pageNum == 1) {
              list = data.results;
            } else {
              list.addAll(data.results);
            }
          });
        });
    reqData();
  }

  void reqData({Function callback}) {
    Req.getRightSubPage(
        itemGroupLevelIds: widget.id.toString(),
        pageNum: pageNum,
        callback: (RightSubPageData data, String json) {
          totalPageNum = data.totalPageNum;
          setState(() {
            if (pageNum == 1) {
              list = data.results;
            } else {
              list.addAll(data.results);
            }
          });
          if (callback != null) callback();
          FileUtils.writeFileToTemp(
              context, 'RightSubPage-${widget.id}.txt', json);
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: SmartRefresher(
        enablePullUp: true,
        controller: _controller,
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
                    style: TextStyle(fontSize: 18, color: Config.GREY_909399),
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
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onRefresh() {
    pageNum = 1;
    reqData(callback: () {
      _controller.refreshCompleted();
    });
  }

  void _onLoading() {
    if (pageNum + 1 > totalPageNum) {
      _controller.loadComplete();
    } else {
      pageNum++;
      reqData(callback: () {
        _controller.loadComplete();
      });
    }
  }
}

enum RightProp { ZUI_XIN, BU_XIAN_SHU_XING, FU_JIN }
