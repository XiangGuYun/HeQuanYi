import 'package:flutter/material.dart';
import 'package:frame_animate_widget/frame_animate_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/page/me/MessageCenterData.dart';
import 'package:wobei/widget/MyIndicator.dart';
import 'package:wobei/widget/MyTab.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';


///********************************************************************************************
///
/// 我的订单
///
///********************************************************************************************
class MyOrderPage extends StatefulWidget {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> with SingleTickerProviderStateMixin, BaseUtils{
  TabController _controller;
  TextStyle selectStyle, unSelectStyle;
  int currentIndex = 0;
  double fontSize1 = 18.0;
  double fontSize2 = 16.0;

  int pageNumPush = 1;
  int pageNumNotification = 1;

  int totalPageNumPush = 1;
  int totalPageNumNotification = 1;

  /// 推送列表
  List<Result> listPush = [];

  /// 通知列表
  List<Result> listNotification = [];

  ///当组件销毁时调用
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  /// 用于控制网络加载动画的全局键
  final keyLoading = GlobalKey<FrameAnimationImageState>();

  /// 网络加载动画
  var loadingAnim;

  var loading = false;

  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    loadingAnim = FrameAnimationImage(
      keyLoading,
      Global.netLoadingImgList,
      width: 200,
      height: 200,
      interval: 20,
      start: true,
    );

    selectStyle = TextStyle(fontSize: 16, color: Config.BLACK_393649);
    unSelectStyle = TextStyle(fontSize: 16, color: Config.GREY_909399);
    _controller = TabController(vsync: this, length: 5);
    //监听Tab切换事件
    _controller.addListener(() {

    });

    setState(() {
      loading = true;
    });
    // 获取推送列表
    Req.getMessageCenterData(1, pageNumPush, (MessageCenterData data) {
      totalPageNumPush = data.totalPageNum;
      setState(() {
        listPush.addAll(data.results);
      });
      // 获取通知列表
      Req.getMessageCenterData(2, pageNumPush, (MessageCenterData data) {
        totalPageNumNotification = data.totalPageNum;
        setState(() {
          listNotification.addAll(data.results);
          loading = false;
        });
        keyLoading.currentState.stopAnimation();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44 + getStatusBarHeight() + 50),
        child: Container(
          width: context.getSrnW(),
          height: 44.0 + getStatusBarHeight() + 50,
          child: Column(
            children: <Widget>[
              TitleBar(
                title: '我的订单',
                needDivider: false,
              ),
              TabBar(
                isScrollable: false,
                labelPadding: EdgeInsets.only(left: 0, right: 0),
                controller: _controller,
                indicator: MyTabIndicator(
                  // 设置指示器的粗细和颜色
                  borderSide: BorderSide(width: 3, color: Config.RED_B3926F),
                  // 设置指示器的宽度
                  indicatorWidth: 10,
                ),
                labelStyle: selectStyle,
                unselectedLabelStyle: unSelectStyle,
                labelColor: Config.BLACK_393649,
                unselectedLabelColor: Config.GREY_909399,
                tabs: <Widget>[
                  MyTab(
                    text: "全部",
                  ),
                  MyTab(
                    text: "待付款",
                  ),
                  MyTab(
                    text: "待发货",
                  ),
                  MyTab(
                    text: "已完成",
                  ),
                  MyTab(
                    text: "已退款",
                  ),
                ],
              ).setSizedBox(height: 49),
              Divider(
                height: 1,
                color: Config.DIVIDER_COLOR,
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          TabBarView(
            controller: _controller,
            children: <Widget>[
              Container(
              ),
              Container(
              ),
              Container(
              ),
              Container(
              ),
              Container(
              ),
            ],
          ),
          Center(
            child: loadingAnim,
          ).setVisible2(loading)
        ],
      ),
    );
  }

  getEmptyPage(String text, {bool visible = false}) {
    return Container(
      child: text.text(Config.GREY_C0C4CC, 22),
      width: context.getSrnW(),
      height: double.infinity,
      color: Colors.white,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 160),
    ).setVisible2(visible);
  }

  getPushNotificationList(List<Result> list, bool isPush) {
    return SmartRefresher(
      child: ListView.builder(
          itemCount: list.length,
          itemExtent: 60,
          itemBuilder: (ctx, i) {
            return Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: '${listPush[i].title}'
                        .text(Config.BLACK_303133, 14),
                    left: 20,
                    top: 10,
                  ),
                  Positioned(
                    child: list[i].pushTime.text(Config.GREY_909399, 12),
                    left: 20,
                    bottom: 10,
                  ),
                  Positioned(
                    child: Divider(
                      height: 1,
                      color: Config.DIVIDER_COLOR,
                    ),
                    left: 20,
                    right: 20,
                    bottom: 0,
                  ),
                  Positioned(
                    child: Image.asset(
                      Config.DETAIL_LIGHT,
                      width: 12,
                      height: 12,
                    ),
                    right: 20,
                    top: 24,
                  ),
                  Positioned(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: '#E64545'.color(),
                          borderRadius:
                          BorderRadius.all(Radius.circular(4))),
                    ),
                    top: 26,
                    right: 37,
                  ),
                ],
              ),
            );
          }),
      enablePullDown: false,
      enablePullUp: true,
      onLoading: (){
        _onLoading(isPush);
      },
      controller: _refreshController,
    );
  }

  void _onLoading(bool isPush) async{
    if(isPush){
      if(pageNumPush+1 > totalPageNumPush){
        _refreshController.loadComplete();
      } else {
        pageNumPush++;
        Req.getMessageCenterData(1, pageNumPush, (MessageCenterData data) {
          _refreshController.loadComplete();
          totalPageNumPush = data.totalPageNum;
          setState(() {
            listPush.addAll(data.results);
          });
        });
      }
    } else {
      if(pageNumNotification+1 > totalPageNumNotification){
        _refreshController.loadComplete();
      } else {
        pageNumNotification++;
        Req.getMessageCenterData(1, pageNumNotification, (MessageCenterData data) {
          _refreshController.loadComplete();
          totalPageNumNotification = data.totalPageNum;
          setState(() {
            listNotification.addAll(data.results);
          });
        });
      }
    }
  }
}
