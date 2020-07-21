
import 'package:flutter/material.dart';
import 'package:wobei/common/Global.dart';

class BaseDialog extends Dialog{

  /// 显示对话框，注意这里的context必须是取自StatefulWidget
  void show(BuildContext context){
    Global.stackNumber += 1;
    showDialog(context: context,
        builder: (context){
          return this;
        });
  }

}