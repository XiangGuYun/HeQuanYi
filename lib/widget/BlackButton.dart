import 'package:flutter/material.dart';
import 'package:wobei/constant/Config.dart';
import '../my_lib/extension/BaseExtension.dart';

class BlackButton extends StatefulWidget {
  ///按钮文本
  final String text;

  ///按钮点击事件
  final Function onClickListener;

  final bool isStroke;

  final bool isGrey;

  BlackButton(
      {Key key,
      this.text,
      this.onClickListener,
      this.isStroke = false,
      this.isGrey = false})
      : super(key: key);

  @override
  _BlackButtonState createState() => _BlackButtonState();
}

class _BlackButtonState extends State<BlackButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClickListener,
      child: Container(
        width: context.getSrnW() - 40,
        height: 50,
        alignment: Alignment.center,
        decoration: widget.isStroke
            ? BoxDecoration(
                border: Border.all(color: Color(0xff393649), width: 1),
                borderRadius: BorderRadius.circular(5))
            : BoxDecoration(
                color: widget.isGrey ? Config.BTN_ENABLE_FALSE : Color(0xff393649),
                borderRadius: BorderRadius.circular(5)),
        child: Text(
          widget.text,
          style: TextStyle(
              fontSize: 16,
              color: widget.isStroke
                  ? Color(0xff393649)
                  : Colors.white),
        ),
      ),
    );
  }
}
