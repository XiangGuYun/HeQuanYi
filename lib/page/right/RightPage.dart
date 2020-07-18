import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wobei/bean/RightClassData.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/BaseState.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/utils/FileUtils.dart';
import 'package:wobei/widget/MyIndicator.dart';
import 'package:wobei/widget/MyTab.dart';
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

class _MyAppState extends BaseState<RightPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  TextStyle selectStyle, unSelectStyle;
  int currentIndex = 0;
  double fontSize1 = 18.0;
  double fontSize2 = 16.0;

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
    selectStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    unSelectStyle = TextStyle(fontSize: 16);
    _controller = TabController(vsync: this, length: Global.classNumber);
    //监听Tab切换事件
    FileUtils.getStringFromTemp('right_class_data.txt', (s) {
      List list = json.decode(s);
      List<RightClassData> dataList = list.map((data) => RightClassData.fromJson(data)).toList();
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
  Widget getContentPage() {
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
                      '最新'.text('#393649'.color(), 14),
                      SizedBox(
                        width: 4,
                      ),
                      Image.asset(
                        Config.FOLD,
                        width: 12,
                        height: 12,
                      )
                    ],
                  ).setExpanded(1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      '不限属性'.text('#393649'.color(), 14),
                      SizedBox(
                        width: 4,
                      ),
                      Image.asset(
                        Config.FOLD,
                        width: 12,
                        height: 12,
                      )
                    ],
                  ).setExpanded(1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      '附近'.text('#393649'.color(), 14),
                      SizedBox(
                        width: 4,
                      ),
                      Image.asset(
                        Config.FOLD,
                        width: 12,
                        height: 12,
                      )
                    ],
                  ).setExpanded(1),
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
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          Center(
            child: Text("Tab1-新闻世界"),
          ),
          Center(
            child: Text("Tab2-花之舞"),
          ),
          Center(
            child: Text("Tab3-联系人"),
          ),
          Center(
            child: Text("Tab4-联系人"),
          ),
          Center(
            child: Text("Tab4-联系人"),
          ),
          Center(
            child: Text("Tab4-联系人"),
          ),
          Center(
            child: Text("Tab4-联系人"),
          ),
        ],
      ),
    );
  }
}

class RightSubPage extends StatefulWidget {
  @override
  _RightSubPageState createState() => _RightSubPageState();
}

class _RightSubPageState extends State<RightSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
