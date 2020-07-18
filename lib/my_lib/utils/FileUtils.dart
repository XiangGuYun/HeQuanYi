import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

///********************************************************************************************
///
/// 文件工具类
///
///********************************************************************************************
class FileUtils{

  ///---------------------------------------------------------------------------
  /// 将数据内容写入指定文件中
  ///---------------------------------------------------------------------------
  static Future<bool> writeFileToTemp(BuildContext context, String fileName, String content) async {
    Directory documentsDir = await getTemporaryDirectory();
    String path = documentsDir.path;
    File file = File(path+'/'+fileName);
    if(!file.existsSync()){
      file.createSync();
    }
    File saveFile = await file.writeAsString(content);
    return saveFile.existsSync();
  }

  static void getStringFromTemp(String fileName, Function callback) async {
    Directory documentsDir = await getTemporaryDirectory();
    String path = documentsDir.path;

    File file = new File('$path/$fileName');
    if(!file.existsSync()) {
      return;
    }
    String result = await file.readAsString();
    callback(result);
  }


}