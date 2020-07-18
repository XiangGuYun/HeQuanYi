
import 'package:flutter/services.dart';
import 'package:wobei/common/Global.dart';

class LogPlugin{

  static const platform = const MethodChannel('samples.flutter.io/common');

  static void logD(String tag, String text) async{
    if(!Global.isRelease){
      Map<String, Object> map = {"tag": tag, 'text': text};
      await platform.invokeMethod('logD', map);
    }
  }

}