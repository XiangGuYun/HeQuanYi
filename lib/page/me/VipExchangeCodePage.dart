import 'package:flutter/material.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/widget/BlackButton.dart';
import 'package:wobei/widget/EditText.dart';
import 'package:wobei/widget/TitleBar.dart';
import '../../my_lib/extension/BaseExtension.dart';

///********************************************************************************************
///
/// 会员兑换码
///
///********************************************************************************************
class VipExchangeCodePage extends StatefulWidget {
  @override
  _VipExchangeCodePageState createState() => _VipExchangeCodePageState();
}

class _VipExchangeCodePageState extends State<VipExchangeCodePage>
    with BaseUtils {
  var hint = '如何获取？\n通过不定期「运营活动」向幸运的你发放，或可以通过各大合作平台获取兑换码。';

  var valueInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 44 + getStatusBarHeight(),
                ),
                SizedBox(
                  height: 80,
                ),
                EditText(
                  context.getSrnW() - 183,
                  height: 30,
                  padding: EdgeInsets.only(top: 7),
                  hint: '请输入兑换码，区分大小写',
                  inputType: TextInputType.visiblePassword,
                  textColor: Config.BLACK_303133,
                  maxLength: 19,
                  textSize: 16,
                  onChanged: (value){
                    valueInput = value;
                  },
                  controller: TextEditingController.fromValue(TextEditingValue(
                    // 设置内容
                      text: valueInput,
                      // 保持光标在最后
                      selection: TextSelection.fromPosition(TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: valueInput.length,
                      )))),
                ),
                Divider(
                  height: 18.5,
                  color: Config.DIVIDER_COLOR,
                  indent: 40,
                  endIndent: 40,
                ),
                SizedBox(
                  height: 40,
                ),
                BlackButton(
                  text: '兑换',
                ).setMargin1(left: 40, right: 40),
                SizedBox(
                  height: 20,
                ),
//                strutStyle: StrutStyle(forceStrutHeight: true, height: 1, leading: 0.8),
                Text(
                  hint,
                  strutStyle: StrutStyle(forceStrutHeight: true, height: 1.6, ),
                  style: TextStyle(fontSize: 14, color: Config.GREY_909399),
                ).setMargin1(left: 40, right: 40)
              ],
            ),
            TitleBar(title: '会员兑换码')
          ],
        ),
      ),
    );
  }
}
