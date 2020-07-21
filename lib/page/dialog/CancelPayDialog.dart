import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/page/dialog/BaseDialog.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 退出登录对话框
///
///********************************************************************************************
class CancelPayDialog extends BaseDialog {
  final Function rightClick;

  CancelPayDialog({this.rightClick});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 295,
          height: 214,
          decoration: BoxDecoration(
            //setBackgroundColor强化版
            //设置边框颜色和宽度以及样式
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: '是否取消支付？'.text(Config.BLACK_393649, 18),
              ).setExpanded(1),
              Divider(
                height: 1.0,
                indent: 0.0,
                color: Color(0xFFEDECEE),
              ),
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12))),
                          alignment: Alignment.center,
                          child: Text(
                            '取消',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xffa5a3ac)),
                          ),
                        ),
                        onTap: () {
                          context.pop();
                        },
                      ),
                    ),
                    Container(
                      width: 1,
                      height: double.infinity,
                      color: Color(0xFFEDECEE),
                      margin: EdgeInsets.only(top: 22.5, bottom: 22.5),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(12))),
                          alignment: Alignment.center,
                          child: Text(
                            '确定',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xff393649)),
                          ),
                        ),
                        onTap: rightClick,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
