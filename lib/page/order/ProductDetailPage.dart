import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wobei/bean/ProductDetailData.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/BaseState.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/utils/FileUtils.dart';
import 'package:wobei/widget/BlackButton.dart';
import 'package:wobei/widget/TitleBar.dart';
import 'package:wobei/widget/VipPriceText.dart';

import '../../my_lib/extension/BaseExtension.dart';

///=============================================================================
///商品详情
///=============================================================================
class ProductDetailPage extends StatefulWidget {
  final int goodsId;

  ProductDetailPage({this.goodsId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends BaseState<ProductDetailPage>  {
  /// 标题栏不透明度
  double titleBarOpacity = 0.0;

  /// 滚动监听器
  ScrollController _controller = new ScrollController();

  /// 详情页数据
  ProductDetailData detailData;

  @override
  void initState() {
    super.initState();
    var oneHeightOpacity = 1 / (44 + getStatusBarHeight());
    _controller.addListener(() {
      var opacity = _controller.offset * oneHeightOpacity;
      print(opacity);
      setState(() {
        if (opacity >= 0.0) {
          titleBarOpacity = min(1.0, opacity);
        }
      });
    });

    FileUtils.getStringFromTemp('ProductDetailPage-${myWidget.goodsId}.txt',
        (jsonStr) {
      ProductDetailData data = ProductDetailData.fromJson(json.decode(jsonStr));
      setState(() {
        detailData = data;
      });
    });

    startLoading();
    Req.getVipShopDetail(myWidget.goodsId,
        (ProductDetailData data, String jsonStr) {
      stopLoading();
      setState(() {
        detailData = data;
      });
      FileUtils.writeFileToTemp(
          context, 'ProductDetailPage-${myWidget.goodsId}.txt', jsonStr);
    });
  }

  @override
  Widget getContentPage() {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: context.getSrnW(),
                  height: context.getSrnH() / 2,
                  child: Stack(
                    children: <Widget>[
                      detailData == null
                          ? SizedBox(
                        width: context.getSrnW(),
                        height: context.getSrnH() / 2,
                      )
                          : CachedNetworkImage(
                        imageUrl: detailData.logo,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      InkWell(
                        child: Container(
                          child: Image.asset(
                            Config.BACK_BLACK,
                            width: 22,
                            height: 22,
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                              left: 20, top: 10 + getStatusBarHeight()),
                        ),
                        onTap: () {
                          context.pop();
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: detailData == null
                          ? SizedBox()
                          : VipPriceText(price: detailData.vipPrice.toString()),
                      margin: EdgeInsets.only(left: 20, top: 24),
                    ),
                    Container(
                      child: Image.asset(
                        Config.HECARD_PRICE,
                        width: 26,
                        height: 12,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(left: 4, top: 34),
                    ),
                    Container(
                      child: Text(
                        detailData == null ? '' : '¥ ${detailData.price}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xffA5A3AC),
                            fontFamily: 'money'),
                      ),
                      margin: EdgeInsets.only(left: 12, top: 32),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    detailData == null ? '' : detailData.name,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff393649),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  child: Divider(
                    height: 1,
                    color: Config.DIVIDER_COLOR,
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 24),
                ),
                Container(
                  child: Text(detailData == null ? '' : detailData.goodsDesc,
                      style: TextStyle(fontSize: 14, color: Color(0xffa5a3ac)),
                      strutStyle: StrutStyle(
                          forceStrutHeight: true, height: 1, leading: 0.5)),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 24),
                ),
                Container(
                  width: double.infinity,
                  margin:
                  EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 90),
                  child: Column(
                    children: detailData == null
                        ? []
                        : detailData.egImgs
                        .map((e) => CachedNetworkImage(
                      imageUrl: e,
                    ))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
          Opacity(
            child: Container(
              width: double.infinity,
              height: 44 + getStatusBarHeight(),
              color: Colors.white,
              alignment: Alignment.bottomLeft,
              child: TitleBar(title: '商品详情'),
            ),
            opacity: titleBarOpacity,
          ),
          Align(
            child: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Divider(
                    height: 1,
                    color: Config.DIVIDER_COLOR,
                  ),
                  Container(
                    child: BlackButton(
                      text: '立即购买',
                      onClickListener: () {},
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                  )
                ],
              ),
            ),
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }
}
