
import 'dart:io';

import 'package:flutter/services.dart';

class WebPlugin{

  static const platform = const MethodChannel('samples.flutter.io/common');

  static void show(String url) async{
    if(Platform.isAndroid){
      Map<String, Object> map = {"url": url};
      await platform.invokeMethod('goToWebView', map);
    }
  }

}