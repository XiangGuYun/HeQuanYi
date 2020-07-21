import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wobei/bean/RightDetailData.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/EventBus.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/my_lib/utils/FileUtils.dart';
import 'package:wobei/my_lib/utils/SPUtils.dart';
import 'package:wobei/widget/BlackButton.dart';
import 'package:wobei/widget/right_item/RightDetailBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 权益详情页
///
///********************************************************************************************
class RightDetailPage extends StatefulWidget {
  final int id;

  RightDetailPage({Key key, this.id}) : super(key: key);

  @override
  _RightDetailPageState createState() => _RightDetailPageState();
}

class _RightDetailPageState extends State<RightDetailPage> with BaseUtils {
  RightDetailData data;

  double topBarOpacity = 0.0;

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    FileUtils.getStringFromTemp('RightDetailPage-${widget.id}.txt', (jsonStr) {
      RightDetailData data = RightDetailData.fromJson(json.decode(jsonStr));
      setState(() {
        this.data = data;
      });
    });

    Req.getRightDetail(widget.id, (RightDetailData data, String jsonStr) {
      setState(() {
        this.data = data;
      });
      FileUtils.writeFileToTemp(
          context, 'RightDetailPage-${widget.id}.txt', jsonStr);
    });

    _controller.addListener(() {
      if (_controller.offset > 100) {
        setState(() {
          topBarOpacity =
              min(_controller.offset / (100 + getStatusBarHeight()), 1.0);
          print("===========$topBarOpacity");
        });
      } else {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            width: context.getSrnW(),
            height: 360,
            child: data != null
                ? CachedNetworkImage(
                    imageUrl: data.logo,
                    width: context.getSrnW(),
                    height: 360,
                    fit: BoxFit.cover,
                  )
                : SizedBox(),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.5),
              width: context.getSrnW(),
              height: 360,
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            width: context.getSrnW() - 135,
            height: 180,
            margin: EdgeInsets.only(top: 16 + getStatusBarHeight(), left: 67.5),
            child: data != null
                ? CachedNetworkImage(
                    imageUrl: data.logo,
                    width: context.getSrnW() - 135,
                    height: 180,
                    fit: BoxFit.cover,
                  ).setClipRRect(8)
                : SizedBox(),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: Offset(5, 5),
                  color: Color(0x33000000),
                  blurRadius: 5.0, //控制阴影模糊度
                  spreadRadius: 2.0 //控制阴影扩散的程度，可为负数
                  ),
            ]),
          ),
          Container(
            width: context.getSrnW(),
            child: SingleChildScrollView(
              controller: _controller,
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    width: context.getSrnW(),
                    height: 150 + getStatusBarHeight(),
                    color: Colors.transparent,
                  ),
                  Container(
                    width: context.getSrnW(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: context.getSrnW(),
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 22),
                          child: data != null && data.name != null
                              ? data.name.text(Config.BLACK_393649, 18,
                                  fw: FontWeight.w600,
                                  ss: StrutStyle(height: 1))
                              : SizedBox(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: context.getSrnW(),
                          height: 77,
                          child: RightDetailBar(data),
                        ),
                        Divider(
                          height: 1,
                          color: Config.DIVIDER_COLOR,
                          indent: 20,
                          endIndent: 20,
                        ),
                        data != null && data.itemDesc != null
                            ? RightDetailItem(
                                title: '权益说明',
                                info: data.itemDesc,
                              )
                            : SizedBox(),
                        data != null && data.exchangeWay != null
                            ? RightDetailItem(
                                title: '兑换方式',
                                info: data.exchangeWay,
                              )
                            : SizedBox(),
                        data != null && data.exchangeImgs != null
                            ? Container(
                                child: Column(
                                  children: data.exchangeImgs
                                      .map((e) => CachedNetworkImage(
                                            imageUrl: e,
                                          ))
                                      .toList(),
                                ),
                              )
                            : SizedBox(),
                        data != null && data.exchangeDesc != null
                            ? RightDetailItem(
                                title: '兑换说明',
                                info: data.exchangeDesc,
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 90,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Container(
              color: Colors.white,
              height: 70,
              padding: EdgeInsets.only(left: 0, right: 0, bottom: 10),
              width: context.getSrnW(),
              child: Column(
                children: <Widget>[
                  Divider(
                    height: 1,
                    color: Config.DIVIDER_COLOR,
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  BlackButton(
                    text: '立即购买',
                    onClickListener: () {
                      if(Global.prefs.getString('token') != ''){
                        Req.createRightOrder(widget.id, (String orderId){
                          Navigator.of(context).pushNamed(AppRoute.RIGHT_PAY_PAGE,
                              arguments: orderId);
                        });
                      } else {
                        context.pop();
                        bus.emit('Scaffold', 'unlogin');
                      }
                    },
                  ).setMargin1(left: 20, right: 20)
                ],
              ),
            ),
            left: 0,
            bottom: 0,
            right: 0,
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: getStatusBarHeight(),
                  ),
                  Container(
                    height: 44,
                    color: Colors.white,
                    child: '权益详情'.text(Config.BLACK_393649, 18),
                    alignment: Alignment.center,
                  ),
                  Divider(
                    height: 1,
                    color: Config.DIVIDER_COLOR,
                  )
                ],
              ),
            ).setOpacity(topBarOpacity),
          ),
          Positioned(
            child: Image.asset(
              Config.BACK_BLACK,
              width: 24,
              height: 24,
            ).setMargin1(left: 15, top: 10 + getStatusBarHeight()).setInkWell(
                onTap: () {
              context.pop();
            }),
          ),
        ],
      ).setSizedBox(height: context.getSrnH()),
    );
  }
}

class RightDetailItem extends StatefulWidget {
  final String title;
  final String info;
  final List<String> imgUrls;

  RightDetailItem({this.title, this.info, this.imgUrls});

  @override
  _RightDetailItemState createState() => _RightDetailItemState();
}

class _RightDetailItemState extends State<RightDetailItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.title.text(Config.BLACK_393649, 18, fw: FontWeight.w600),
          SizedBox(
            height: 12,
          ),
          widget.info.text(Config.GREY_A5A3AC, 14, ss: StrutStyle(height: 1.5)),
          SizedBox(
            height: 20,
          ),
          Divider(
            height: 1,
            color: Config.DIVIDER_COLOR,
          )
        ],
      ),
    );
  }
}
