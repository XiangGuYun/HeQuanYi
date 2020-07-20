import 'package:flutter/material.dart';
import 'package:frame_animate_widget/frame_animate_widget.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import '../my_lib/extension/BaseExtension.dart';

abstract class BaseState<T extends StatefulWidget> extends State
    with BaseUtils {


  /// 用于控制网络加载动画的全局键
  final key = GlobalKey<FrameAnimationImageState>();

  /// 网络加载动画
  var _loadingAnim;

  var _loading = false;

  T getWidget() {
    return widget as T;
  }

  T get myWidget => widget as T;

  @override
  void initState() {
    super.initState();
    if(key != null){
      _loadingAnim = FrameAnimationImage(
        key,
        Global.netLoadingImgList,
        width: 200,
        height: 200,
        interval: 20,
        start: false,
      );
    }

  }

  void startLoading() {
    setState(() {
      _loading = true;
    });
    if(key != null){
      key?.currentState?.startAnimation();
    }
  }

  void stopLoading() {
    setState(() {
      _loading = false;
    });
    key?.currentState?.stopAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        getContentPage(),
        Center(
          child: _loadingAnim,
        ).setVisible2(_loading)
      ],
    );
  }

  Widget getContentPage();
}
