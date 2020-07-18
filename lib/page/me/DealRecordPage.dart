import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frame_animate_widget/frame_animate_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/DealRecordData.dart';
import 'package:wobei/bean/HeBeiDetailData.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/enum/JumpType.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 交易记录与禾贝明细页
///
///********************************************************************************************
class DealRecordPage extends StatefulWidget {
  final JumpFrom from;

  DealRecordPage({this.from});

  @override
  _DealRecordPageState createState() => _DealRecordPageState();
}

class _DealRecordPageState extends State<DealRecordPage> with BaseUtils {
  /// 列表当前页
  var currentPage = 1;

  /// 列表总页数
  var totalPageNum = 1;

  /// 禾贝明细列表
  List<HebeiDetailResult> heBeiDetailList = [];

  /// 交易明细列表
  List<DealRecordResult> dealRecordList = [];

  /// 用于控制下拉刷新动画的全局键
  var keyRefresh = GlobalKey<FrameAnimationImageState>();

  var showEmptyPage = false;

  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    if(!Global.isDarkText){
      setStatusBarColor(true, Colors.transparent);
    }
    if (widget.from == JumpFrom.HEBEI_SHOP) {
      reqHeBeiDetail();
    } else {
      reqDealRecord();
    }
  }

  void reqHeBeiDetail({Function callback = null}){
    Req.getHeBeiDetail(currentPage, (HeBeiDetailData data) {
      totalPageNum = data.totalPageNum;
      setState(() {
        heBeiDetailList.addAll(data.results);
        showEmptyPage = heBeiDetailList.length == 0;
      });
      if(callback != null){
        callback();
      }
    });
  }

  void reqDealRecord({Function callback = null}){
    Req.getPacketFlowWater(currentPage, (DealRecordData data) {
      totalPageNum = data.totalPageNum;
      setState(() {
        dealRecordList.addAll(data.results);
        showEmptyPage = dealRecordList.length == 0;
      });
      if(callback != null){
        callback();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    keyRefresh.currentState.stopAnimation();
    if(widget.from == JumpFrom.MY_PACKET){
      setStatusBarColor(false, Colors.transparent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(top: 44+getStatusBarHeight()),
            child: SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              footer: CustomFooter(
                builder: (BuildContext context,LoadStatus mode){
                  Widget body ;
                  if(mode==LoadStatus.idle){
                    body =  Text("已经到底啦！");
                  }
                  else if(mode==LoadStatus.loading){
                    body =  CupertinoActivityIndicator();
                  }
                  else if(mode == LoadStatus.failed){
                    body = Text("Load Failed!Click retry!");
                  }
                  else if(mode == LoadStatus.canLoading){
                    body = Text("release to load more");
                  }
                  else{
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child:body),
                  );
                },
              ),
              header: CustomHeader(
                  builder: (BuildContext context, RefreshStatus mode) {
                    return Container(
                      height: 100,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 100,
                            right: 100,
                            bottom: 0,
                            child: FrameAnimationImage(
                              keyRefresh,
                              Global.frameList,
                              width: 200,
                              height: 30,
                              interval: 20,
                              start: true,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
              controller: _refreshController,
              child: ListView.builder(
                  itemCount: widget.from == JumpFrom.HEBEI_SHOP
                      ? heBeiDetailList.length
                      : dealRecordList.length,
                  itemBuilder: (context, index) {
                    return getListItem(context, index);
                  }),
            ),
          ),
          getEmptyPage(),
          TitleBar(
            title: widget.from == JumpFrom.HEBEI_SHOP ? '禾贝明细' : '交易记录',
          ),
        ],
      ),
    );
  }

  getEmptyPage() {
    return Container(
      width: context.getSrnW(),
      height: context.getSrnH(),
      color: Colors.white,
      margin: EdgeInsets.only(top: 44 + getStatusBarHeight()),
      padding: EdgeInsets.only(top: 160),
      alignment: Alignment.topCenter,
      child: (widget.from == JumpFrom.HEBEI_SHOP ? '暂无明细' : '暂无记录')
          .text(Config.GREY_C0C4CC, 22),
    ).setVisible2(showEmptyPage);
  }

  getTopArea(int index) {
    if (index == 0) {
      return SizedBox(
        height: 44,
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  Widget getListItem(BuildContext context, int index) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 80,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Text(
                    widget.from == JumpFrom.HEBEI_SHOP
                        ? heBeiDetailList[index].content.maxLength(15)
                        : dealRecordList[index].content.maxLength(15),
                    style: TextStyle(fontSize: 16, color: Config.BLACK_303133),
                  ),
                  left: 20,
                  top: 20,
                ),
                Positioned(
                  child: Text(
                    widget.from == JumpFrom.HEBEI_SHOP
                        ? heBeiDetailList[index].dayView
                        : dealRecordList[index].dayView,
                    style: TextStyle(fontSize: 12, color: Config.GREY_909399),
                  ),
                  left: 20,
                  bottom: 20,
                ),
                Positioned(
                  child: Text(
                    getRightText(index),
                    style: TextStyle(fontSize: 16, color: Config.BLACK_303133),
                  ),
                  right: 20,
                  top: 20,
                ),
                Positioned(
                  child: Divider(
                    height: 1,
                    color: Config.DIVIDER_COLOR,
                    indent: 20,
                    endIndent: 20,
                  ),
                  left: 0,
                  right: 0,
                  bottom: 0,
                )
              ],
            ),
          )
        ],
      ),
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.from == JumpFrom.MY_PACKET)
          Navigator.of(context).pushNamed(AppRoute.DEAL_DETAIL_PAGE, arguments: dealRecordList[index].id);
      },
    );
  }

  String getRightText(int index) {
    if (widget.from == JumpFrom.HEBEI_SHOP) {
      if (heBeiDetailList[index].flowType == 1) {
        return '+${heBeiDetailList[index].score}';
      } else {
        return '-${heBeiDetailList[index].score}';
      }
    } else {
      if (dealRecordList[index].flowType == 1) {
        return '+${dealRecordList[index].money}';
      } else {
        return '-${dealRecordList[index].money}';
      }
    }
  }

  ///---------------------------------------------------------------------------
  /// 下拉刷新
  ///---------------------------------------------------------------------------
  void _onRefresh() async {
   currentPage = 1;
   if (widget.from == JumpFrom.HEBEI_SHOP) {
     heBeiDetailList.clear();
     reqHeBeiDetail(callback: (){
       _refreshController.refreshCompleted();
     });
   } else {
     dealRecordList.clear();
     reqDealRecord(callback: (){
       _refreshController.refreshCompleted();
     });
   }
  }

  ///---------------------------------------------------------------------------
  /// 上拉加载
  ///---------------------------------------------------------------------------
  void _onLoading() {
    if(currentPage+1 > totalPageNum){
      _refreshController.loadComplete();
    } else {
      currentPage++;
      if (widget.from == JumpFrom.HEBEI_SHOP) {
        reqHeBeiDetail(callback: (){
          _refreshController.loadComplete();
        });
      } else {
        reqDealRecord(callback: (){
          _refreshController.loadComplete();
        });
      }
    }
  }
}
