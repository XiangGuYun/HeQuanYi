import 'package:flutter/material.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import '../my_lib/extension/BaseExtension.dart';

///=============================================================================
///顶部标题栏
///=============================================================================
class TitleBar extends StatelessWidget with BaseUtils {
  ///标题
  final String title;

  ///副标题
  final String subTitle;

  ///是否需要下方的分割线
  final bool needDivider;

  ///是否需要添加左右外边距
  final bool needMargin;

  ///副标题点击事件
  final Function subTitleClick;

  /// 背景是否透明
  final bool isTransparant;

  /// 需要上边距
  final bool needTopMargin;

  TitleBar(
      {Key key,
      @required this.title,
      this.subTitle = '',
      this.needDivider = true,
      this.needMargin = true,
      this.isTransparant = false,
      this.needTopMargin = true,
      this.subTitleClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isTransparant ? Colors.transparent : Colors.white,
      margin: EdgeInsets.only(top: needTopMargin?getStatusBarHeight():0),
      width: double.infinity,
      height: needTopMargin?44:44+getStatusBarHeight(),
      child: Stack(
        children: <Widget>[
          Padding(
            child: Align(
              child: GestureDetector(
                child: Image.asset(
                  isTransparant
                      ? Config.BACK_WHITE
                      : Config.BACK_BLACK,
                  width: 22,
                  height: 22,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  context.pop();
                },
              ),
              alignment: Alignment(-1, 0),
            ),
            padding: EdgeInsets.only(left: needMargin ? 20 : 0, top: needTopMargin?0:getStatusBarHeight()),
          ),
          Container(
            margin: EdgeInsets.only(top: needTopMargin?0:getStatusBarHeight()),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  color: isTransparant ? Colors.white : Color(0xff393649),
                  fontWeight: FontWeight.w500),
            ),
            alignment: Alignment.center,
          ),
          Align(
            child: Divider(
              height: 1,
              color: needDivider ? Color(0xffeeeeee) : Colors.transparent,
            ),
            alignment: Alignment.bottomLeft,
          ),
          Padding(
            child: Align(
              child: GestureDetector(
                child: Text(
                  subTitle,
                  style: TextStyle(fontSize: 14, color: Color(0xff393649)),
                ),
                onTap: subTitleClick,
              ),
              alignment: Alignment(1, 0),
            ),
            padding: EdgeInsets.only(right: needMargin ? 20 : 0, top: needTopMargin?0:getStatusBarHeight()),
          )
        ],
      ),
    );
  }
}
