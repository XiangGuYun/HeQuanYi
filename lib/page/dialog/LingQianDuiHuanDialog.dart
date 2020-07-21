import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wobei/bean/ChangeCardListData.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/page/dialog/BaseDialog.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 零钱兑换对话框
///
///********************************************************************************************
class LingQianDuiHuanDialog extends BaseDialog {
  final Function rightBtnClick;
  final Result result;
  LingQianDuiHuanDialog({this.result, this.rightBtnClick});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 295,
          height: 425,
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
              Image.asset(
                Config.CHANGE_DIALOG,
                width: double.infinity,
                height: 90,
                fit: BoxFit.fill,
              ),
              Container(
                child: Text(
                  '零钱兑换卡',
                  style: TextStyle(color: Config.BLACK_303133, fontSize: 22),
                ),
                margin: EdgeInsets.only(left: 30, bottom: 5, top: 30),
              ),
              Container(
                child: Text(
                  '兑换后，可在我的钱包进行提现',
                  style: TextStyle(fontSize: 14, color: Config.GREY_909399),
                ),
                margin: EdgeInsets.only(left: 30, bottom: 30),
              ),
              Container(
                child: Text(
                  '兑换零钱(元)',
                  style: TextStyle(fontSize: 12, color: Config.GREY_909399),
                ),
                margin: EdgeInsets.only(left: 30),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, bottom: 20),
                child: Text(
                  result.changePrice.toString(),
                  style: TextStyle(
                      fontSize: 32,
                      color: Config.BLACK_303133,
                      fontFamily: 'money'),
                ),
              ),
              Container(
                child: Text(
                  '所需禾贝',
                  style: TextStyle(fontSize: 12, color: Config.GREY_909399),
                ),
                margin: EdgeInsets.only(left: 30),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, bottom: 20),
                child: Text(
                  result.score.toString(),
                  style: TextStyle(
                      fontSize: 32,
                      color: Config.BLACK_303133,
                      fontFamily: 'money'),
                ),
              ),
              Expanded(
                child: SizedBox(height: 1,),
                flex: 1,
              ),
              Divider(height: 1, color: Config.DIVIDER_COLOR,),
              Container(
                width: double.infinity,
                height: 60,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: GestureDetector(
                          child: Text('再想想', style: TextStyle(fontSize: 16, color: Color(0xffa5a3ac)),),
                          onTap: (){
                            context.pop();
                          },
                          behavior: HitTestBehavior.opaque,
                        ),
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
                      child: Center(
                        child: GestureDetector(
                          onTap: rightBtnClick,
                          behavior: HitTestBehavior.opaque,
                          child: Text('确认兑换', style: TextStyle(fontSize: 16, color: Color(0xff393649)),),
                        ),
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
