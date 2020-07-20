import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/enum/RightType.dart';
import 'package:wobei/page/login/LoginPage.dart';
import 'package:wobei/widget/VipPriceText.dart';

import '../../my_lib/extension/BaseExtension.dart';

class RightItem extends StatefulWidget {
  final String imgUrl;
  final String title;
  final bool isHeCaZhuanShu;
  final double leftPrice;
  final double rightPrice;
  final bool isRightPriceDelete;
  final bool isLeftPriceRed;
  final bool isRightPriceVisible;
  final bool isFreePrice;
  final int id;

//  final Function click;

  RightItem(
      {this.imgUrl,
      this.title,
      this.isHeCaZhuanShu = false,
      this.leftPrice = 0.0,
      this.rightPrice = 0.0,
      this.isRightPriceDelete = false,
      this.isLeftPriceRed = true,
      this.isRightPriceVisible = true,
      this.isFreePrice = false,
      this.id = -1,
      Key key})
      : super(key: key);

  @override
  _RightItemState createState() => _RightItemState();
}

class _RightItemState extends State<RightItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.getSrnW(),
      height: 122,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 20,
            top: 16,
            child: CachedNetworkImage(
              imageUrl: widget.imgUrl,
              width: 120,
              height: 90,
              placeholder: (ctx, url) => Image.asset(
                Config.COVER_120_90,
                width: 120,
                height: 90,
              ),
              fit: BoxFit.cover,
              fadeOutDuration: Duration(milliseconds: 10),
              fadeInDuration: Duration(milliseconds: 300),
            ).setClipRRect(4),
          ),
          Positioned(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.title.text(Config.BLACK_393649, 16),
                SizedBox(
                  height: 8,
                ),
                Image.asset(
                  Config.HECARD_ONLY,
                  width: 44,
                  height: 14,
                  fit: BoxFit.fill,
                ).setClipRRect(4).setVisible2(widget.isHeCaZhuanShu),
              ],
            ),
            left: 152,
            right: 20,
            top: 16,
          ),
          Positioned(
            child: widget.isFreePrice
                ? '免费领'.text(Color(0xFFB3926F), 14)
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      VipPriceText(
                        price: widget.leftPrice.toString(),
                        bigFontSize: 20,
                        smallFontSize: 12,
                        color: widget.isLeftPriceRed ? 0xFFB3926F : 0xFF393649,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Image.asset(
                        Config.HECARD_PRICE,
                        width: 22,
                        height: 10,
                        fit: BoxFit.fill,
                      )
                          .setMargin1(bottom: 3)
                          .setVisible2(widget.isLeftPriceRed),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '¥${widget.rightPrice}',
                        style: TextStyle(
                            color: Config.GREY_A5A3AC,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Config.GREY_A5A3AC,
                            fontFamily: 'money'),
                      ).setVisible2(widget.isRightPriceVisible)
                    ],
                  ),
            left: 152,
            bottom: 18,
          ),
          Positioned(
            child: Divider(
              height: 1,
              color: Config.DIVIDER_COLOR,
            ),
            left: 20,
            right: 20,
            bottom: 0,
          )
        ],
      ),
    ).setGestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.isFreePrice) {
            Global.RIGHT_TYPE = RightType.FREE;
          } else if (widget.isLeftPriceRed) {
            Global.RIGHT_TYPE = RightType.VIP_PRICE;
          } else if (widget.isRightPriceVisible) {
            Global.RIGHT_TYPE = RightType.NEW_PRICE;
          } else {
            Global.RIGHT_TYPE = RightType.ONE_PRICE;
          }
          Navigator.of(context)
              .pushNamed(AppRoute.RIGHT_DETAIL_PAGE, arguments: widget.id);
        });
  }
}
