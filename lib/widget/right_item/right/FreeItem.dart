import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wobei/constant/Config.dart';
import '../../../my_lib/extension/BaseExtension.dart';

class FreeItem extends StatefulWidget {

  final String imgUrl;
  final String title;
  final bool isHeCaZhuanShu;


  FreeItem({this.imgUrl, this.title, this.isHeCaZhuanShu = false});

  @override
  _FreeItemState createState() => _FreeItemState();
}

class _FreeItemState extends State<FreeItem> {
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
              placeholder: (ctx, url) => Image.asset(Config.COVER_120_90, width: 120, height: 90,),
              fit: BoxFit.cover,
              fadeOutDuration: Duration(milliseconds: 10),
              fadeInDuration: Duration(milliseconds: 300),
            ),
          ),
          Positioned(
            child: Column(
              children: <Widget>[
                widget.title.text(Config.BLACK_393649, 16),
                SizedBox(height: 8,),
                Image.asset(Config.HECARD_ONLY, width: 44, height: 14, fit: BoxFit.fill,).setVisible2(widget.isHeCaZhuanShu),
              ],
            ),
            left: 152,
            right: 20,
            top: 16,
          ),
          Positioned(
            child: '免费领'.text(Color(0xFFB3926F), 14),
            left: 152,
            bottom: 18,
          ),
          Positioned(
            child: Divider(height: 1, color: Config.DIVIDER_COLOR,),
            left: 20,
            right: 20,
            bottom: 0,
          )
        ],
      ),
    );
  }
}
