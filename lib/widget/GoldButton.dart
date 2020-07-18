import 'package:flutter/material.dart';
import 'package:wobei/constant/Config.dart';
import '../my_lib/extension/BaseExtension.dart';

class GoldButton extends StatefulWidget {
  ///按钮文本
  final String text;

  ///按钮点击事件
  final Function onClickListener;

  GoldButton(
      {Key key, this.text, this.onClickListener})
      : super(key: key);

  @override
  _GoldButtonState createState() => _GoldButtonState();
}

class _GoldButtonState extends State<GoldButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClickListener,
      child: Container(
        width: context.getSrnW() - 40,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xffFFE2C0), Color(0xFFE6BF96)]),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          widget.text,
          style: TextStyle(fontSize: 16, color: Config.BLACK_303133),
        ),
      ),
    );
  }
}
